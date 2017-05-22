//
//  YCPlayerSkipBtnComponent.m
//  testModule
//
//  Created by fuhan on 2017/5/19.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import "YCPlayerSkipBtnComponent.h"
#import "YCPlayerSkipBtnVM.h"
#import "YCPlayerSkipBtnVIew.h"

@implementation YCPlayerSkipBtnComponent

- (instancetype)initWithProps:(id<YCProps>)props callbacks:(id<YCCallbacks>)callbacks {
    YCPlayerSkipBtnVM *states = [[YCPlayerSkipBtnVM alloc] initWithProps:props callbacks:callbacks];
    YCPlayerSkipBtnVIew *template = [[YCPlayerSkipBtnVIew alloc] initWithStates:states];
    if (self = [super initWithTemplate:template]) {
        
    }
    return self;
}

@end
