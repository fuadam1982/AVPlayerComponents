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

@interface YCPortraitPlayerView ()

@property (nonatomic, strong) YCPortraitPlayerVM *viewModel;
@property (nonatomic, strong) YCAVPlayerView *playerView;

@end

@implementation YCPortraitPlayerView

- (id<YCStates>)viewModel {
    return [self getStates];
}

- (instancetype)initWithProps:(id<YCAVPlayerProps>)props callbacks:(id<YCAVPlayerCallbacks>)callbacks {
    if (self = [super initWithStates:nil]) {
        self.playerView = [[YCAVPlayerView alloc] initWithProps:props callbacks:callbacks];
        [self addSubview:self.playerView];
        
        [self layout];
    }
    return self;
}

- (void)layout {
    [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.and.right.equalTo(self);
    }];
}

@end
