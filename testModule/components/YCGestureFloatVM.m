//
//  YCGestureFloatVM.m
//  testModule
//
//  Created by fuhan on 2017/6/2.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import "YCGestureFloatVM.h"

@interface YCGestureFloatVM ()

#pragma mark - YCStates
@property (nonatomic, strong) id<YCGestureFloatProps> props;
@property (nonatomic, weak) id<YCGestureFloatCallbacks> callbacks;

#pragma mark - private
@property (nonatomic, weak) UIView *gesturer;

@end

@implementation YCGestureFloatVM

- (instancetype)initWithProps:(id<YCGestureFloatProps>)props callbacks:(id<YCGestureFloatCallbacks>)callbacks {
    if (self = [super init]) {
        self.props = props;
        self.callbacks = callbacks;
    }
    return self;
}

- (void)setGesturer:(UIView *)gesturer {
    self.gesturer = gesturer;
}

- (void)onDoubleTap {
    if ([self.callbacks respondsToSelector:@selector(gesturerOnDoubleTap:)]) {
        [self.callbacks gesturerOnDoubleTap:self.gesturer];
    }
}

- (void)onTap {
    if ([self.callbacks respondsToSelector:@selector(gesturerOnTap:)]) {
        [self.callbacks gesturerOnTap:self.gesturer];
    }
}

- (void)onLongPress {
    if ([self.callbacks respondsToSelector:@selector(gesturerOnLongPress:)]) {
        [self.callbacks gesturerOnLongPress:self.gesturer];
    }
}

- (void)onSwipWithDirection:(YCGestureFloatDirectionType)direction {
    if ([self.callbacks respondsToSelector:@selector(gesturer:onSwipeWithDirection:)]) {
        [self.callbacks gesturer:self.gesturer onSwipeWithDirection:direction];
    }
}

- (void)onPanWithDirection:(YCGestureFloatDirectionType)direction {
    if ([self.callbacks respondsToSelector:@selector(gesturer:onPanWithDirection:)]) {
        [self.callbacks gesturer:self.gesturer onPanWithDirection:direction];
    }
}

@end
