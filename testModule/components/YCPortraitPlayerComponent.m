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

#pragma mark - unitls
#import "ComponentPropsBuilder.h"
#import "PropsConstVarWrapper.h"

@implementation YCVideoPlayerComponent

- (instancetype)initWithProps:(id<YCAVPlayerProps>)props callbacks:(id<YCVideoPlayerCallbacks>)callbacks {
    YCVideoPlayerVM *states = [[YCVideoPlayerVM alloc] initWithProps:props callbacks:callbacks];
    YCVideoPlayerView *template = [[YCVideoPlayerView alloc] init];
    return [super initWithStates:states template:template];
}

+ (id<YCVarProps>)getChildrenVarProps {
    return (id<YCVarProps>)toProps(@protocol(YCVideoPlayerVarProps))
    .constVars(@{
                 @"gesture": [[PropsConstVarWrapper alloc] initWithProtocol:@protocol(YCGestureFloatVars)],
                 @"gesturePlay": [[PropsConstVarWrapper alloc] initWithProtocol:@protocol(YCPlayStateVars)],
                 @"status": [[PropsConstVarWrapper alloc] initWithProtocol:@protocol(YCPopUpFloatVars)],
                 @"statusPlay": [[PropsConstVarWrapper alloc] initWithProtocol:@protocol(YCPlayStateVars)],
                 })
    .build();
}

@end
