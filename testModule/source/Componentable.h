//
//  Componentable.h
//  testModule
//
//  Created by fuhan on 2017/5/16.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 自定义的Props协议只包含只读属性，用于Component对外暴露接口 */
@protocol YCProps <NSObject>

@end

/** 自定义的Delegate协议，建议每个方法以on开头 */
@protocol YCCallbacks <NSObject>

@end

/** 用于实现组件的state管理部分，一般用viewmodel实现 */
@protocol YCStates <NSObject>

- (instancetype)initWithProps:(id<YCProps>)props callbacks:(id<YCCallbacks>)callbacks;

@end

/** 用于实现组件的视图部分 */
@protocol YCTemplate <NSObject>

- (void)setStates:(id<YCStates>)states;
/** 用于获取states实例，在子类中定义viewmodel属性时通过getter注入 */
- (id<YCStates>)getStates;
- (UIView *)getView;
/** 一切就绪可以初始化视图了 */
- (void)render;

@end

@protocol YCComponent <NSObject>

/** 需要子类实现 */
- (instancetype)initWithProps:(id<YCProps>)props callbacks:(id<YCCallbacks>)callbacks;
- (UIView *)view;
- (id<YCProps>)toProps:(id<YCProps> (^) (id<YCStates> states))block;

@end

//////////////////////////////////////////////////////////////

@interface YCViewTemplate : UIView<YCTemplate>

@end

@interface YCViewControllerTemplate : UIViewController<YCTemplate>

@end

//////////////////////////////////////////////////////////////

@interface YCComponent : NSObject<YCComponent>

- (instancetype)initWithStates:(id<YCStates>)states template:(id<YCTemplate>)template;

@end
