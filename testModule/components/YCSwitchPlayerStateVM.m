//
//  YCSwitchPlayerStateVM.m
//  testModule
//
//  Created by fuhan on 2017/6/6.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import "YCSwitchPlayerStateVM.h"

@interface YCSwitchPlayerStateVM ()

#pragma mark - YCStates
@property (nonatomic, strong) id<YCSwitchPlayerStateProps> props;
@property (nonatomic, weak) id<YCSwitchPlayerStateCallbacks> callbacks;

@end

@implementation YCSwitchPlayerStateVM

- (instancetype)initWithProps:(id<YCSwitchPlayerStateProps>)props callbacks:(id<YCSwitchPlayerStateCallbacks>)callbacks {
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
