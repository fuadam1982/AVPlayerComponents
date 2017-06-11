//
//  YCShowProtraitPlayerView.m
//  testModule
//
//  Created by lucifer on 11/06/2017.
//  Copyright © 2017 fuhan. All rights reserved.
//

#import "YCShowProtraitPlayerView.h"

#pragma mark - components
#import "YCPortraitPlayerComponent.h"

#pragma mark - viewmodel
#import "YCShowProtraitPlayerVM.h"

@interface YCShowProtraitPlayerView ()

@property (nonatomic, strong) YCShowProtraitPlayerVM *viewModel;
@property (nonatomic, strong) YCVideoPlayerComponent *videoComponent;
@property (nonatomic, strong) UIButton *fullScreenButton;
@property (nonatomic, strong) UIButton *backButton;

@end

@implementation YCShowProtraitPlayerView

- (id<YCStates>)viewModel {
    return [self getStates];
}

- (void)renderWithVarProps:(id<YCVarProps>)varProps {
    id playerComponent = toComponent([YCVideoPlayerComponent class])
    .childrenVarProps(^(id<YCVideoPlayerVarProps> varProps) {
        varProps.gesture.useTap = YES;
        varProps.gesture.useDoubleTap = YES;
        varProps.gesture.initGestureType = YCGestureFloatTypeTap;
        
        varProps.status.direction = YCPopUpFloatDirectionTypeUp;
        varProps.status.animationDuration = 0.2;
        varProps.status.autoHiddenDuration = 5;
    })
    .states((id<YCStates>)self.viewModel.props)
    .callbacks(self.viewModel.callbacks)
    .superView(self)
    .build();
    self.videoComponent = playerComponent;
}

@end
