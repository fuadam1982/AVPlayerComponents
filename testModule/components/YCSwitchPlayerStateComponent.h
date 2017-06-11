//
//  YCPlayStateComponent.h
//  testModule
//
//  Created by fuhan on 2017/6/6.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Componentable.h"

@protocol YCPlayStateConstVars <YCConstVars>

/** 是否不启用，如果是则不响应Props联动且不显示 */
@property (nonatomic, assign, readonly) BOOL isNotUsed;
/** 播放按钮图片 */
@property (nonatomic, strong, readonly) NSString* btnPlayImage;
@property (nonatomic, strong, readonly) NSString* btnPlayHighlightImage;
/** 暂停按钮图片 */
@property (nonatomic, strong, readonly) NSString* btnPauseImage;
@property (nonatomic, strong, readonly) NSString* btnPauseHighlightImage;

@end

@protocol YCPlayStateVars <YCVars, YCPlayStateConstVars>

- (void)setIsNotUsed:(BOOL)isNotUsed;
- (void)setBtnPlayImage:(NSString *)btnPlayImage;
- (void)setBtnPlayHighlightImage:(NSString *)btnPlayHighlightImage;
- (void)setBtnPauseImage:(NSString *)btnPauseImage;
- (void)setBtnPauseHighlightImage:(NSString *)btnPauseHighlightImage;

@end

@protocol YCPlayStateProps <YCProps, YCPlayStateConstVars>

/** 是否暂停，默认加载好立即播放 */
@property (nonatomic, assign, readonly) BOOL isPause;
/** 是否隐藏 */
@property (nonatomic, assign, readonly) BOOL isHidden;
/** 是否可用 */
@property (nonatomic, assign, readonly) BOOL isDisable;

@end

@protocol YCPlayStateCallbacks <YCCallbacks>

- (void)switchPlayerStateOnTap;

@end

//////////////////////////////////////////////////////////////

/*!
 *  控制视频播放器暂停、播放按钮组件
 */
@interface YCPlayStateComponent : YCComponent

@end
