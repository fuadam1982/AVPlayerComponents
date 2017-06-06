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
    [[RACObserve(self.viewModel.props, changeState)
     filter:^BOOL(id value) {
         @strongify(self);
         return self.viewModel.isInited;
     }] subscribeNext:^(id x) {
         if (self) {
             if (self.viewModel.isShow) {
                 [self hide];
             } else {
                 [self show];
             }
             [self.viewModel switchState];
         }
     }];
    
    [[[RACObserve(self.viewModel.props, startInit)
       ignore:@NO] take:1]
     subscribeNext:^(id x) {
         @strongify(self);
         if (self.viewModel.props.initShowState) {
             [self mas_updateConstraints:^(MASConstraintMaker *make) {
                 make.bottom.equalTo(self.superview);
             }];
         } else {

         }
         [self.viewModel initCompleted];
     }];
}

- (void)show {
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.superview);
    }];
}

- (void)hide {
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.superview.mas_bottom);
    }];
}

@end
