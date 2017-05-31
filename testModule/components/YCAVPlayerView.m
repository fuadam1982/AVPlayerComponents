//
//  YCAVPlayerView.m
//  testModule
//
//  Created by fuhan on 2017/5/22.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import "YCAVPlayerView.h"
#import "YCAVPlayerVM.h"

#pragma mark - utils
@import AVFoundation;
#import "ReactiveCocoa.h"

static NSTimeInterval kPlayerRefreshInterval = 0.5f;

@interface YCAVPlayerView ()

@property (nonatomic, strong) dispatch_queue_t queue;
@property (nonatomic, strong) YCAVPlayerVM *viewModel;
@property (nonatomic, strong) AVAsset *asset;
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) AVPlayer *player;

@end

@implementation YCAVPlayerView

- (instancetype)initWithProps:(id<YCProps>)props callbacks:(id<YCCallbacks>)callbacks {
    YCAVPlayerVM *states = [[YCAVPlayerVM alloc] initWithProps:props callbacks:callbacks];
    if (self = [super initWithStates:states]) {
        self.queue = dispatch_queue_create("CUSTOM_AVPLAYER_QUEUE", DISPATCH_QUEUE_SERIAL);
        // 设置player，用于callbacks
        [self.viewModel setPlayer:self];
        [self buildPlayer];
    }
    return self;
}

/** 包装下，用于属性访问 */
- (id<YCStates>)viewModel {
    return [self getStates];
}

- (void)buildPlayer {
    @weakify(self);
    // Asset
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:[NSURL URLWithString:self.viewModel.props.videoURL]
                                            options:nil];
    self.asset = asset;

    NSArray *keys = @[@"tracks", @"playable", @"duration", @"commonMetadata"];
    [self.asset loadValuesAsynchronouslyForKeys:keys completionHandler:^{
        @strongify(self);
        // 检查资源是否正常
        BOOL isSucc = YES;
        for (NSString *key in keys) {
            NSError *error = nil;
            AVKeyValueStatus keyStatus = [self.asset statusOfValueForKey:key error:&error];
            if (keyStatus != AVKeyValueStatusLoaded) {
                isSucc = NO;
                // TODO: error == nil
                [self.viewModel setPlayerError:error];
                break;
            }
        }
        if (!isSucc) {
            return;
        }
        // 获取视频总时长
        NSTimeInterval videoDuration = CMTimeGetSeconds(self.asset.duration);
        [self.viewModel setVideoDuration:videoDuration];

        self.playerItem = [AVPlayerItem playerItemWithAsset:self.asset automaticallyLoadedAssetKeys:keys];
        self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
        [self addPlayerToLayer:self.player];

        // 视频资源可播放
        [[[RACObserve(self.asset, playable) ignore:@NO] take:1] subscribeNext:^(id x) {
            @strongify(self);
            [self bindPlayerItemState];
            [self bindPlayerState];
            [self bindViewModelState];
            // 默认为0，即从头开始播放
            [self seekToTimePoint:self.viewModel.props.seekTimePoint];
        }];
    }];
}

#pragma mark - DataBinding

- (void)bindPlayerItemState {
    @weakify(self);
    [[[RACSignal interval:2 onScheduler:[RACScheduler scheduler]] take:1]
     subscribeNext:^(id x) {
         NSLog(@"seek to 280");
         [self seekToTimePoint:300];
     }];
    [[[RACSignal interval:3 onScheduler:[RACScheduler scheduler]] take:1]
     subscribeNext:^(id x) {
         NSLog(@"seek to 320");
         [self seekToTimePoint:320];
     }];
    // 播放状态
    [[RACObserve(self.playerItem, status)
      takeUntil:self.playerItem.rac_willDeallocSignal]
     subscribeNext:^(id status) {
         @strongify(self);
         // 每次seek后都会执行一遍，因此从头开始播放相当于seekToTime:0
         if ([status integerValue] == AVPlayerItemStatusReadyToPlay) {
             [self.viewModel videoReadyToPlay];
         } else {
             // TODO: error
             [self.viewModel setPlayerError:nil];
         }
     }];
    // 加载数据
    [[RACObserve(self.playerItem, loadedTimeRanges)
     takeUntil:self.playerItem.rac_willDeallocSignal]
     subscribeNext:^(NSArray *loadedTimeRange) {
         @strongify(self);
         if (loadedTimeRange.count > 0) {
             CMTimeRange timeRange = [loadedTimeRange[0] CMTimeRangeValue];
             NSTimeInterval start    = CMTimeGetSeconds(timeRange.start);
             NSTimeInterval duration = CMTimeGetSeconds(timeRange.duration);
             [self.viewModel setLoadedDuration:start duration:duration];
         }
     }];
    
    // TODO: how to do
//    // 无buffer
//    [[RACObserve(self.playerItem, playbackBufferEmpty)
//     takeUntil:self.playerItem.rac_willDeallocSignal]
//     subscribeNext:^(id x) {
//         @strongify(self);
//         NSLog(@"");
//     }];
//    // 可以恢复播放
//    [[RACObserve(self.playerItem, playbackLikelyToKeepUp)
//      takeUntil:self.playerItem.rac_willDeallocSignal]
//     subscribeNext:^(id x) {
//         @strongify(self);
//         NSLog(@"");
//     }];
    
    // TODO: 精确度，loadedcomplete delegate，netspeed = 0 delegate
    [self computeNetSpeed];
    [[[[RACSignal interval:kPlayerRefreshInterval
             onScheduler:[RACScheduler scheduler]]
     takeUntil:self.playerItem.rac_willDeallocSignal]
      takeUntilBlock:^BOOL(id x) {
          @strongify(self);
          BOOL flag = self.viewModel.isLoadCompleted || self.viewModel.isPlayFinished;
          if (flag) {
              [self.viewModel setNetSpeed:0];
          }
          return flag;
      }]
     subscribeNext:^(id x) {
         @strongify(self);
         [self computeNetSpeed];
     }];
}

- (void)bindPlayerState {
    @weakify(self);
    // 播放时间（低精度）
    [self.player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(kPlayerRefreshInterval, NSEC_PER_SEC)
                                              queue:self.queue
                                         usingBlock:^(CMTime time) {
                                             @strongify(self);
                                             NSTimeInterval currTimePoint = CMTimeGetSeconds(time);                                             
                                             [self.viewModel setVideoCurrTimePoint:currTimePoint];
                                         }];
    
    // 播放时间点(高精度)
    if (self.viewModel.props.interactionTimes.count > 0) {
        [self.player addBoundaryTimeObserverForTimes:self.viewModel.props.interactionTimes
                                               queue:self.queue
                                          usingBlock:^{
                                            // TODO: 
                                          }];
    }
    
    // 播放结束
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:AVPlayerItemDidPlayToEndTimeNotification
                                                            object:nil]
     takeUntil:self.rac_willDeallocSignal]
     subscribeNext:^(id x) {
         @strongify(self);
         [self.viewModel videoPlayFinishedByInterrupt:NO];
     }];
}

- (void)bindViewModelState {
    @weakify(self);
    // 外部暂停状态
    [[RACObserve(self.viewModel.props, isPause) filter:^BOOL(id value) {
        @strongify(self);
        return self.viewModel.videoDuration > 0;
    }] subscribeNext:^(id isPause) {
        @strongify(self);
        [self videoPlayControl];
    }];
    // 内部播放状态
    [[RACObserve(self.viewModel, isPlaying) filter:^BOOL(id value) {
        @strongify(self);
        return self.viewModel.videoDuration > 0;
    }] subscribeNext:^(id x) {
        @strongify(self);
        [self videoPlayControl];
    }];
}

#pragma mark - player methods

- (void)playVideo {
    self.player.rate = 1;
}

- (void)pauseVideo {
    self.player.rate = 0;
}

- (void)videoPlayControl {
    self.viewModel.isPlaying ? [self playVideo] : [self pauseVideo];
}

- (void)seekToTimePoint:(NSTimeInterval)timePoint {
    [self.player seekToTime:CMTimeMakeWithSeconds(timePoint, NSEC_PER_SEC)];
    [self.viewModel seekToTime:timePoint];
}

- (void)computeNetSpeed {
    AVPlayerItemAccessLog *accesslog = self.playerItem.accessLog;
    AVPlayerItemAccessLogEvent* event = nil;
    NSArray *events = [accesslog events];
    if (events.count > 0) {
        event = [events firstObject];
    }
    double netSpeed = (event.numberOfBytesTransferred / event.transferDuration) / 1024;
    // 异常处理
    if (isinf(netSpeed) || isnan(netSpeed)) {
        netSpeed = 0;
    }
    [self.viewModel setNetSpeed:netSpeed];
}

#pragma mark - AVPlayerLayer Setting

+ (Class)layerClass {
    return [AVPlayerLayer class];
}

- (void)addPlayerToLayer:(AVPlayer *)player {
    AVPlayerLayer *layer = (AVPlayerLayer *)[self layer];
    [layer setPlayer:player];
    [layer setVideoGravity:AVLayerVideoGravityResizeAspect];
}

@end
