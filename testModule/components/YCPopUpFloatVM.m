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
@property (nonatomic, weak) id<YCPopUpFloatCallbacks> callbacks;

#pragma mark - private
@property (nonatomic, weak) UIView *popUpView;
/** 是否初始化 */
@property (nonatomic, assign) BOOL isInited;
/** 弹出还是收起状态 */
@property (nonatomic, assign) BOOL isShow;

@end

@implementation YCPopUpFloatVM

- (instancetype)initWithProps:(id<YCPopUpFloatProps>)props callbacks:(id<YCPopUpFloatCallbacks>)callbacks {
    if (self = [super init]) {
        self.props = props;
        self.callbacks = callbacks;
        self.isShow = self.props.initShowState;
    }
    return self;
}

- (void)setPopUpView:(UIView *)popUpView {
    _popUpView = popUpView;
}

- (void)initCompleted {
    self.isInited = YES;
}

- (void)switchState {
    self.isShow = !self.isShow;
    
    if ([self.callbacks respondsToSelector:@selector(popUpFloat:onCompleted:)]) {
        [self.callbacks popUpFloat:self.popUpView onCompleted:self.isShow];
    }
}

@end
