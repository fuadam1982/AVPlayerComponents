//
//  YCSwitchPlayerStateComponent.h
//  testModule
//
//  Created by fuhan on 2017/6/6.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Componentable.h"

@protocol YCSwitchPlayerStateProps <YCProps>

/** 是否暂停，默认加载好立即播放 */
@property (nonatomic, assign, readonly) BOOL isPause;
/** 是否隐藏 */
@property (nonatomic, assign, readonly) BOOL isHidden;
/** 是否可用 */
@property (nonatomic, assign, readonly) BOOL isDisable;
/** 播放按钮图片，不需要联动 */
@property (nonatomic, strong, readonly) NSString* btnPlayImage;
@property (nonatomic, strong, readonly) NSString* btnPlayHighlightImage;
/** 暂停按钮图片，不需要联动 */
@property (nonatomic, strong, readonly) NSString* btnPauseImage;
@property (nonatomic, strong, readonly) NSString* btnPauseHighlightImage;

@end

@protocol YCSwitchPlayerStateCallbacks <YCCallbacks>

- (void)switchPlayerStateOnTap;

@end

//////////////////////////////////////////////////////////////

/*!
 *  控制视频播放器暂停、播放按钮组件
 */
@interface YCSwitchPlayerStateComponent : YCComponent

@end
