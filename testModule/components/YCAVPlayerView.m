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
static NSString *kAssetKeyDuration = @"duration";
static NSString *kAssetKeyPlayable = @"playable";
static NSArray *AssetKeys = nil;

@interface YCAVPlayerView ()

@property (nonatomic, strong) dispatch_queue_t queue;
@property (nonatomic, strong) YCAVPlayerVM *viewModel;
//@property (nonatomic, strong) AVAsset *asset;
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) AVPlayer *player;

@end

@implementation YCAVPlayerView

- (instancetype)initWithProps:(id<YCProps>)props callbacks:(id<YCCallbacks>)callbacks {
    if (AssetKeys == nil) {
        AssetKeys = @[@"tracks", @"playable", @"duration", @"commonMetadata"];
    }
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

#pragma mark - build player

- (RACSignal *)buildAsset {
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        AVURLAsset *asset = [AVURLAsset URLAssetWithURL:[NSURL URLWithString:self.viewModel.props.videoURL]
                                                options:nil];
        [asset loadValuesAsynchronouslyForKeys:AssetKeys completionHandler:^{
            // 检查资源是否正常
            BOOL isSucc = YES;
            for (NSString *key in AssetKeys) {
                NSError *error = nil;
                AVKeyValueStatus keyStatus = [asset statusOfValueForKey:key error:&error];
                if (keyStatus != AVKeyValueStatusLoaded) {
                    isSucc = NO;
                    // TODO: error == nil
                    [subscriber sendError:nil];
                    break;
                }
            }
            if (!isSucc) {
                // TODO: error
                [subscriber sendError:nil];
            }
            NSTimeInterval videoDuration = CMTimeGetSeconds(asset.duration);
            if (isnan(videoDuration)) {
                // TODO: error
                [subscriber sendError:nil];
            }
            [subscriber sendNext:RACTuplePack(kAssetKeyDuration, asset, @(videoDuration))];
            [[[RACObserve(asset, playable) ignore:@NO] take:1]
             subscribeNext:^(id x) {
                [subscriber sendNext:RACTuplePack(kAssetKeyPlayable, asset)];
                [subscriber sendCompleted];
            }];
        }];
        
        return nil;
    }];
}

- (void)buildPlayer {
    @weakify(self);
    [[self buildAsset] subscribeNext:^(RACTuple *args) {
        @strongify(self);
        // 获取到视频时长
        if ([args.first isEqualToString:kAssetKeyDuration]) {
            // 创建Player
            AVAsset *asset = args.second;
            self.playerItem = [AVPlayerItem playerItemWithAsset:asset
                                   automaticallyLoadedAssetKeys:AssetKeys];
            self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
            [self addPlayerToLayer:self.player];
            // 设置视频时长
            [self.viewModel setVideoDuration:[args.third floatValue]];
        }
        // 获取到视频可播放
        if ([args.first isEqualToString:kAssetKeyPlayable]) {
            // 绑定状态
            [self bindPlayerItemState];
            [self bindPlayerState];
            [self bindViewModelState];            
            // 默认为0，即从头开始播放
            [self seekToTimePoint:self.viewModel.props.seekTimePoint];
        }
    } error:^(NSError *error) {
        @strongify(self);
        [self.viewModel setPlayerError:error];
    }];
}

#pragma mark - DataBinding

- (void)bindPlayerItemState {
    @weakify(self);
    
    // 播放状态
    [[RACObserve(self.playerItem, status)
      takeUntilBlock:^BOOL(id x) {
          @strongify(self);
          return self.playerItem == nil;
      }]
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
      takeUntilBlock:^BOOL(id x) {
          @strongify(self);
          return self.playerItem == nil;
      }]
     subscribeNext:^(NSArray *loadedTimeRange) {
         @strongify(self);
         if (loadedTimeRange.count > 0) {
             CMTimeRange timeRange = [loadedTimeRange[0] CMTimeRangeValue];
             NSTimeInterval start    = CMTimeGetSeconds(timeRange.start);
             if (isnan(start)) {
                 start = 0;
             }
             NSTimeInterval duration = CMTimeGetSeconds(timeRange.duration);
             if (isnan(duration)) {
                 duration = 0;
             }
             [self.viewModel setLoadedDuration:start duration:duration];
             NSLog(@"### loading %0.2f", duration);
         }
     }];
    
    // TODO: how to use
//    // 无buffer
//    [[RACObserve(self.playerItem, playbackBufferEmpty)
//      takeUntilBlock:^BOOL(id x) {
//          @strongify(self);
//          return self.playerItem == nil;
//      }]
//     subscribeNext:^(id x) {
//         @strongify(self);
//         NSLog(@"");
//     }];
//    // 可以恢复播放
//    [[RACObserve(self.playerItem, playbackLikelyToKeepUp)
//      takeUntilBlock:^BOOL(id x) {
//          @strongify(self);
//          return self.playerItem == nil;
//      }]
//     subscribeNext:^(id x) {
//         @strongify(self);
//         NSLog(@"");
//     }];
    
    // TODO: 精确度，loadedcomplete delegate，netspeed = 0 delegate
    [[[RACSignal interval:kPlayerRefreshInterval
             onScheduler:[RACScheduler scheduler]]
      takeUntilBlock:^BOOL(id x) {
          @strongify(self);
          BOOL flag = self.playerItem == nil || self.viewModel.isLoadCompleted || self.viewModel.isPlayFinished;
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
                                             if (isnan(currTimePoint)) {
                                                 currTimePoint = 0;
                                             }
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
    
    // 播放卡顿
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:AVPlayerItemPlaybackStalledNotification
                                                            object:nil]
      takeUntil:self.rac_willDeallocSignal]
     subscribeNext:^(id x) {
         @strongify(self);
         [self.viewModel receiveSystemStallNotify];
     }];
    
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
    // 外部取消播放
    [[RACObserve(self.viewModel.props, isCancelPlay) ignore:@NO]
     subscribeNext:^(id x) {
         @strongify(self);
         [self stopPlayerItem];
         [self.viewModel videoPlayFinishedByInterrupt:YES];
     }];
    // 外部切换数据源
    [[RACObserve(self.viewModel.props, videoURL) distinctUntilChanged]
     subscribeNext:^(id x) {
         @strongify(self);
         [self stopPlayerItem];
         [self replacePlayerItem];
     }];
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
    AVPlayerItemAccessLog *accesslog = self.player.currentItem.accessLog;
    AVPlayerItemAccessLogEvent* event = nil;
    if (accesslog.events.count > 0) {
        event = accesslog.events[0];
    }
    double netSpeed = (event.numberOfBytesTransferred / event.transferDuration) / 1024;
    // 异常处理
    if (isinf(netSpeed) || isnan(netSpeed)) {
        netSpeed = 0;
    }
    [self.viewModel setNetSpeed:netSpeed];
}

- (void)stopPlayerItem {
    [self.player replaceCurrentItemWithPlayerItem:nil];
    self.playerItem = nil;
}

- (void)replacePlayerItem {
    @weakify(self);
    [[self buildAsset] subscribeNext:^(RACTuple *args) {
        @strongify(self);
        if ([args.first isEqualToString:kAssetKeyPlayable]) {
            AVAsset *asset = args.second;
            self.playerItem = [AVPlayerItem playerItemWithAsset:asset
                                   automaticallyLoadedAssetKeys:AssetKeys];
            [self.player replaceCurrentItemWithPlayerItem:self.playerItem];
            [self bindPlayerItemState];
            [self seekToTimePoint:self.viewModel.currTimePoint];
        }
    } error:^(NSError *error) {
        @strongify(self);
        [self.viewModel setPlayerError:error];
    }];
}

#pragma mark - handle error

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
