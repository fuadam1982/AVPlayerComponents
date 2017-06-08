//
//  YCPlayStateComponent.m
//  testModule
//
//  Created by fuhan on 2017/6/6.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import "YCSwitchPlayerStateComponent.h"

#pragma mark - viewmodel
#import "YCSwitchPlayerStateVM.h"

#pragma mark - view
#import "YCSwitchPlayerStateView.h"

@implementation YCPlayStateComponent

- (instancetype)initWithProps:(id<YCPlayStateProps>)props callbacks:(id<YCPlayStateCallbacks>)callbacks {
    YCPlayStateVM *states = [[YCPlayStateVM alloc] initWithProps:props callbacks:callbacks];
    YCPlayStateView *template = [[YCPlayStateView alloc] init];
    return [super initWithStates:states template:template];
}

@end
