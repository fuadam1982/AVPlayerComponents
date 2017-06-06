//
//  YCGestureFloatComponet.h
//  testModule
//
//  Created by fuhan on 2017/6/5.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Componentable.h"

/** 手势方向枚举 */
typedef NS_OPTIONS(int, YCGestureFloatDirectionType) {
    YCGestureFloatDirectionTypeNone,
    YCGestureFloatDirectionTypeLeft,
    YCGestureFloatDirectionTypeRight,
    YCGestureFloatDirectionTypeUp,
    YCGestureFloatDirectionTypeDown,
};

@protocol YCGestureFloatProps <YCProps>

// TODO: use 联动属性
/** 单击手势 */
@property (nonatomic, assign, readonly) BOOL useTap;
/** 双击手势 */
@property (nonatomic, assign, readonly) BOOL useDoubleTap;
/** 滑动手势 */
@property (nonatomic, assign, readonly) BOOL useSwipe;
/** 滑动手势方向 */
@property (nonatomic, assign, readonly) YCGestureFloatDirectionType swipeDirection;
/** 拖拽手势 */
@property (nonatomic, assign, readonly) BOOL usePan;
/** 拖拽手势方向 */
@property (nonatomic, assign, readonly) YCGestureFloatDirectionType panDirection;
/** 长按手势 */
@property (nonatomic, assign, readonly) BOOL useLongPress;

@end

@protocol YCGestureFloatCallbacks <YCCallbacks>

@optional

- (void)gesturerOnTap:(UIView *)gesturer;
- (void)gesturerOnDoubleTap:(UIView *)gesturer;
- (void)gesturerOnLongPress:(UIView *)gesturer;
- (void)gesturer:(UIView *)gesture onSwipeWithDirection:(YCGestureFloatDirectionType)direction;
- (void)gesturer:(UIView *)gesture onPanWithDirection:(YCGestureFloatDirectionType)direction;

@end

//////////////////////////////////////////////////////////////

/*!
 *  手势操作浮动层
 *  提供单击、长按、上下左右滑动等手势回调
 */
@interface YCGestureFloatComponet: YCComponent

@end
