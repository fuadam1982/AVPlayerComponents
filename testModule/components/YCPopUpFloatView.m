//
//  YCPopUpFloatView.m
//  testModule
//
//  Created by fuhan on 2017/6/6.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import "YCPopUpFloatView.h"

#pragma mark - viewmodel
#import "YCPopUpFloatVM.h"

#pragma mark - utils
#import "Masonry.h"
#import "ReactiveCocoa.h"

@interface YCPopUpFloatView ()

@property (nonatomic, strong) YCPopUpFloatVM *viewModel;
/** 用于控制弹出/收起布局 */
@property (nonatomic, strong) MASConstraint *popUpConstraint;
/** 自动隐藏Timer Dispose */
@property (nonatomic, strong) RACDisposable *autoHideTimerDispose;

@end

@implementation YCPopUpFloatView

- (id<YCStates>)viewModel {
    return [self getStates];
}

- (instancetype)init {
    if (self = [super init]) {
        [self.viewModel setPopUpView:self];
    }
    return self;
}

- (void)renderWithVarProps:(id<YCVarProps>)varProps {
    if (self.viewModel.props.isNotUsed) {
        self.hidden = YES;
        return;
    }
    
    [self dataBinding];
    if (self.viewModel.props.initShowState) {
        [self show];
    } else {
        [self hide];
    }
    [self.viewModel initCompleted];
}

- (void)dataBinding {
    @weakify(self);
    // 父组件控制弹出/收起
    [[[RACObserve(self.viewModel.props, changeState)
     filter:^BOOL(id value) {
         @strongify(self);
         // 初始化以后才响应动画操作
         return self.viewModel.isInited;
     }] deliverOnMainThread]
     subscribeNext:^(id x) {
         @strongify(self);
         // 父组件触发隐藏，销毁auto timer
         if (self.viewModel.isShow) {
             [self.autoHideTimerDispose dispose];
             self.autoHideTimerDispose = nil;
         }
         // 已经弹出则收起，收起则弹出
         [self popUpAnimation:!self.viewModel.isShow];
     }];    
   
    // 父组件告知重置自动隐藏timer
    [[[RACObserve(self.viewModel.props, resetAutoHiddenTimer) ignore:@NO]
     filter:^BOOL(id value) {
         @strongify(self);
         return self.viewModel.isShow;
     }]
     subscribeNext:^(id x) {
         @strongify(self);
         [self.autoHideTimerDispose dispose];
         self.autoHideTimerDispose = nil;
         [self autoHide];
     }];
}

/** 弹出布局 */
- (void)show {
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        if (self.viewModel.props.direction == YCPopUpFloatDirectionTypeUp) {
            self.popUpConstraint = make.bottom.equalTo(self.superview);
        } else if (self.viewModel.props.direction == YCPopUpFloatDirectionTypeDown) {
            self.popUpConstraint = make.top.equalTo(self.superview);
        } else if (self.viewModel.props.direction == YCPopUpFloatDirectionTypeLeft) {
            self.popUpConstraint = make.right.equalTo(self.superview);
        } else if (self.viewModel.props.direction == YCPopUpFloatDirectionTypeRight) {
            self.popUpConstraint = make.left.equalTo(self.superview);
        }
    }];
    [self autoHide];
}

/** 收起布局 */
- (void)hide {
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        if (self.viewModel.props.direction == YCPopUpFloatDirectionTypeUp) {
            self.popUpConstraint = make.top.equalTo(self.superview.mas_bottom);
        } else if (self.viewModel.props.direction == YCPopUpFloatDirectionTypeDown) {
            self.popUpConstraint = make.bottom.equalTo(self.superview.mas_top);
        } else if (self.viewModel.props.direction == YCPopUpFloatDirectionTypeLeft) {
            self.popUpConstraint = make.left.equalTo(self.superview.mas_right);
        } else if (self.viewModel.props.direction == YCPopUpFloatDirectionTypeRight) {
            self.popUpConstraint = make.right.equalTo(self.superview.mas_left);
        }
    }];
}

/** 切换动画 */
- (void)popUpAnimation:(BOOL)isShow {
    [self.popUpConstraint uninstall];
    if (isShow) {
        [self show];
    } else {
        [self hide];
    }
    
    [UIView animateWithDuration:self.viewModel.props.animationDuration animations:^{
        // 父view整体刷新才起作用
        [self.superview layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.viewModel switchState];
    }];
}

// 展开后自动收起
- (void)autoHide {
    @weakify(self);
    if (self.viewModel.props.autoHiddenDuration > 0) {
        self.autoHideTimerDispose = [[[[RACSignal interval:self.viewModel.props.autoHiddenDuration
                                               onScheduler:[RACScheduler scheduler]]
                                       take:1] deliverOnMainThread]
                                     subscribeNext:^(id x) {
                                         @strongify(self);
                                         [self popUpAnimation:NO];
                                     }];
    }
}

@end
