//
//  Componentable.h
//  testModule
//
//  Created by fuhan on 2017/5/16.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 为Props协议提供不需要联动部分的属性设置 */
@protocol YCConstVars <NSObject>

@end

/** 对YCConstVar协议的可写包装，在构造PropsWrapper时方便设置 */
@protocol YCVars <NSObject>

- (NSDictionary *)toDictionary;

@end

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

/** 用于组合的Componet, 可以让父组件对一组YCComponent设定初始属性 */
@protocol YCVarProps <NSObject>

@end

/** 用于组合的Componet, 可以让父组件控制YCTemplate布局时用到的YCComponet与UIView */
@protocol YCLayout <NSObject>

@end

/** 用于实现组件的视图部分 */
@protocol YCTemplate <NSObject>

/** 设置states */
- (void)setStates:(id<YCStates>)states;

/** 用于获取states实例，在子类中定义viewmodel属性时通过getter注入 */
- (id<YCStates>)getStates;

/** 获取view实例 */
- (UIView *)getView;

/** 获取布局接口实例 */
- (id<YCLayout>)getLayout;

/** 初始化视图并附带组件设定初始值 */
- (void)renderWithVarProps:(id<YCVarProps>)varProps;

@end

@protocol YCComponent <NSObject>

/** 需要子类实现 */
- (instancetype)initWithProps:(id<YCProps>)props callbacks:(id<YCCallbacks>)callbacks;
/** 持有的视图 */
- (UIView *)view;
/** 将持有的states供外转换为props */
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
- (void)render;

@end

//////////////////////////////////////////////////////////////

@interface YCComponentBuilder : NSObject

- (instancetype)initWithComponentClass:(Class)componentClass;
- (YCComponentBuilder * (^)(Protocol *varsProtocol))varsProtocol;
- (YCComponentBuilder * (^)(NSDictionary * (^)(id<YCVars>)))constVars;
- (YCComponentBuilder * (^)(id<YCProps> (^)(NSDictionary *)))props;
- (YCComponentBuilder * (^)(id<YCCallbacks>))callbacks;
- (YCComponentBuilder * (^)(UIView *))superView;
// TODO:
- (YCComponent * (^)())build;

@end

/** 用于辅助构造component */
YCComponentBuilder *toComponent(Class componentClass);
