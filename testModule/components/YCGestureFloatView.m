//
//  YCGestureFloatView.m
//  testModule
//
//  Created by fuhan on 2017/6/2.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import "YCGestureFloatView.h"

#pragma mark - componet
#import "YCGestureFloatComponet.h"

#pragma mark - viewmodel
#import "YCGestureFloatVM.h"

@interface YCGestureFloatView ()

@property (nonatomic, strong) YCGestureFloatVM *viewModel;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) UITapGestureRecognizer *doubleTapGesture;
@property (nonatomic, strong) NSMutableArray<UISwipeGestureRecognizer *> *swipeGesutreList;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGesture;

@end

@implementation YCGestureFloatView

- (id<YCStates>)viewModel {
    return [self getStates];
}

- (void)renderWithVarProps:(id<YCVarProps>)varProps {
    if (self.viewModel.props.isNotUsed) {
        self.hidden = YES;
    } else {
        [self buildGesture];
    }
}

- (void)buildGesture {
    if (self.viewModel.props.useDoubleTap) {
        self.doubleTapGesture = [[UITapGestureRecognizer alloc] init];
        [self.doubleTapGesture setNumberOfTapsRequired:2];
        [self addGestureRecognizer:self.doubleTapGesture];
        [self.doubleTapGesture addTarget:self action:@selector(onDoubleTap)];
    }
    if (self.viewModel.props.useTap) {
        self.tapGesture = [[UITapGestureRecognizer alloc] init];
        [self.tapGesture setNumberOfTapsRequired:1];
        [self addGestureRecognizer:self.tapGesture];
        [self.tapGesture addTarget:self action:@selector(onTap)];
        
        if (self.doubleTapGesture) {
            [self.tapGesture requireGestureRecognizerToFail:self.doubleTapGesture];
        }
    }
    if (self.viewModel.props.useLongPress) {
        self.longPressGesture = [[UILongPressGestureRecognizer alloc] init];
        [self addGestureRecognizer:self.longPressGesture];
        [self.longPressGesture addTarget:self action:@selector(onLongPress)];
    }
    if (self.viewModel.props.usePan) {
        self.panGesture = [UIPanGestureRecognizer new];
        [self addGestureRecognizer:self.panGesture];
    }
    if (self.viewModel.props.useSwipe) {
        self.swipeGesutreList = [[NSMutableArray alloc] initWithCapacity:4];
        if ((self.viewModel.props.swipeDirection & YCGestureFloatDirectionTypeLeft) == YCGestureFloatDirectionTypeLeft) {
            UISwipeGestureRecognizer *swipe = [UISwipeGestureRecognizer new];
            swipe.direction = UISwipeGestureRecognizerDirectionLeft;
            [swipe addTarget:self action:@selector(onSwip:)];
            [self addGestureRecognizer:swipe];
            [self.swipeGesutreList addObject:swipe];
        }
        if ((self.viewModel.props.swipeDirection & YCGestureFloatDirectionTypeRight) == YCGestureFloatDirectionTypeRight) {
            UISwipeGestureRecognizer *swipe = [UISwipeGestureRecognizer new];
            swipe.direction = UISwipeGestureRecognizerDirectionRight;
            [swipe addTarget:self action:@selector(onSwip:)];
            [self addGestureRecognizer:swipe];
            [self.swipeGesutreList addObject:swipe];
        }
        if ((self.viewModel.props.swipeDirection & YCGestureFloatDirectionTypeUp) == YCGestureFloatDirectionTypeUp) {
            UISwipeGestureRecognizer *swipe = [UISwipeGestureRecognizer new];
            swipe.direction = UISwipeGestureRecognizerDirectionUp;
            [swipe addTarget:self action:@selector(onSwip:)];
            [self addGestureRecognizer:swipe];
            [self.swipeGesutreList addObject:swipe];
        }
        if ((self.viewModel.props.swipeDirection & YCGestureFloatDirectionTypeDown) == YCGestureFloatDirectionTypeDown) {
            UISwipeGestureRecognizer *swipe = [UISwipeGestureRecognizer new];
            swipe.direction = UISwipeGestureRecognizerDirectionDown;
            [swipe addTarget:self action:@selector(onSwip:)];
            [self addGestureRecognizer:swipe];
            [self.swipeGesutreList addObject:swipe];
        }
        // TODO: 测试依赖关系
        if (self.panGesture) {
            for (UISwipeGestureRecognizer *swipGesture in self.swipeGesutreList) {
                [swipGesture requireGestureRecognizerToFail:self.panGesture];
            }
        }
    }
}

- (void)onDoubleTap {
    NSLog(@">>> %d", self.viewModel.props.pauseRespondGesture);
    if (self.viewModel.props.pauseRespondGesture
        && self.viewModel.lastRespondType != YCGestureFloatTypeDoubleTap) {
        return;
    }
    
    [self.viewModel onDoubleTap];
}

- (void)onTap {
    if (self.viewModel.props.pauseRespondGesture
        && self.viewModel.lastRespondType != YCGestureFloatTypeTap) {
        return;
    }
    
    [self.viewModel onTap];
}

- (void)onLongPress {
    if (self.viewModel.props.pauseRespondGesture
        && self.viewModel.lastRespondType != YCGestureFloatTypeLongPress) {
        return;
    }
    
    [self.viewModel onLongPress];
}

- (void)onSwip:(UISwipeGestureRecognizer *)recognizer {
    if (self.viewModel.props.pauseRespondGesture
        && self.viewModel.lastRespondType != YCGestureFloatTypeSwip) {
        return;
    }
    
    if(recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        [self.viewModel onSwipWithDirection:YCGestureFloatDirectionTypeLeft];
    } else if(recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        [self.viewModel onSwipWithDirection:YCGestureFloatDirectionTypeRight];
    } else if(recognizer.direction == UISwipeGestureRecognizerDirectionUp) {
        [self.viewModel onSwipWithDirection:YCGestureFloatDirectionTypeUp];
    } else if(recognizer.direction == UISwipeGestureRecognizerDirectionDown) {
        [self.viewModel onSwipWithDirection:YCGestureFloatDirectionTypeDown];
    }
}

- (void)onPan {
    if (self.viewModel.props.pauseRespondGesture
        && self.viewModel.lastRespondType != YCGestureFloatTypePan) {
        return;
    }
    
    // TODO: get direction
    [self.viewModel onPanWithDirection:YCGestureFloatDirectionTypeNone];
}

@end
