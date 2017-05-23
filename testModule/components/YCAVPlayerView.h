//
//  YCAVPlayerView.h
//  testModule
//
//  Created by fuhan on 2017/5/22.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Componentable.h"

@protocol YCAVPlayerProps <NSObject>

/** 是否有网络 */
@property (nonatomic, assign, readonly) BOOL hasNetworking;
/** 是否正在使用WIFI */
@property (nonatomic, assign, readonly) BOOL isWIFINetworking;
/** 是否在非WIFI网络下继续预加载 。不需要联动*/
@property (nonatomic, assign, readonly) BOOL isWANNetworkingStopPreload;
/** 是否播放本地视频，不需要联动 */
@property (nonatomic, assign, readonly) BOOL isLocalVideo;
/** 是否缓存视频到本地 */
@property (nonatomic, assign, readonly) BOOL isCachedRemoteVideo;
/** 视频播放地址，如果发生变化即切换清晰度 */
@property (nonatomic, strong, readonly) NSString *videoURL;
/** 最小可播放时间，如果buffer时间小于该值则属于卡顿。不需要联动 */
@property (nonatomic, assign, readonly) NSInteger minPlayTime;
/** 是否暂停，默认加载好立即播放 */
@property (nonatomic, assign, readonly) BOOL isPause;
/** 从指定时间点开始播放，默认值为-1 */
@property (nonatomic, assign, readonly) NSInteger seekTimePoint;
/** 交互时间点数组, 值为NSInteger。不需要联动 */
@property (nonatomic, strong, readonly) NSArray<NSNumber *> *interactionTimes;
// TODO: 亮度、音量、

@end

@protocol YCAVPlayerStates <NSObject>

/** 播放中出现错误 */
@property (nonatomic, strong, readonly) NSError *error;
/** 视频的总时长(秒) */
@property (nonatomic, assign, readonly) float videoDuration;
/** 已经加载的最大时长 */
@property (nonatomic, assign, readonly) float loadedDuration;
/** 是否可以播放 */
@property (nonatomic, assign, readonly) BOOL readyToPlay;
/** 是否正在播放 */
@property (nonatomic, assign, readonly) BOOL isPlaying;
/** 是否卡顿 */
@property (nonatomic, assign, readonly) BOOL isLagged;
/** 是否已经加载完video */
@property (nonatomic, assign, readonly) BOOL isLoadedAllVideo;
/** 是否为HLS格式视频 */
@property (nonatomic, assign, readonly) BOOL isHLSVideo;
/** 已经缓存的视频所在路径，如果是HLS则为所有ts文件的目录 */
@property (nonatomic, strong, readonly) NSString *cachedVideoFolder;
/** 已经缓存的视频所在路径，如果是HLS则为第一个ts文件名 */
@property (nonatomic, strong, readonly) NSString *cachedVideoPath;
/** 当前加载网速 */
@property (nonatomic, assign, readonly) float loadSpeed;
/** 当前播放的时间点 */
@property (nonatomic, assign, readonly) float currTimePoint;
/** 当前的交互点, -1表示没有 */
@property (nonatomic, assign, readonly) NSInteger currinteractionTimePoint;


@end

@class YCAVPlayerView;
@protocol YCAVPlayerCallbacks <NSObject>

- (void)player:(YCAVPlayerView *)player onGetVideoDuration:(float)videoDuration;
- (void)playerOnReadyToPlay:(YCAVPlayerView *)player;
- (void)player:(YCAVPlayerView *)player
    onFinished:(NSInteger)staySecond
realPlaySecond:(NSInteger)realPlaySecond;
- (void)player:(YCAVPlayerView *)player onError:(NSError *)error;
- (void)player:(YCAVPlayerView *)player
     onPlaying:(NSInteger)currTimePoint
        isPause:(BOOL)isPause;
- (void)player:(YCAVPlayerView *)player onLoadedDuration:(float)loadedDuration;
- (void)player:(YCAVPlayerView *)player
      onLagged:(BOOL)isLagged
     loadSpeed:(CGFloat)loadSpeed;
- (void)player:(YCAVPlayerView *)player onInteract:(NSInteger)timePoint;
- (void)player:(YCAVPlayerView *)player
 onCachedVideo:(NSString *)videoFolder
     videoPath:(NSString *)videoPath
    isHLSVideo:(BOOL)isHLSVideo;

@end

/*!
 *  基础播放器，不包含业务逻辑
 */
@interface YCAVPlayerView : YCViewComponent<YCComponent>

@end
