//
//  YCPortraitPlayerView.m
//  testModule
//
//  Created by fuhan on 2017/6/1.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import "YCPortraitPlayerView.h"

#pragma mark - viewmodel
#import "YCPortraitPlayerVM.h"

#pragma mark - utils
#import "Masonry.h"

@interface YCPortraitPlayerView: YCViewTemplate

@property (nonatomic, strong) YCPortraitPlayerVM *viewModel;
@property (nonatomic, strong) YCAVPlayerComponent *playerComponent;
@property (nonatomic, strong) UIView *playerView;

@end

@implementation YCPortraitPlayerView

- (id<YCStates>)viewModel {
    return [self getStates];
}

- (void)render {
    self.playerComponent = [[YCAVPlayerComponent alloc] initWithProps:self.viewModel.props
                                                            callbacks:self.viewModel.callbacks];
    self.playerView = [self.playerComponent getView];
    [self addSubview:self.playerView];
}

- (void)layout {
    [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.and.right.equalTo(self);
    }];
}

@end

//////////////////////////////////////////////////////////////

@implementation YCPortraitPlayerComponent

- (instancetype)initWithProps:(id<YCAVPlayerProps>)props callbacks:(id<YCAVPlayerCallbacks>)callbacks {
    YCPortraitPlayerVM *states = [[YCPortraitPlayerVM alloc] initWithProps:props callbacks:callbacks];
    YCPortraitPlayerView *template = [[YCPortraitPlayerView alloc] init];
    return [super initWithStates:states template:template];
}

@end
