//
//  YCAVPlayerView.m
//  testModule
//
//  Created by fuhan on 2017/5/22.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import "YCAVPlayerView.h"
#import "YCAVPlayerVM.h"
@import AVFoundation;

// https://o558dvxry.qnssl.com/mobileM/mobileM_586d9599065b7e9d7142953e.m3u8
@interface YCAVPlayerView ()



@end

@implementation YCAVPlayerView

- (instancetype)initWithProps:(id<YCProps>)props callbacks:(id<YCCallbacks>)callbacks {
    YCAVPlayerVM *states = [[YCAVPlayerVM alloc] initWithProps:props callbacks:callbacks];
    if (self = [super initWithStates:states]) {
        [self layout];
    }
    return self;
}

- (void)layout {
    
}

@end
