//
//  YCShowProtraitPlayerComponent.m
//  testModule
//
//  Created by lucifer on 11/06/2017.
//  Copyright © 2017 fuhan. All rights reserved.
//

#import "YCShowProtraitPlayerComponent.h"

#pragma mark - viewmodel
#import "YCShowProtraitPlayerVM.h"

#pragma mark - view
#import "YCShowProtraitPlayerView.h"


@implementation YCShowProtraitPlayerComponent

- (instancetype)initWithProps:(id<YCProps>)props callbacks:(id<YCCallbacks>)callbacks {
    YCShowProtraitPlayerVM *states = [[YCShowProtraitPlayerVM alloc] initWithProps:props callbacks:callbacks];
    YCShowProtraitPlayerView *template = [[YCShowProtraitPlayerView alloc] init];
    return [super initWithStates:states template:template];
}

@end
