//
//  YCGestureFloatView.m
//  testModule
//
//  Created by fuhan on 2017/6/2.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import "YCGestureFloatView.h"
#import "YCGestureFloatVM.h"

@interface YCGestureFloatView: YCViewTemplate

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

- (instancetype)init {
    if (self = [super init]) {
        [self buildGesture];
    }
    return self;
}

- (void)buildGesture {
    if (self.viewModel.props.useDoubleTap) {
        self.doubleTapGesture = [UITapGestureRecognizer new];
        [self.doubleTapGesture setNumberOfTapsRequired:2];
        [self addGestureRecognizer:self.doubleTapGesture];
        [self.doubleTapGesture addTarget:self action:@selector(onDoubleTap)];
    }
    if (self.viewModel.props.useTap) {
        self.tapGesture = [UITapGestureRecognizer new];
        [self.tapGesture setNumberOfTapsRequired:1];
        [self addGestureRecognizer:self.tapGesture];
        [self.tapGesture addTarget:self action:@selector(onTap)];
        
        if (self.doubleTapGesture) {
            [self.tapGesture requireGestureRecognizerToFail:self.doubleTapGesture];
        }
    }
    if (self.viewModel.props.useLongPress) {
        self.longPressGesture = [UILongPressGestureRecognizer new];
        [self addGestureRecognizer:self.longPressGesture];
        [self.longPressGesture addTarget:self action:@selector(onLongPress)];
    }
    if (self.viewModel.props.useSwipe) {
        self.swipeGesutre = [UISwipeGestureRecognizer new];
        [self addGestureRecognizer:self.swipeGesutre];
    }
    if (self.viewModel.props.usePan) {
        self.panGesture = [UIPanGestureRecognizer new];
        [self addGestureRecognizer:self.panGesture];
        
        if (self.swipeGesutre) {
            [self.panGesture requireGestureRecognizerToFail:self.swipeGesutre];
        }
    }
}

- (void)onDoubleTap {
    [self.viewModel onDoubleTap];
}

- (void)onTap {
    [self.viewModel onTap];
}

- (void)onLongPress {
    [self.viewModel onLongPress];
}

- (void)onSwip {
    // TODO: get direction
    [self.viewModel onSwipWithDirection:YCGestureFloatDirectionTypeNone];
}

- (void)onPan {
    // TODO: get direction
    [self.viewModel onPanWithDirection:YCGestureFloatDirectionTypeNone];
}

@end

//////////////////////////////////////////////////////////////

@implementation YCGestureFloatComponet

- (instancetype)initWithProps:(id<YCGestureFloatProps>)props callbacks:(id<YCGestureFloatCallbacks>)callbacks {
    YCGestureFloatVM *states = [[YCGestureFloatVM alloc] initWithProps:props callbacks:callbacks];
    YCGestureFloatView *template = [[YCGestureFloatView alloc] init];
    return [super initWithStates:states template:template];
}

@end
