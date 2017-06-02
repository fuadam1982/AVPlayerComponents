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

/** 用于存储state，一般用viewmodel实现 */
@protocol YCStates <NSObject>

- (instancetype)initWithProps:(id<YCProps>)props callbacks:(id<YCCallbacks>)callbacks;

@optional
- (id<YCProps>)toProps;

@end

@protocol YCComponent <NSObject>

/** 需要子类实现 */
- (instancetype)initWithProps:(id<YCProps>)props callbacks:(id<YCCallbacks>)callbacks;
- (UIView *)getView;

@end

@protocol YCTemplate <NSObject>

- (instancetype)initWithStates:(id<YCStates>)states;
/** 用于获取states实例，在子类中定义viewmodel属性时通过getter注入. 由于语法问题不应该在子类以外使用 */
- (id<YCStates>)getStates;
- (UIView *)getView;

@end

//////////////////////////////////////////////////////////////

@interface YCViewComponent<T> : UIView<YCTemplate>

@end

@interface YCViewControllerComponent : UIViewController<YCTemplate>

@end
