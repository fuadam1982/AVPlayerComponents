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

@end

//////////////////////////////////////////////////////////////////

@protocol YCComponentable <NSObject>

- (instancetype)initWithProps:(id<YCProps>)props callbacks:(id<YCCallbacks>)callbacks;
- (void)addToParent:(id<YCComponentable>)parent;
- (void)addToContainer:(UIViewController *)container;
- (UIView *)getView;

@end

//////////////////////////////////////////////////////////////////


@interface YCComponentView : UIView<YCComponentable>

@end


@interface YCComponentViewController<T> : UIViewController<YCComponentable>

@end
