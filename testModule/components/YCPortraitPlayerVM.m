//
//  YCPortraitPlayerVM.m
//  testModule
//
//  Created by fuhan on 2017/6/1.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import "YCPortraitPlayerVM.h"

#pragma mark - utils
#import "ReactiveCocoa.h"

@interface YCPortraitPlayerVM ()

#pragma mark - YCStates
@property (nonatomic, strong) id<YCAVPlayerProps> props;
@property (nonatomic, weak) id<YCPortraitPlayerCallbacks> callbacks;

#pragma mark - YCPortraitPlayerStates
/** 视频播放地址，如果发生变化即切换清晰度 */
@property (nonatomic, strong) NSString *currVideoURL;
/** 是否手动取消播放 */
@property (nonatomic, assign) BOOL isCancelPlay;
/** 是否暂停，默认加载好立即播放 */
@property (nonatomic, assign) BOOL isPause;
/** 从指定时间点开始播放 */
@property (nonatomic, assign) NSTimeInterval seekTimePoint;
/** 是否显示播放状态栏 */
@property (nonatomic, assign) BOOL showStatusBar;

#pragma mark - private
/** 控制浮动层上的播放按钮是否隐藏 */
@property (nonatomic, assign) BOOL isHiddenForSwitchPlayerButton;

@end

@implementation YCPortraitPlayerVM

- (instancetype)initWithProps:(id<YCAVPlayerProps>)props callbacks:(id<YCPortraitPlayerCallbacks>)callbacks {
    if (self = [super init]) {
        self.props = props;
        self.callbacks = callbacks;
        // 设置初始值
        self.currVideoURL = self.props.currVideoURL;
        self.isPause = self.props.isPause;
        self.seekTimePoint = self.props.seekTimePoint;
        
        [self dataBinding];
    }
    return self;
}

- (void)dataBinding {
    @weakify(self);
    [RACObserve(self, isPause) subscribeNext:^(NSNumber *isPause) {
        @strongify(self);
        self.isHiddenForSwitchPlayerButton = !isPause.boolValue;
    }];
}

- (void)switchPlayerState {
    self.isPause = !self.isPause;
}

@end
