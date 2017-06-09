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

@interface YCVideoPlayerView () <YCVideoPlayerLayout,
                                YCAVPlayerCallbacks,
                                YCGestureFloatCallbacks,
                                YCPlayStateCallbacks,
                                YCPopUpFloatCallbacks>

@property (nonatomic, strong) YCVideoPlayerVM *viewModel;

/** 基础播放器组件 */
@property (nonatomic, strong) YCAVPlayerComponent *playerComponent;

#pragma mark - GestureFloat
/** 手势浮动层组件 */
@property (nonatomic, strong) YCGestureFloatComponet *gestureFloatComponent;
/** 手势浮动层上的播放按钮组件 */
@property (nonatomic, strong) YCPlayStateComponent *gesturePlayComponent;
// TODO: 声音、亮度控制条

#pragma mark - StatusBar
/** 视频状态控制栏 */
@property (nonatomic, strong) YCPopUpFloatComponent *statusBarComponent;
/** 播放按钮组件 */
@property (nonatomic, strong) YCPlayStateComponent *statusPlayComponent;
/** 视频时长label */
@property (nonatomic, strong) UILabel *videoDurationLabel;
/** 播放时长label */
@property (nonatomic, strong) UILabel *playDurationLabel;
/** 视频进度条 */
@property (nonatomic, strong) YCComponent *progressComponent;

#pragma mark - Header
/** header隐藏条 */
@property (nonatomic, strong) YCPopUpFloatComponent *headerComponent;
/** 视频标题 */
@property (nonatomic, strong) UILabel *videoTitleLabel;
/** 切换清晰度 */
@property (nonatomic, strong) UIButton *switchVideoQuaButton;
/** 分享 */
@property (nonatomic, strong) UIButton *shareButton;
/** 离线下载 */
@property (nonatomic, strong) UIButton *downloadButton;

@end

@implementation YCVideoPlayerView

- (id<YCStates>)viewModel {
    return [self getStates];
}

- (instancetype)init {
    if (self = [super init]) {
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)renderWithVarProps:(id<YCVideoPlayerVarProps>)varProps {
    // 视频播放器
    id playerComponent = toComponent([YCAVPlayerComponent class])
                            .props(^id<YCProps> (NSDictionary *constVars) {
                                return toProps(@protocol(YCAVPlayerProps))
                                        .states(self.viewModel)
                                        .nameMappingBlock(^NSString * (NSString *key) {
                                            // 基础播放器的Props是由父组件提供的，但以下4个关联属性要由VideoPlayer控制
                                            // 因此父组件提供的这4个属性，仅当做当前states的初始值使用
                                            // TODO: currVideoURL的切换，不能影响其他实例
                                            if (!([key isEqualToString:@"currVideoURL"]
                                                  || [key isEqualToString:@"isCancelPlay"]
                                                  || [key isEqualToString:@"isPause"]
                                                  || [key isEqualToString:@"seekTimePoint"])) {
                                                return toKeyPath(@"props", key);
                                            }
                                            return key;
                                        })
                                        .build();
                            })
                            .callbacks(self)
                            .superView(self)
                            .build();
    self.playerComponent = playerComponent;
    
    // 手势浮动层
    id gestureComponent = toComponent([YCGestureFloatComponet class])
                            .varsObj(varProps.gesture)
                            .props(^id<YCProps> (NSDictionary *constVars) {
                                return toProps(@protocol(YCGestureFloatProps))
                                        .states(self.viewModel)
                                        .nameMapping(@{@"pauseRespondGesture": @"isPauseRespondGesture"})
                                        .constVars(constVars)
                                        .build();
                            })
                            .callbacks(self)
                            .superView(self)
                            .build();
    self.gestureFloatComponent = gestureComponent;
    
    // 手势浮动层上的播放按钮
    id gesturePlayComponent = toComponent([YCPlayStateComponent class])
                                .varsObj(varProps.gesturePlay)
                                .props(^id<YCProps> (NSDictionary *constVars) {
                                    return toProps(@protocol(YCPlayStateProps))
                                            .states(self.viewModel)
                                            .nameMapping(@{@"isHidden": @"isHiddenForSwitchPlayerButton"})
                                            .constVars(constVars)
                                            .build();
                                })
                                .callbacks(self)
                                .superView(self.gestureFloatComponent.view)
                                .build();
    self.gesturePlayComponent = gesturePlayComponent;
    
    // TODO: resetAutoHidden
    // 视频状态控制栏
    id statusBarComponent = toComponent([YCPopUpFloatComponent class])
                            .varsProtocol(@protocol(YCPopUpFloatVars))
                            .constVars(^NSDictionary *(id<YCPopUpFloatVars> vars) {
                                vars.initShowState = self.viewModel.innerStatusBarChangeState;
                                return [vars toDictionary];
                            })
                            .varsObj(varProps.status)
                            .props(^id<YCProps> (NSDictionary *constVars) {
                                return toProps(@protocol(YCPopUpFloatProps))
                                        .states(self.viewModel)
                                        .nameMapping(@{
                                                       @"startInit": @"statusBarInitState",
                                                       @"changeState": @"statusBarChangeState"
                                                       })
                                        .constVars(constVars)
                                        .build();
                            })
                            .callbacks(self)
                            .superView(self)
                            .build();
    self.statusBarComponent = statusBarComponent;
    
    // 状态控制栏上的播放按钮
    id statusPlayComponent = toComponent([YCPlayStateComponent class])
                                .varsObj(varProps.statusPlay)
                                .props(^id<YCProps> (NSDictionary *constVars) {
                                    return toProps(@protocol(YCPlayStateProps))
                                    .states(self.viewModel)
                                    .constVars(constVars)
                                    .build();
                                })
                                .callbacks(self)
                                .superView(self.statusBarComponent.view)
                                .build();
    self.statusPlayComponent = statusPlayComponent;
    
    // 视频播放时长
    self.videoDurationLabel = [[UILabel alloc] init];
    self.videoDurationLabel.text = @"00:00";
    [self.statusBarComponent.view addSubview:self.videoDurationLabel];
    
    self.playDurationLabel = [[UILabel alloc] init];
    self.playDurationLabel.text = @"00:00";
    [self.statusBarComponent.view addSubview:self.playDurationLabel];
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

#pragma mark - YCPlayStateCallbacks

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
