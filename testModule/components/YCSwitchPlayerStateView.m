//
//  YCPlayStateView.m
//  testModule
//
//  Created by fuhan on 2017/6/6.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import "YCSwitchPlayerStateView.h"

#pragma mark - viewmodel
#import "YCSwitchPlayerStateVM.h"

#pragma mark - utils
#import "Masonry.h"
#import "ReactiveCocoa.h"

@interface YCPlayStateView ()

@property (nonatomic, strong) YCPlayStateVM *viewModel;
@property (nonatomic, strong) UIButton *button;

@end

@implementation YCPlayStateView

- (id<YCStates>)viewModel {
    return [self getStates];
}

- (instancetype)init {
    if (self = [super init]) {
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.button addTarget:self action:@selector(onTap) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.button];
        
        [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.and.bottom.equalTo(self);
        }];
    }
    return self;
}

- (void)renderWithVarProps:(id<YCVarProps>)varProps {
    if (self.viewModel.props.isNotUsed) {
        self.hidden = YES;
    } else {
        [self dataBinding];
    }
}

- (void)dataBinding {
    @weakify(self);
    [[RACObserve(self.viewModel.props, isHidden) deliverOnMainThread]
     subscribeNext:^(NSNumber *isHidden) {
         @strongify(self);
         self.hidden = isHidden.boolValue;
     }];
    
    [[RACObserve(self.viewModel.props, isDisable) deliverOnMainThread]
     subscribeNext:^(NSNumber *isDisable) {
         @strongify(self);
         self.button.enabled = !isDisable.boolValue;
     }];
    
    [[RACObserve(self.viewModel.props, isPause) deliverOnMainThread]
     subscribeNext:^(NSNumber *isPause) {
         @strongify(self);
         UIImage *img = nil;
         UIImage *imgHighlight = nil;
         // 暂停时显示播放按钮，播放时显示暂停按钮
         if (isPause.boolValue) {
             img = [UIImage imageNamed:self.viewModel.props.btnPlayImage];
             if (self.viewModel.props.btnPlayHighlightImage) {
                 imgHighlight = [UIImage imageNamed:self.viewModel.props.btnPlayHighlightImage];
             }
         } else {
             img = [UIImage imageNamed:self.viewModel.props.btnPauseImage];
             if (self.viewModel.props.btnPauseHighlightImage) {
                 imgHighlight = [UIImage imageNamed:self.viewModel.props.btnPauseHighlightImage];
             }
         }
         
         if (img) {
            [self.button setImage:img forState:UIControlStateNormal];
         }
         if (imgHighlight) {
             [self.button setImage:imgHighlight forState:UIControlStateHighlighted];
         }
     }];
}

- (void)onTap {
    [self.viewModel onTap];
}

@end
