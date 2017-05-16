//
//  Componentable.m
//  testModule
//
//  Created by fuhan on 2017/5/16.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import "Componentable.h"

@implementation YCComponentView

- (instancetype)init {
    return nil;
}

- (instancetype)initWithProps:(id<YCProps>)props callbacks:(id<YCCallbacks>)callbacks {
    return [super init];
}

- (void)addToParent:(id<YCComponentable>)parent {
    [[parent getView] addSubview:[self getView]];
}

- (void)addToContainer:(UIViewController *)container {
    [container.view addSubview:[self getView]];
}

- (UIView *)getView {
    return self;
}

@end

//////////////////////////////////////////////////////////////////

@implementation YCComponentViewController

- (instancetype)init {
    return nil;
}

- (instancetype)initWithProps:(id<YCProps>)props callbacks:(id<YCCallbacks>)callbacks {
    return [super init];
}

- (void)addToParent:(id<YCComponentable>)parent {
    [[parent getView] addSubview:[self getView]];
}

- (void)addToContainer:(UIViewController *)container {
    [container.view addSubview:[self getView]];
}

- (UIView *)getView {
    return self.view;
}

@end
