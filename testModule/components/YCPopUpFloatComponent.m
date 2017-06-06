//
//  YCPopUpFloatComponent.m
//  testModule
//
//  Created by fuhan on 2017/6/6.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import "YCPopUpFloatComponent.h"
#import "YCPopUpFloatVM.h"
#import "YCPopUpFloatView.h"

@implementation YCPopUpFloatComponent

- (instancetype)initWithProps:(id<YCPopUpFloatProps>)props callbacks:(id<YCCallbacks>)callbacks {
    YCPopUpFloatVM *states = [[YCPopUpFloatVM alloc] initWithProps:props callbacks:callbacks];
    YCPopUpFloatView *template = [[YCPopUpFloatView alloc] init];
    return [super initWithStates:states template:template];
}

@end
