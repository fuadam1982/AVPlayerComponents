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

@implementation YCVideoPlayerComponent

- (instancetype)initWithProps:(id<YCAVPlayerProps>)props callbacks:(id<YCVideoPlayerCallbacks>)callbacks {
    YCVideoPlayerVM *states = [[YCVideoPlayerVM alloc] initWithProps:props callbacks:callbacks];
    YCVideoPlayerView *template = [[YCVideoPlayerView alloc] init];
    return [super initWithStates:states template:template];
}

@end
