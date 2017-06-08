//
//  YCPlayStateVM.m
//  testModule
//
//  Created by fuhan on 2017/6/6.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import "YCSwitchPlayerStateVM.h"

@interface YCPlayStateVM ()

#pragma mark - YCStates
@property (nonatomic, strong) id<YCPlayStateProps> props;
@property (nonatomic, weak) id<YCPlayStateCallbacks> callbacks;

@end

@implementation YCPlayStateVM

- (instancetype)initWithProps:(id<YCPlayStateProps>)props callbacks:(id<YCPlayStateCallbacks>)callbacks {
    if (self = [super init]) {
        self.props = props;
        self.callbacks = callbacks;
    }
    return self;
}

- (void)onTap {
    if ([self.callbacks respondsToSelector:@selector(switchPlayerStateOnTap)]) {
        [self.callbacks switchPlayerStateOnTap];
    }
}

@end
