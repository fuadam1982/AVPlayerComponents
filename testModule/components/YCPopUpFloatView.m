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

@property (nonatomic, strong) MASConstraint *popUpConstraint;
@property (nonatomic, assign) BOOL isAnimating;

@end

@implementation YCPopUpFloatView

- (id<YCStates>)viewModel {
    return [self getStates];
}

- (void)render {
    [self dataBinding];
}

- (void)dataBinding {
    @weakify(self);
    [[[RACObserve(self.viewModel.props, changeState)
     filter:^BOOL(id value) {
         @strongify(self);
         return self.viewModel.isInited;
     }] deliverOnMainThread]
     subscribeNext:^(id x) {
//         [self popUpAnimation:!self.viewModel.isShow];
     }];
    
    [[[RACObserve(self.viewModel.props, startInit)
       ignore:@NO] take:1]
     subscribeNext:^(id x) {
         @strongify(self);
         if (self.viewModel.props.initShowState) {
//             [self show];
         } else {
//             [self hide];
         }
         [self.viewModel initCompleted];
     }];
}

- (void)show {
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        self.popUpConstraint = make.bottom.equalTo(self.superview);
    }];
}

- (void)hide {
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        self.popUpConstraint = make.top.equalTo(self.superview.mas_bottom);
    }];
}

- (void)popUpAnimation:(BOOL)isShow {
    [self.popUpConstraint uninstall];
    if (self.viewModel.isShow) {
        [self hide];
    } else {
        [self show];
    }
    
//    [self setNeedsUpdateConstraints];
//    [self updateConstraintsIfNeeded];
    [UIView animateWithDuration:1 animations:^{
//        self.isAnimating = YES;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
//        self.isAnimating = NO;
        [self.viewModel switchState];
    }];
//    [self setNeedsUpdateConstraints];
}

//- (void)updateConstraints {
//    if (self.viewModel.isInited && self.isAnimating) {
//        [self.popUpConstraint uninstall];
//        if (self.viewModel.isShow) {
//            [self hide];
//        } else {
//            [self show];
//        }
//    }
//    [super updateConstraints];
//}

@end
