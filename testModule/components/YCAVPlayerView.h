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

@property (nonatomic, assign, readonly) BOOL isLocalVideo;
/** 视频播放地址，如果发生变化即切换清晰度 */
@property (nonatomic, strong, readonly) NSString *videoURL;
/** 是否暂停，默认加载好立即播放 */
@property (nonatomic, assign, readonly) BOOL isFault;
/** 从指定时间点开始播放，默认值为-1 */
@property (nonatomic, assign, readonly) NSInteger seekTimePoint;
// TODO: 亮度、音量

@end

@protocol YCAVPlayerStates <NSObject>

/** 播放中出现错误 */
@property (nonatomic, strong, readonly) NSError *error;
/** 是否可以播放 */
@property (nonatomic, assign, readonly) BOOL canPlay;
/** 是否正在播放 */
@property (nonatomic, assign, readonly) BOOL isPlaying;
/** 是否卡顿即需要loading */
@property (nonatomic, assign, readonly) BOOL needLoading;
/** 当前加载网速 */
@property (nonatomic, assign, readonly) CGFloat loadSpeed;
/** 当前播放的时间点 */
@property (nonatomic, assign, readonly) NSInteger currTimePoint;


@end

@class YCAVPlayerView;
@protocol YCAVPlayerCallbacks <NSObject>

- (void)onCanPlay:(YCAVPlayerView *)player;
- (void)onFinished:(NSInteger)videoTotoalSecond
        staySecond:(NSInteger)staySecond
        playSecond:(NSInteger)playSecond
            player:(YCAVPlayerView *)player;
- (void)onError:(NSError *)error player:(YCAVPlayerView *)player;
- (void)onLoading:(BOOL)show
        loadSpeed:(CGFloat)loadSpeed
           player:(YCAVPlayerView *)player;
- (void)onPlaying:(NSInteger)currTimePoint
          isFault:(BOOL)isFault
           player:(YCAVPlayerView *)player;

@end

/*!
 *  基础播放器，不包含业务逻辑
 */
@interface YCAVPlayerView : YCViewComponent

@end
