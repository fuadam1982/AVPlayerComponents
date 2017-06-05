//
//  YCTeacherShowPlayerComponent.m
//  testModule
//
//  Created by fuhan on 2017/6/5.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import "YCTeacherShowPlayerComponent.h"

#pragma mark - viewmodel
#import "YCTeacherShowPlayerVM.h"

@implementation YCTeacherShowPlayerComponent

- (instancetype)initWithProps:(id<YCTeacherShowPlayerProps>)props callbacks:(id<YCCallbacks>)callbacks {
    YCTeacherShowPlayerVM *states = [[YCTeacherShowPlayerVM alloc] initWithProps:props callbacks:callbacks];
    return [super initWithStates:states template:nil];
}

@end
