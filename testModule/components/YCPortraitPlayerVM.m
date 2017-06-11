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

@interface YCVideoPlayerVM ()

#pragma mark - YCStates
@property (nonatomic, strong) id<YCVideoPlayerProps> props;
@property (nonatomic, weak) id<YCVideoPlayerCallbacks> callbacks;

#pragma mark - YCPortraitPlayerStates
/** 视频播放地址，如果发生变化即切换清晰度 */
@property (nonatomic, strong) NSString *currVideoURL;
/** 是否手动取消播放 */
@property (nonatomic, assign) BOOL isCancelPlay;
/** 是否暂停，默认加载好立即播放 */
@property (nonatomic, assign) BOOL isPause;
/** 从指定时间点开始播放 */
@property (nonatomic, assign) NSTimeInterval seekTimePoint;

#pragma mark - private
/** 控制浮动层上的播放按钮是否隐藏 */
@property (nonatomic, assign) BOOL isHiddenForSwitchPlayerButton;
/** 控制状态栏弹出/隐藏 */
@property (nonatomic, assign) BOOL statusBarChangeState;
/** 内部存储状态用来判断是否已经隐藏状态栏 */
@property (nonatomic, assign) BOOL innerStatusBarChangeState;
/** 是否暂停手势浮动层响应 */
@property (nonatomic, assign) BOOL isPauseRespondGesture;

@end

@implementation YCVideoPlayerVM

- (instancetype)initWithProps:(id<YCVideoPlayerProps>)props callbacks:(id<YCVideoPlayerCallbacks>)callbacks {
    if (self = [super init]) {
        self.props = props;
        self.callbacks = callbacks;
        // 设置初始值
        self.currVideoURL = self.props.videoURLs[0];
        self.isPause = self.props.isPause;
        self.seekTimePoint = self.props.seekTimePoint;
        
        [self dataBinding];
        
        // 初始化时弹出状态栏，所以暂停手势层响应
        self.innerStatusBarChangeState = YES;
        self.isPauseRespondGesture = YES;
    }
    return self;
}

- (void)dataBinding {
    @weakify(self);
    [RACObserve(self, isPause) subscribeNext:^(NSNumber *isPause) {
        @strongify(self);
        self.isHiddenForSwitchPlayerButton = !isPause.boolValue;
        if (self.isHiddenForSwitchPlayerButton) {
            // 双击播放时恢复手势响应
            self.isPauseRespondGesture = NO;
        } else {
            // 双击暂停时停止手势层响应
            self.isPauseRespondGesture = YES;
        }
    }];
}

- (void)switchPlayerState {
    self.isPause = !self.isPause;
}

- (void)switchStatusBarState {
    self.statusBarChangeState = !self.statusBarChangeState;
    self.innerStatusBarChangeState = !self.innerStatusBarChangeState;
    if (self.innerStatusBarChangeState) {
        // 显示状态栏则停止手势层响应
        self.isPauseRespondGesture = YES;
    }
}

- (void)resetRespondGesture {
    self.innerStatusBarChangeState = NO;
    self.isPauseRespondGesture = NO;
}

@end
