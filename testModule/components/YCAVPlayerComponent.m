//
//  YCAVPlayerComponent.m
//  testModule
//
//  Created by fuhan on 2017/6/4.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import "YCAVPlayerComponent.h"

#pragma mark - viewmodel
#import "YCAVPlayerVM.h"

#pragma mark - view
#import "YCAVPlayerView.h"

@implementation YCAVPlayerComponent

- (instancetype)initWithProps:(id<YCAVPlayerProps>)props callbacks:(id<YCAVPlayerCallbacks>)callbacks {
    YCAVPlayerVM *states = [[YCAVPlayerVM alloc] initWithProps:props callbacks:callbacks];
    YCAVPlayerView *template = [[YCAVPlayerView alloc] init];
    return [super initWithStates:states template:template];
}

@end
