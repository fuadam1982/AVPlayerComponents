//
//  YCSimpleMoviePlayerView.m
//  testModule
//
//  Created by fuhan on 2017/5/19.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import "YCSimpleMoviePlayerView.h"
#import "YCSimpleMoviePlayerVM.h"

@interface YCSimpleMoviePlayerView ()

@property (nonatomic, strong, readonly, getter=getStates) YCSimpleMoviePlayerVM *states;

@end

@implementation YCSimpleMoviePlayerView

- (instancetype)initWithProps:(id<YCProps>)props callbacks:(id<YCCallbacks>)callbacks {
    YCSimpleMoviePlayerVM *states = [[YCSimpleMoviePlayerVM alloc] initWithProps:props callbacks:callbacks];
    if (self = [super initWithStates:states]) {
        [self layout];
    }
    return self;
}

- (void)layout {

}

- (YCSimpleMoviePlayerVM *)states {
    return [self getStates];
}

@end
