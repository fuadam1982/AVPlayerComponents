//
//  YCAVPlayerVM.m
//  testModule
//
//  Created by fuhan on 2017/5/22.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import "YCAVPlayerVM.h"
#import "YCAVPlayerView.h"

@interface YCAVPlayerVM () <YCAVPlayerStates>

// MARK: YCStates
@property (nonatomic, strong) id<YCAVPlayerProps> props;
@property (nonatomic, weak) id<YCAVPlayerCallbacks> callbacks;

// MARK: YCAVPlayerStates
/** 播放中出现错误 */
@property (nonatomic, strong) NSError *error;
/** 视频的总时长(秒) */
@property (nonatomic, assign) float videoDuration;
/** 已经加载的最大时长 */
@property (nonatomic, assign) float loadedDuration;
/** 是否可以播放 */
@property (nonatomic, assign) BOOL readyToPlay;
/** 是否正在播放 */
@property (nonatomic, assign) BOOL isPlaying;
/** 是否卡顿 */
@property (nonatomic, assign) BOOL isLagged;
/** 是否已经加载完video */
@property (nonatomic, assign) BOOL isLoadedAllVideo;
/** 是否为HLS格式视频 */
@property (nonatomic, assign) BOOL isHLSVideo;
/** 已经缓存的视频所在路径，如果是HLS则为所有ts文件的目录 */
@property (nonatomic, strong) NSString *cachedVideoFolder;
/** 已经缓存的视频所在路径，如果是HLS则为第一个ts文件名 */
@property (nonatomic, strong) NSString *cachedVideoPath;
/** 当前加载网速 */
@property (nonatomic, assign) float loadSpeed;
/** 当前播放的时间点 */
@property (nonatomic, assign) float currTimePoint;
/** 当前的交互点, -1表示没有 */
@property (nonatomic, assign) NSInteger currinteractionTimePoint;

// MARK: private
/** 已加载的最大时间点 */
@property (nonatomic, assign) float loadedTimePoint;
/** 暂停preload，例如3G网络下不需要下载, 同时不需要loading */
@property (nonatomic, assign) BOOL isPausePreloading;

@end

@implementation YCAVPlayerVM

- (instancetype)initWithProps:(id<YCAVPlayerProps>)props callbacks:(id<YCAVPlayerCallbacks>)callbacks {
    if (self = [super init]) {
        self.props = props;
        self.callbacks = callbacks;
    }
    return self;
}

@end
