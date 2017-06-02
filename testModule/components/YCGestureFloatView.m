//
//  YCGestureFloatView.m
//  testModule
//
//  Created by fuhan on 2017/6/2.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import "YCGestureFloatView.h"
#import "YCGestureFloatVM.h"

@interface YCGestureFloatView ()

@property (nonatomic, strong) YCGestureFloatVM *viewModel;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) UITapGestureRecognizer *doubleTapGesture;
@property (nonatomic, strong) UISwipeGestureRecognizer *swipeGesutre;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGesture;

@end

@implementation YCGestureFloatView

- (id<YCStates>)viewModel {
    return [self getStates];
}

- (instancetype)initWithProps:(id<YCGestureFloatProps>)props callbacks:(id<YCGestureFloatCallbacks>)callbacks {
    YCGestureFloatVM *states = [[YCGestureFloatVM alloc] initWithProps:props callbacks:callbacks];
    if (self = [super initWithStates:states]) {
        
    }
    return self;
}

@end
