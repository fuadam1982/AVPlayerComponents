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

@interface YCAVPlayerView ()

@property (nonatomic, strong) YCAVPlayerVM *viewModel;
@property (nonatomic, strong) AVAsset *asset;
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) AVPlayer *player;

@end

@implementation YCAVPlayerView

- (instancetype)initWithProps:(id<YCProps>)props callbacks:(id<YCCallbacks>)callbacks {
    YCAVPlayerVM *states = [[YCAVPlayerVM alloc] initWithProps:props callbacks:callbacks];
    if (self = [super initWithStates:states]) {
        [self.viewModel setPlayer:self];
        [self buildPlayer];
    }
    return self;
}

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
        
        NSTimeInterval videoDuration = CMTimeGetSeconds(self.asset.duration);
        [self.viewModel getVideoDuration:videoDuration];
        
        self.playerItem = [AVPlayerItem playerItemWithAsset:self.asset automaticallyLoadedAssetKeys:keys];
        self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
        [self addPlayerToLayer:self.player];
        
        [[[RACObserve(self.asset, playable) ignore:@NO] take:1] subscribeNext:^(id x) {
            @strongify(self);
            [self dataBinding];
        }];
    }];
}

- (void)dataBinding {
    @weakify(self);
    
    // binding avplayer stuffs
    [[RACObserve(self.playerItem, status)
      takeUntil:self.playerItem.rac_willDeallocSignal]
     subscribeNext:^(id status) {
         @strongify(self);
         if ([status integerValue] == AVPlayerItemStatusReadyToPlay) {
             [self playVideo];
             [self.viewModel videoReadyToPlay];
         } else {
             // TODO: error
             [self.viewModel setPlayerError:nil];
         }
     }];
    
    // binding props states
    [[RACObserve(self.viewModel.props, isPause) filter:^BOOL(id value) {
        @strongify(self);
        return self.viewModel.readyToPlay;
    }] subscribeNext:^(id isPause) {
        [isPause boolValue] ? [self pauseVideo] : [self playVideo];
    }];
}

#pragma mark - handle video cache



#pragma mark - player methods

- (void)playVideo {
    self.player.rate = 1;
}

- (void)pauseVideo {
    self.player.rate = 0;
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
