//
//  YCAVPlayerView.h
//  testModule
//
//  Created by fuhan on 2017/5/22.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Componentable.h"

@protocol YCAVPlayerProps <YCProps>

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
@property (nonatomic, assign, readonly) NSTimeInterval minPlayTime;
/** 是否暂停，默认加载好立即播放 */
@property (nonatomic, assign, readonly) BOOL isPause;
/** 从指定时间点开始播放 */
@property (nonatomic, assign, readonly) NSTimeInterval seekTimePoint;
/** 交互时间点数组, 值为float。不需要联动 */
@property (nonatomic, strong, readonly) NSArray<NSNumber *> *interactionTimes;
// TODO: 亮度、音量、

@end

@protocol YCAVPlayerStates <YCStates>

/** 播放中出现错误 */
@property (nonatomic, strong, readonly) NSError *error;
/** 视频的总时长(秒) */
@property (nonatomic, assign, readonly) NSTimeInterval videoDuration;
/** 视频播放结束 */
@property (nonatomic, assign, readonly) BOOL isPlayFinished;
/** 是否正在播放 */
@property (nonatomic, assign, readonly) BOOL isPlaying;
/** 是否卡顿 */
@property (nonatomic, assign, readonly) BOOL isLagged;
/** 是否已经加载完video */
@property (nonatomic, assign, readonly) BOOL isLoadedAllVideo;
/** 是否为HLS格式视频 */
@property (nonatomic, assign, readonly) BOOL isHLSVideo;
/** 已经缓存的视频所在目录 */
@property (nonatomic, strong, readonly) NSString *cachedVideoFolder;
/** 当前加载网速 */
@property (nonatomic, assign, readonly) float loadSpeed;
/** 已经加载的时间段 */
@property (nonatomic, strong, readonly) NSDictionary<NSNumber *, NSNumber *> * loadedDurations;
/** 当前播放的时间点 */
@property (nonatomic, assign, readonly) NSTimeInterval currTimePoint;
/** 实际观看时长 */
@property (nonatomic, assign, readonly) NSTimeInterval watchedDuration;
/** 观看总时长 */
@property (nonatomic, assign, readonly) NSTimeInterval stayDuration;
/** 当前的交互点, -1表示还没有 */
@property (nonatomic, assign, readonly) NSTimeInterval currinteractionTimePoint;

@end

@class YCAVPlayerView;
@protocol YCAVPlayerCallbacks <YCCallbacks>

@optional;

/**
 视频播放发生错误
 
 @param player player
 @param error 错误信息
 */
- (void)player:(YCAVPlayerView *)player onError:(NSError *)error;

/**
 获取到视频总时长

 @param player player
 @param videoDuration 时长
 */
- (void)player:(YCAVPlayerView *)player onReadVideoDuration:(float)videoDuration;


// TODO: delete
///**
// 视频可以播放
// 调用者可以在未收到该回调时处理默认视频图、显示loading等逻辑
//
// @param player player
// */
//- (void)playerOnReadyToPlay:(YCAVPlayerView *)player;


/**
 视频播放完成

 @param player player
 @param isInterrupt 是否由用户或事件中断完成
 @param watchedDuration 视频实际观看时长
 @param stayDuration 观看视频停留时长
 */
- (void)player:(YCAVPlayerView *)player onFinishedByInterrupt:(BOOL)isInterrupt watchedDuration:(NSTimeInterval)watchedDuration stayDuration:(NSTimeInterval)stayDuration;

/**
 视频播放

 @param player player
 @param currTime 当前播放进度
 @param isPause 是否暂停
 */
- (void)player:(YCAVPlayerView *)player onPlayingCurrTime:(NSTimeInterval)currTime isPause:(BOOL)isPause;

/**
 视频缓冲了数据

 @param player player
 @param loadedDurations 缓冲的时间段, 例: {0: 47, 287: 32}. 其中key为加载起点，val为时间段
 */
- (void)player:(YCAVPlayerView *)player onLoadedDurations:(NSDictionary<NSNumber *, NSNumber *> *)loadedDurations;



/**
 视频发生卡顿

 @param player player
 @param loadSpeed 卡顿时加载数据的网速
 */
- (void)player:(YCAVPlayerView *)player onLagged:(BOOL)isLagging loadSpeed:(CGFloat)loadSpeed;

/**
 视频出现交互点

 @param player player
 @param timePoint 交互时间点
 */
- (void)player:(YCAVPlayerView *)player onInteract:(NSInteger)timePoint;


/**
 视频缓冲完毕
 如果props.isCachedRemoteVideo == NO, 那么缓存的路径为nil

 @param player player
 @param videoFolder 缓冲的临时文件报错的文件夹
 @param videoPath 缓冲的临时文件路径
 @param isHLSVideo 是否为HLS格式
 */
- (void)player:(YCAVPlayerView *)player onVideoLoadCompleted:(NSString *)videoFolder videoPath:(NSString *)videoPath isHLSVideo:(BOOL)isHLSVideo;

@end

/////////////////////////////////////////////////////////////////

/*!
 *  基础播放器，不包含业务逻辑
 */
@interface YCAVPlayerView : YCViewComponent<YCComponent>

@end
