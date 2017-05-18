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

/** 自定义的Callbacks协议只包含Signal，实际是Subject类型 */
@protocol YCCallbacks <NSObject>

@end

/** 自定义的ViewModel实现该协议 */
@protocol YCStates <NSObject>

- (instancetype)initWithProps:(id<YCProps>)props callbacks:(id<YCCallbacks>)callbacks;
- (void)updateState:(id)state keyPath:(NSString *)keyPath;

@end

@protocol YCTemplate <NSObject>

- (instancetype)initWithStates:(id<YCStates>)states;
- (UIView *)getView;
- (id<YCStates>)getStates;

@end

//////////////////////////////////////////////////////////////////

@interface YCComponent : NSObject<NSObject>

/** 由子类实现 */
- (instancetype)initWithProps:(id<YCProps>)props callbacks:(id<YCCallbacks>)callbacks;
/** 由子类调用 */
- (instancetype)initWithTemplate:(id<YCTemplate>)template;
- (id<YCTemplate>)getTemplate;
- (id<YCStates>)getStates;
- (void)addToParent:(YCComponent *)parent;
- (void)addToContainer:(UIViewController *)container;

@end

//////////////////////////////////////////////////////////////////

@interface YCTemplateView<States> : UIView<YCTemplate>

@end


@interface YCTemplateViewController<States> : UIViewController<YCTemplate>

@end
