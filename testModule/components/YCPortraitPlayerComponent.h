//
//  YCPortraitPlayerComponent.h
//  testModule
//
//  Created by fuhan on 2017/6/5.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - utils
#import "Componentable.h"

// TODO: 抽取基类
@protocol YCPortraitPlayerStates <YCStates>

/** 视频播放地址，如果发生变化即切换清晰度 */
@property (nonatomic, strong, readonly) NSString *currVideoURL;
/** 是否手动取消播放 */
@property (nonatomic, assign, readonly) BOOL isCancelPlay;
/** 是否暂停，默认加载好立即播放 */
@property (nonatomic, assign, readonly) BOOL isPause;
/** 从指定时间点开始播放 */
@property (nonatomic, assign, readonly) NSTimeInterval seekTimePoint;

@end


@protocol YCPortraitPlayerCallbacks <YCCallbacks>

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
- (void)player:(UIView *)player onFinishedByInterrupt:(BOOL)isInterrupt watchedDuration:(NSTimeInterval)watchedDuration stayDuration:(NSTimeInterval)stayDuration;


/**
 视频播放器将要进行屏幕旋转

 @param player player
 @param isPortrait 当前是否为竖屏
 */
- (void)player:(UIView *)player onWillScreenRotation:(BOOL)isPortrait;


/**
 视频播放器完成进行屏幕旋转

 @param player player
 @param isPortrait 单签是否为竖屏
 */
- (void)player:(UIView *)player onDidScreenRotation:(BOOL)isPortrait;

@end

//////////////////////////////////////////////////////////////

/*!
 *  竖屏播放器，属于基础业务组件
 *  在基础播放器上增加手势操作层、播放/暂停按钮、进度条、播放时长、横屏按钮
 */
@interface YCPortraitPlayerComponent : YCComponent

@end
