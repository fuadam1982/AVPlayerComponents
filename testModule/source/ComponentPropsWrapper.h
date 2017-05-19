//
//  ComponentPropsWrapper.h
//  testModule
//
//  Created by fuhan on 2017/5/16.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import "ReadonlyObjWrapper.h"
#import "Componentable.h"

@class RACTuple;

/**
 组件Props包装类
 
 states -> props的三种情况：
 1. plain viewmodel直接cast(不需要任何处理)
 2. dictionary被wrapper后cast
 3. viewmodel.model.property(层级很深)被wrapper后cast
 */
@interface ComponentPropsWrapper : ReadonlyObjWrapper

- (instancetype)initWithPropsProtocol:(Protocol *)propsProtocol
                               states:(id<YCStates>)states
                          nameMapping:(NSDictionary *)nameMapping
                            constVars:(NSDictionary *)constVars;

@end
