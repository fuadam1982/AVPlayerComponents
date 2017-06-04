//
//  Componentable.m
//  testModule
//
//  Created by fuhan on 2017/5/16.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import "Componentable.h"

@interface YCViewTemplate ()

@property (nonatomic, strong) id<YCStates> states;

@end

@implementation YCViewTemplate

- (void)setStates:(id<YCStates>)states {
    _states = states;
}

- (id<YCStates>)getStates {
    return self.states;
}

- (UIView *)getView {
    return self;
}

- (void)render {
    // 需由子类实现
}

@end

//////////////////////////////////////////////////////////////

@interface YCViewControllerTemplate ()

@property (nonatomic, strong) id<YCStates> states;

@end

@implementation YCViewControllerTemplate

- (void)setStates:(id<YCStates>)states {
    _states = states;
}

- (id<YCStates>)getStates {
    return self.states;
}

- (UIView *)getView {
    return self.view;
}

- (void)render {
    // 需由子类实现
}

@end

//////////////////////////////////////////////////////////////

@interface YCComponent ()

@property (nonatomic, strong) id<YCStates> states;
@property (nonatomic, strong) id<YCTemplate> template;

@end

@implementation YCComponent

- (instancetype)initWithProps:(id<YCProps>)props callbacks:(id<YCCallbacks>)callbacks {
    // 需由子类实现
    return nil;
}

- (instancetype)initWithStates:(id<YCStates>)states template:(id<YCTemplate>)template {
    if (self = [super init]) {
        self.states = states;
        self.template = template;
        [self.template setStates:states];
        [self.template render];
    }
    return self;
}

- (UIView *)getView {
    return [self.template getView];
}

- (id<YCProps>)toProps:(id<YCProps> (^)(id<YCStates>))block {
    return block(self.states);
}

@end

//////////////////////////////////////////////////////////////

