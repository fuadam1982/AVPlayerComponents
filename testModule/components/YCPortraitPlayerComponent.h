//
//  YCVideoPlayerComponent.h
//  testModule
//
//  Created by fuhan on 2017/6/5.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - component
#import "YCAVPlayerComponent.h"
#import "YCGestureFloatComponet.h"
#import "YCPopUpFloatComponent.h"
#import "YCSwitchPlayerStateComponent.h"

#pragma mark - utils
#import "Componentable.h"
#import "StateStore.h"
#import "StoreAction.h"

@protocol YCVideoPlayerConstVars <YCConstVars>

/** 视频Id */
@property (nonatomic, strong, readonly) NSString *videoId;
/** 视频地址: 0-高清地址、1-低清地址 */
@property (nonatomic, strong, readonly) NSArray<NSString *> *videoURLs;
/** 视频标题 */
@property (nonatomic, strong, readonly) NSString *videoTitle;

@end

@protocol YCVideoPlayerProps <YCProps, YCVideoPlayerConstVars, YCAVPlayerProps>

@end

@protocol YCVideoPlayerStates <YCStates>

/** 视频播放地址，如果发生变化即切换清晰度 */
@property (nonatomic, strong, readonly) NSString *currVideoURL;
/** 是否手动取消播放 */
@property (nonatomic, assign, readonly) BOOL isCancelPlay;
/** 是否暂停，默认加载好立即播放 */
@property (nonatomic, assign, readonly) BOOL isPause;
/** 从指定时间点开始播放 */
@property (nonatomic, assign, readonly) NSTimeInterval seekTimePoint;

@end


@protocol YCVideoPlayerCallbacks <YCCallbacks>

/**
 视频播放发生错误
 
 @param player player
 @param error 错误信息
 */
- (void)player:(UIView *)player onError:(NSError *)error;

/**
 视频播放完成
 
 @param player player
 @param isInterrupt 是否由用户或事件中断完成
 @param watchedDuration 视频实际观看时长
 @param stayDuration 观看视频停留时长
 */
- (void)player:(UIView *)player
onFinishedByInterrupt:(BOOL)isInterrupt
watchedDuration:(NSTimeInterval)watchedDuration
  stayDuration:(NSTimeInterval)stayDuration;

@end

@protocol YCVideoPlayerVarProps <YCVarProps>

@property (nonatomic, strong, readonly) id<YCGestureFloatVars> gesture;
@property (nonatomic, strong, readonly) id<YCPlayStateVars> gesturePlay;
@property (nonatomic, strong, readonly) id<YCPopUpFloatVars> status;
@property (nonatomic, strong, readonly) id<YCPlayStateVars> statusPlay;

// TODO: more

@end

//////////////////////////////////////////////////////////////

@class YCAVPlayerComponent, YCGestureFloatComponet,
YCPlayStateComponent, YCPopUpFloatComponent, YCPlayStateComponent;
@protocol YCVideoPlayerLayout <YCLayout>

/** 基础播放器组件 */
@property (nonatomic, strong, readonly) YCAVPlayerComponent *playerComponent;

#pragma mark - GestureFloat
/** 手势浮动层组件 */
@property (nonatomic, strong, readonly) YCGestureFloatComponet *gestureFloatComponent;
/** 手势浮动层上的播放按钮组件 */
@property (nonatomic, strong, readonly) YCPlayStateComponent *gesturePlayComponent;
// TODO: 声音、亮度控制条

#pragma mark - StatusBar
/** 视频状态控制栏 */
@property (nonatomic, strong, readonly) YCPopUpFloatComponent *statusBarComponent;
/** 播放按钮组件 */
@property (nonatomic, strong, readonly) YCPlayStateComponent *statusPlayComponent;
/** 视频时长label */
@property (nonatomic, strong, readonly) UILabel *videoDurationLabel;
/** 播放时长label */
@property (nonatomic, strong, readonly) UILabel *playDurationLabel;
/** 视频进度条 */
@property (nonatomic, strong, readonly) YCComponent *progressComponent;

#pragma mark - Header
/** header隐藏条 */
@property (nonatomic, strong, readonly) YCPopUpFloatComponent *headerComponent;
/** 视频标题 */
@property (nonatomic, strong, readonly) UILabel *videoTitleLabel;
/** 切换清晰度 */
@property (nonatomic, strong, readonly) UIButton *switchVideoQuaButton;
/** 分享 */
@property (nonatomic, strong, readonly) UIButton *shareButton;
/** 离线下载 */
@property (nonatomic, strong, readonly) UIButton *downloadButton;

@end

//////////////////////////////////////////////////////////////

@protocol YCVideoPlayerStore <YCStore>

/** 共享的基础播放器实例，idx-0: videoId、idx-1: playerInstance */
@property (nonatomic, strong, readonly) NSArray *sharedPlayerInstance;

@end

@protocol YCVideoPlayerMutableStore <YCMutableStore, YCVideoPlayerStore>

- (void)setSharedPlayerInstance:(NSArray *)sharedPlayerInstance;

@end

StoreAction *sharePlayerAction(NSString *videoId, YCComponent *player);
StoreAction *removeSharedPlayerAction(NSString *videoId);
// TODO: change currVideoURL

//////////////////////////////////////////////////////////////

/*!
 *  洋葱基础播放器，属于基础业务组件
 *  在基础播放器上增加手势操作层、状态栏、header隐藏条等业务相关组件、UIView
 *  及业务无关的播放器埋点组件
 */
@interface YCVideoPlayerComponent : YCComponent

@end
