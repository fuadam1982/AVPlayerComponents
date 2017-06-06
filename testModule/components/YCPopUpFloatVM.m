//
//  YCPopUpFloatVM.m
//  testModule
//
//  Created by fuhan on 2017/6/6.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import "YCPopUpFloatVM.h"

@interface YCPopUpFloatVM ()

#pragma mark - YCStates
@property (nonatomic, strong) id<YCPopUpFloatProps> props;

#pragma mark - private
/** 是否初始化 */
@property (nonatomic, assign) BOOL isInited;
/** 弹出还是收起状态 */
@property (nonatomic, assign) BOOL isShow;

@end

@implementation YCPopUpFloatVM

- (instancetype)initWithProps:(id<YCPopUpFloatProps>)props callbacks:(id<YCCallbacks>)callbacks {
    if (self = [super init]) {
        self.props = props;
        self.isShow = self.props.initShowState;
    }
    return self;
}

- (void)initCompleted {
    self.isInited = YES;
}

- (void)switchState {
    self.isShow = !self.isShow;
}

@end
