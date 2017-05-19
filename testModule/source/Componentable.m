//
//  Componentable.m
//  testModule
//
//  Created by fuhan on 2017/5/16.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import "Componentable.h"
#import "AdapterComponent.h"

@interface YCBaseComponent ()

@property (nonatomic, strong) NSMutableArray *children;

@end

@implementation YCBaseComponent

- (instancetype)init {
    if (self = [super init]) {
        self.children = [[NSMutableArray alloc] initWithCapacity:16];
    }
    return self;
}

- (UIView *)getView {
    return nil;
}

- (void)addSubComponent:(id<YCComponent>)subComponent {
    [self.children addObject:subComponent];
    
    UIView *selfView = [self getView];
    UIView *view = [subComponent getView];
    if (view && ![view isEqual:selfView]) {
        [selfView addSubview:view];
    }
}

@end

//////////////////////////////////////////////////////////////////

@interface YCComponent ()

@property (nonatomic, strong) id<YCTemplate> template;

@end

@implementation YCComponent

// TODO: 忽略接口为实现警告

- (instancetype)initWithTemplate:(id<YCTemplate>)template {
    if (self = [super init]) {
        self.template = template;
    }
    return self;
}

- (UIView *)getView {
    return [self.template getView];
}

- (void)addToContainer:(UIViewController *)container {
    [container.view addSubview:[self.template getView]];
}

- (void)addAdapterComponent:(YCAdapterComponent * (^)(id<YCStates> states, YCComponent *origin))block {
    YCAdapterComponent *adapter = block([self.template getStates], self);
    [self addSubComponent:adapter];
}

@end

//////////////////////////////////////////////////////////////////

@interface YCTemplateView ()

@property (nonatomic, strong) id<YCStates> states;

@end

@implementation YCTemplateView

- (instancetype)init {
    return nil;
}

- (instancetype)initWithStates:(id<YCStates>)states {
    if (self = [super init]) {
        self.states = states;
    }
    return self;
}

- (UIView *)getView {
    return self;
}

- (id<YCStates>)getStates {
    return self.states;
}

@end

//////////////////////////////////////////////////////////////////

@interface YCTemplateViewController ()

@property (nonatomic, strong) id<YCStates> states;

@end

@implementation YCTemplateViewController

- (instancetype)init {
    return nil;
}

- (instancetype)initWithStates:(id<YCStates>)states {
    if (self = [super init]) {
        self.states = states;
    }
    return self;
}

- (UIView *)getView {
    return self.view;
}

- (id<YCStates>)getStates {
    return self.states;
}

@end
