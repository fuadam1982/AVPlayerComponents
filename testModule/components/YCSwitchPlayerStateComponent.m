//
//  YCSwitchPlayerStateComponent.m
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

@implementation YCSwitchPlayerStateComponent

- (instancetype)initWithProps:(id<YCSwitchPlayerStateProps>)props callbacks:(id<YCSwitchPlayerStateCallbacks>)callbacks {
    YCSwitchPlayerStateVM *states = [[YCSwitchPlayerStateVM alloc] initWithProps:props callbacks:callbacks];
    YCSwitchPlayerStateView *template = [[YCSwitchPlayerStateView alloc] init];
    return [super initWithStates:states template:template];
}

@end
