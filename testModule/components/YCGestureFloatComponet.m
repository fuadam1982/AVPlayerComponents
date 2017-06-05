//
//  YCGestureFloatComponet.m
//  testModule
//
//  Created by fuhan on 2017/6/5.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import "YCGestureFloatComponet.h"

#pragma mark - viewmodel
#import "YCGestureFloatVM.h"

#pragma mark - view
#import "YCGestureFloatView.h"

@implementation YCGestureFloatComponet

- (instancetype)initWithProps:(id<YCGestureFloatProps>)props callbacks:(id<YCGestureFloatCallbacks>)callbacks {
    YCGestureFloatVM *states = [[YCGestureFloatVM alloc] initWithProps:props callbacks:callbacks];
    YCGestureFloatView *template = [[YCGestureFloatView alloc] init];
    return [super initWithStates:states template:template];
}

@end
