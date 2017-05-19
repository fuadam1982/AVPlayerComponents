//
//  ComponentPropsBuilder.m
//  testModule
//
//  Created by fuhan on 2017/5/17.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import "ComponentPropsBuilder.h"

ComponentPropsBuilder * toProps(Protocol *propsProtocol) {
    return [[ComponentPropsBuilder alloc] initWithPropsProtocol:propsProtocol];
}

//////////////////////////////////////////////////////

@interface ComponentPropsBuilder ()

/** props的协议 */
@property (nonatomic, strong) Protocol *propsProtocol;
/** states对象，一般为viewmodel */
@property (nonatomic, strong) id<YCStates> pStates;
/** keyPath映射，可以用来转为plain object */
@property (nonatomic, strong) NSDictionary *pNameMapping;
/** 不会改变的状态 */
@property (nonatomic, strong) NSDictionary *pConstVars;

@end

@implementation ComponentPropsBuilder

- (instancetype)initWithPropsProtocol:(Protocol *)propsProtocol {
    if (self = [super init]) {
        self.propsProtocol = propsProtocol;
    }
    return self;
}

- (ComponentPropsWrapper *)buildWrapper {
    return [[ComponentPropsWrapper alloc] initWithPropsProtocol:self.propsProtocol
                                                         states:self.pStates
                                                    nameMapping:self.pNameMapping
                                                      constVars:self.pConstVars];
}

- (ComponentPropsBuilder * (^) (id<YCStates> states))states {
    return ^ComponentPropsBuilder *(id<YCStates> states) {
        self.pStates = states;
        return self;
    };
}

- (ComponentPropsBuilder * (^) (NSDictionary *))nameMapping {
    return ^ComponentPropsBuilder *(NSDictionary *nameMapping) {
        self.pNameMapping = nameMapping;
        return self;
    };
}

- (ComponentPropsBuilder * (^) (NSDictionary *))constVars {
    return ^ComponentPropsBuilder *(NSDictionary *constVars) {
        self.pConstVars = constVars;
        return self;
    };
}

- (ComponentPropsWrapper * (^) ())build {
    return ^ComponentPropsWrapper *() {
        return [self buildWrapper];
    };
}

@end
