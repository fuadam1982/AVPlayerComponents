//
//  YCSimpleMoviePlayerComponent.m
//  testModule
//
//  Created by fuhan on 2017/5/19.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import "YCSimpleMoviePlayerComponent.h"
#import "YCSimpleMoviePlayerVM.h"
#import "YCSimpleMoviePlayerView.h"
#import "YCAVPlayerComponent.h"

#import "AdapterComponent.h"
#import "AdapterComponentStatesWrapper.h"

@interface YCAVPlayerAdapterComponent : YCAdapterComponent

@end

@implementation YCAVPlayerAdapterComponent

- (instancetype)initWithProps:(id<YCStates>)states origin:(id<YCComponent>)origin {
    if (self = [super initWithProps:states origin:origin]) {
        
    }
    return self;
}

@end

////////////////////////////////////////////////////

@implementation YCSimpleMoviePlayerComponent

- (instancetype)initWithProps:(id<YCProps>)props callbacks:(id<YCCallbacks>)callbacks {
    YCSimpleMoviePlayerVM *states = [[YCSimpleMoviePlayerVM alloc] initWithProps:props callbacks:callbacks];
    YCSimpleMoviePlayerView *template = [[YCSimpleMoviePlayerView alloc] initWithStates:states];
    if (self = [super initWithTemplate:template]) {
        [self build];
    }
    return self;
}

- (void)build {
    
}

@end
