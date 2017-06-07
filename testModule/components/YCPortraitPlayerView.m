//
//  YCPortraitPlayerView.m
//  testModule
//
//  Created by fuhan on 2017/6/1.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import "YCPortraitPlayerView.h"

#pragma mark - component
#import "YCAVPlayerComponent.h"
#import "YCGestureFloatComponet.h"
#import "YCSwitchPlayerStateComponent.h"
#import "YCPopUpFloatComponent.h"

#pragma mark - viewmodel
#import "YCPortraitPlayerVM.h"

#pragma mark - utils
#import "Masonry.h"
#import "ComponentPropsBuilder.h"

@interface YCPortraitPlayerView () <YCAVPlayerCallbacks,
                                    YCGestureFloatCallbacks,
                                    YCSwitchPlayerStateCallbacks,
                                    YCPopUpFloatCallbacks>

@property (nonatomic, strong) YCPortraitPlayerVM *viewModel;
// TODO: 共享实例
/** 基础播放器组件 */
@property (nonatomic, strong) YCAVPlayerComponent *playerComponent;
/** 手势浮动层组件 */
@property (nonatomic, strong) YCGestureFloatComponet *gestureFloatComponent;
/** 手势浮动层上的播放按钮组件 */
@property (nonatomic, strong) YCSwitchPlayerStateComponent *gesturePlayComponent;
/** 视频状态控制栏 */
@property (nonatomic, strong) YCPopUpFloatComponent *statusBarComponent;
/** 状态控制栏上的播放按钮组件 */
@property (nonatomic, strong) YCSwitchPlayerStateComponent *statusPlayComponent;

/** 视频时长label */
@property (nonatomic, strong) UILabel *videoDurationLabel;
/** 播放时长label */
@property (nonatomic, strong) UILabel *playDurationLabel;
/** 全屏播放按钮 */
@property (nonatomic, strong) UIButton *fullScreenButton;

@end

@implementation YCPortraitPlayerView

- (id<YCStates>)viewModel {
    return [self getStates];
}

- (instancetype)init {
    if (self = [super init]) {
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)render {
    // 视频播放器
    id playerProps = toProps(@protocol(YCAVPlayerProps))
                        .states(self.viewModel)
                        .nameMappingBlock(^NSString * (NSString *key) {
                            if (!([key isEqualToString:@"currVideoURL"]
                                || [key isEqualToString:@"isCancelPlay"]
                                || [key isEqualToString:@"isPause"]
                                || [key isEqualToString:@"seekTimePoint"])) {
                                return toKeyPath(@"props", key);
                            }
                            return key;
                        })
                        .build();
    self.playerComponent = [[YCAVPlayerComponent alloc] initWithProps:playerProps
                                                            callbacks:self];
    [self addSubview:self.playerComponent.view];
    
    // 手势浮动层
    id gestureProps = toProps(@protocol(YCGestureFloatProps))
                        .states(self.viewModel)
                        .nameMapping(@{@"pauseRespondGesture": @"isPauseRespondGesture"})
                        .constVars(@{
                                     @"useTap": @YES,
                                     @"useDoubleTap": @YES,
                                     @"initGestureType": @(YCGestureFloatTypeTap),
                                     })
                        .build();
    self.gestureFloatComponent = [[YCGestureFloatComponet alloc] initWithProps:gestureProps
                                                                     callbacks:self];
    [self addSubview:self.gestureFloatComponent.view];
    
    // 手势浮动层上的播放按钮
    id gesturePlayProps = toProps(@protocol(YCSwitchPlayerStateProps))
                            .states(self.viewModel)
                            .nameMapping(@{@"isHidden": @"isHiddenForSwitchPlayerButton"})
                            .build();
    self.gesturePlayComponent = [[YCSwitchPlayerStateComponent alloc] initWithProps:gesturePlayProps
                                                                          callbacks:self];
    [self.gestureFloatComponent.view addSubview:self.gesturePlayComponent.view];
    
    // TODO: resetAutoHidden
    // 视频状态控制栏
    id popUpProps = toProps(@protocol(YCPopUpFloatProps))
                        .states(self.viewModel)
                        .nameMapping(@{
                                       @"startInit": @"statusBarInitState",
                                       @"changeState": @"statusBarChangeState"
                                       })
                        .constVars(@{
                                     @"direction": @(YCPopUpFloatDirectionTypeUp),
                                     // TODO: check
                                     @"animationDuration": @(0.2),
                                     @"autoHiddenDuration": @5,
                                     @"initShowState": @(self.viewModel.innerStatusBarChangeState),
                                     })
                        .build();
    self.statusBarComponent = [[YCPopUpFloatComponent alloc] initWithProps:popUpProps
                                                                 callbacks:self];
    [self addSubview:self.statusBarComponent.view];
    
    // 状态控制栏上的播放按钮
    id statusPlayProps = toProps(@protocol(YCSwitchPlayerStateProps))
                            .states(self.viewModel)
                            .build();
    self.statusPlayComponent = [[YCSwitchPlayerStateComponent alloc] initWithProps:statusPlayProps
                                                                         callbacks:self];
    [self.statusBarComponent.view addSubview:self.statusPlayComponent.view];
    
    // 视频播放时长
    self.videoDurationLabel = [[UILabel alloc] init];
    self.videoDurationLabel.textColor = [UIColor whiteColor];
    self.videoDurationLabel.font = [UIFont systemFontOfSize:14];
    self.videoDurationLabel.text = @"00:00";
    [self.statusBarComponent.view addSubview:self.videoDurationLabel];
    self.playDurationLabel = [[UILabel alloc] init];
    self.playDurationLabel.textColor = [UIColor whiteColor];
    self.playDurationLabel.font = [UIFont systemFontOfSize:14];
    self.playDurationLabel.text = @"00:00";
    [self.statusBarComponent.view addSubview:self.playDurationLabel];
    
    // 全屏按钮
    self.fullScreenButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.fullScreenButton.backgroundColor = [UIColor blueColor];
    [self.statusBarComponent.view addSubview:self.fullScreenButton];
    
    [self layout];
}

- (void)layout {
    // 视频播放器
    [self.playerComponent.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.and.right.equalTo(self);
    }];
    
    // 手势浮动层
    [self.gestureFloatComponent.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.and.right.equalTo(self);
    }];
    
    // 手势浮动层上的播放按钮
    [self.gesturePlayComponent.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(102.5);
        make.right.equalTo(self).offset(-20);
        make.width.and.height.equalTo(@50);
    }];
    self.gesturePlayComponent.view.backgroundColor = [UIColor blueColor];
    
    // 状态控制栏
    [self.statusBarComponent.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.width.equalTo(self);
        make.height.equalTo(@61);
    }];
    [self.viewModel initStatusBarState];
    
    // 状态栏上的播放按钮
    [self.statusPlayComponent.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@22);
        make.size.equalTo([NSValue valueWithCGSize:CGSizeMake(12, 14)]);
        make.centerY.equalTo(self.statusBarComponent.view);
    }];
    self.statusPlayComponent.view.backgroundColor = [UIColor blueColor];
    
    // 状态栏上的全屏按钮
    [self.fullScreenButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.statusBarComponent.view).offset(-16);
        make.width.and.height.equalTo(@22);
        make.centerY.equalTo(self.statusBarComponent.view);
    }];
    
    // 状态栏上的视频播放时间
    [self.videoDurationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.fullScreenButton.mas_left).offset(-12);
        make.centerY.equalTo(self.statusBarComponent.view);
    }];    
    [self.playDurationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.statusPlayComponent.view.mas_right).offset(16);
        make.centerY.equalTo(self.statusBarComponent.view);
    }];
}

#pragma mark - YCAVPlayerCallbacks

- (void)player:(UIView *)player onReadVideoDuration:(NSTimeInterval)videoDuration {
    self.videoDurationLabel.text = [self formatTimeBySeconds:videoDuration];
}

- (void)player:(UIView *)player onPlayingCurrTime:(NSTimeInterval)currTime isPause:(BOOL)isPause {
    self.playDurationLabel.text = [self formatTimeBySeconds:currTime];
}

#pragma mark - YCGestureFloatCallbacks

- (void)gesturerOnTap:(UIView *)gesturer {
    [self.viewModel switchStatusBarState];
}

- (void)gesturerOnDoubleTap:(UIView *)gesturer {
    [self.viewModel switchPlayerState];
}

#pragma mark - YCSwitchPlayerStateCallbacks

- (void)switchPlayerStateOnTap {
    [self.viewModel switchPlayerState];
}

#pragma mark - YCPopUpFloatCallbacks

- (void)popUpFloat:(UIView *)popUp onCompleted:(BOOL)isShow {
    if (!isShow) {
        // 状态栏收起后恢复手势层响应
        [self.viewModel resetRespondGesture];
    }
}

#pragma mark - private methods

- (NSString *)formatTimeBySeconds:(NSTimeInterval)duration {
    int intDuration = round(duration);
    int min = intDuration / 60;
    int sec = (intDuration - min * 60);
    return [NSString stringWithFormat:@"%02d:%02d", min, sec];
}

@end
