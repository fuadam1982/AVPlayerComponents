//
//  YCGestureFloatView.h
//  testModule
//
//  Created by fuhan on 2017/6/2.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Componentable.h"

/** 手势方向枚举 */
typedef NS_OPTIONS(int, YCGestureFloatDirectionType) {
    YCGestureFloatDirectionTypeNone,
    YCGestureFloatDirectionTypeLeft,
    YCGestureFloatDirectionTypeRight,
    YCGestureFloatDirectionTypeUp,
    YCGestureFloatDirectionTypeDown,
};

@protocol YCGestureFloatProps <NSObject>

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

@protocol YCGestureFloatCallbacks <NSObject>

@optional

- (void)gesturerOnTap:(YCViewComponent *)gesturer;
- (void)gesturerOnDoubleTap:(YCViewComponent *)gesturer;
- (void)gesturer:(YCViewComponent *)gesture onSwipeWithDirection:(YCGestureFloatDirectionType)direction;
- (void)gesturer:(YCViewComponent *)gesture onPanWithDirection:(YCGestureFloatDirectionType)direction;
- (void)gesturerOnLongPress:(YCViewComponent *)gesturer;

@end

/////////////////////////////////////////////////////////////////

/*!
 *  手势操作浮动层
 *  提供单击、长按、上下左右滑动等手势回调
 */
@interface YCGestureFloatView : YCViewComponent<YCComponent>

- (instancetype)initWithProps:(id<YCGestureFloatProps>)props callbacks:(id<YCGestureFloatCallbacks>)callbacks;

@end