//
//  YCPopUpFloatComponent.h
//  testModule
//
//  Created by fuhan on 2017/6/6.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Componentable.h"

/** 弹出方向枚举 */
typedef NS_OPTIONS(int, YCPopUpFloatDirectionType) {
    YCPopUpFloatDirectionTypeLeft,
    YCPopUpFloatDirectionTypeRight,
    YCPopUpFloatDirectionTypeUp,
    YCPopUpFloatDirectionTypeDown,
};

@protocol YCPopUpFloatProps <YCProps>

/** 弹出方向 */
@property (nonatomic, assign, readonly) YCPopUpFloatDirectionType direction;
/** 动画时长 */
@property (nonatomic, assign, readonly) float animationDuration;
/** 自动隐藏时长，0为不隐藏 */
@property (nonatomic, assign, readonly) float autoHiddenDuration;
/** 初始状态为弹出/隐藏 */
@property (nonatomic, assign, readonly) BOOL initShowState;
/** 
 * 是否开始初始化，联动属性
 * 因为Component的初始化(render)与view初始化时机不一致，所以用这个联动属性曲线救国
 * TODO: 实现Component-tree与View-tree结构一致，需要实现代理component来传递props与callbacks。当前组件就是这个情况
 */
@property (nonatomic, assign, readonly) BOOL startInit;
/** 改变弹出/收起状态，联动属性 */
@property (nonatomic, assign, readonly) BOOL changeState;
/** 重新计算自动隐藏timer, 联动属性 */
@property (nonatomic, assign, readonly) BOOL resetAutoHiddenTimer;

@end

//////////////////////////////////////////////////////////////

/*!
 *  弹出浮动条
 */
@interface YCPopUpFloatComponent : YCComponent

@end
