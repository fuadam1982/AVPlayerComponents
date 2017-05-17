//
//  ComponentPropsBuilder.h
//  testModule
//
//  Created by fuhan on 2017/5/17.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Componentable.h"
#import "ComponentPropsWrapper.h"

@class ComponentPropsBuilder;
ComponentPropsBuilder * toProps(Protocol *propsProtocol);

@interface ComponentPropsBuilder : NSObject

- (instancetype)initWithPropsProtocol:(Protocol *)propsProtocol;
- (ComponentPropsBuilder * (^) (id<YCStates>))states;
- (ComponentPropsBuilder * (^) (ComplexObjectTransform))transform;
- (ComponentPropsBuilder * (^) (NSDictionary *))constVars;
- (ComponentPropsWrapper * (^) ())build;

@end
