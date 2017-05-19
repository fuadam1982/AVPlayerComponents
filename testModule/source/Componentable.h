//
//  Componentable.h
//  testModule
//
//  Created by fuhan on 2017/5/16.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 自定义的Props协议只包含只读属性 */
@protocol YCProps <NSObject>

@end

/** 自定义的Delegate协议，建议每个方法以on开头 */
@protocol YCCallbacks <NSObject>

@end

/** 用于存储state，一般用viewmodel实现 */
@protocol YCStates <NSObject>

- (instancetype)initWithProps:(id<YCProps>)props callbacks:(id<YCCallbacks>)callbacks;

@end

/** 用于展示视图，即view/vc */
@protocol YCTemplate <NSObject>

- (instancetype)initWithStates:(id<YCStates>)states;
- (UIView *)getView;
- (id<YCStates>)getStates;

@end

//////////////////////////////////////////////////////////////////

@protocol YCComponent <NSObject>

- (UIView *)getView;
- (void)addSubComponent:(id<YCComponent>)subComponent;

@end

@protocol YCComponentInit <NSObject>

- (instancetype)initWithProps:(id<YCProps>)props callbacks:(id<YCCallbacks>)callbacks;

@end

@interface YCBaseComponent : NSObject<YCComponent>

@end

@class YCAdapterComponent;
@interface YCComponent : YCBaseComponent<YCComponent, YCComponentInit>

/** 用于保存子类Template */
- (instancetype)initWithTemplate:(id<YCTemplate>)template;
/** 用于与ViewController关联 */
- (void)addToContainer:(UIViewController *)container;

/** 添加AdapterComponet为子组件 */
- (void)addAdapterComponent:(YCAdapterComponent * (^)(id<YCStates> states, YCComponent *origin))block;

@end

//////////////////////////////////////////////////////////////////

@interface YCTemplateView<States> : UIView<YCTemplate>

@end


@interface YCTemplateViewController<States> : UIViewController<YCTemplate>

@end
