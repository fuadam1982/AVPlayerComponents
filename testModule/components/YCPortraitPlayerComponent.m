//
//  YCPortraitPlayerComponent.m
//  testModule
//
//  Created by fuhan on 2017/6/5.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import "YCPortraitPlayerComponent.h"

#pragma mark - viewmodel
#import "YCPortraitPlayerVM.h"

#pragma mark - view
#import "YCPortraitPlayerView.h"

@implementation YCPortraitPlayerComponent

- (instancetype)initWithProps:(id<YCAVPlayerProps>)props callbacks:(id<YCPortraitPlayerCallbacks>)callbacks {
    YCPortraitPlayerVM *states = [[YCPortraitPlayerVM alloc] initWithProps:props callbacks:callbacks];
    YCPortraitPlayerView *template = [[YCPortraitPlayerView alloc] init];
    return [super initWithStates:states template:template];
}

@end
