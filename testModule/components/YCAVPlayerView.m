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
            // todo: seek, 需要确定play和seek的先后顺序
            [self bindPlayerState];
            [self bindViewModelState];
        }];
    }];
}

#pragma mark - DataBinding

- (void)bindPlayerState {
    @weakify(self);
    // 播放状态
    [[RACObserve(self.playerItem, status)
      takeUntil:self.playerItem.rac_willDeallocSignal]
     subscribeNext:^(id status) {
         @strongify(self);
         if ([status integerValue] == AVPlayerItemStatusReadyToPlay) {
             [self videoPlayControl];
             [self.viewModel videoReadyToPlay];
         } else {
             // TODO: error
             [self.viewModel setPlayerError:nil];
         }
     }];
    
    // 播放时间
    [self.player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(kPlayerRefreshInterval, NSEC_PER_SEC)
                                              queue:self.queue
                                         usingBlock:^(CMTime time) {
                                             @strongify(self);
                                             [self.viewModel addWatchedTimeInterval:kPlayerRefreshInterval];
                                         }];
}

- (void)bindViewModelState {
    @weakify(self);
    [[RACObserve(self.viewModel.props, isPause) filter:^BOOL(id value) {
        @strongify(self);
        return self.viewModel.readyToPlay;
    }] subscribeNext:^(id isPause) {
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
    self.viewModel.props.isPause ? [self pauseVideo] : [self playVideo];
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
