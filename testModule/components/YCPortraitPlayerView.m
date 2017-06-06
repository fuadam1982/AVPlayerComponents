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
                                    YCSwitchPlayerStateCallbacks>

@property (nonatomic, strong) YCPortraitPlayerVM *viewModel;
// TODO: 共享实例
/** 基础播放器组件 */
@property (nonatomic, strong) YCAVPlayerComponent *playerComponent;
/** 手势浮动层组件 */
@property (nonatomic, strong) YCGestureFloatComponet *gestureFloatComponent;
/** 切换播放状态按钮组件 */
@property (nonatomic, strong) YCSwitchPlayerStateComponent *switchStateComponent;
/** 视频状态控制条 */
@property (nonatomic, strong) YCPopUpFloatComponent *statusBarComponent;

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
                        .constVars(@{
                                     @"useTap": @YES,
                                     @"useDoubleTap": @YES
                                     })
                        .build();
    self.gestureFloatComponent = [[YCGestureFloatComponet alloc] initWithProps:gestureProps
                                                                     callbacks:self];
    [self addSubview:self.gestureFloatComponent.view];
    
    // 播放按钮，在手势浮动层上
    id switchStateProps = toProps(@protocol(YCSwitchPlayerStateProps))
                            .states(self.viewModel)
                            .nameMapping(@{@"isHidden": @"isHiddenForSwitchPlayerButton"})
                            .build();
    self.switchStateComponent = [[YCSwitchPlayerStateComponent alloc] initWithProps:switchStateProps
                                                                          callbacks:self];
    [self.gestureFloatComponent.view addSubview:self.switchStateComponent.view];
    
    // 视频状态控制条
    id popUpProps = toProps(@protocol(YCPopUpFloatProps))
                        .states(self.viewModel)
                        .nameMapping(@{
                                       @"startInit": @"statusBarInitState",
                                       @"changeState": @"statusBarChangeState"
                                       })
                        .constVars(@{
                                     @"direction": @(YCPopUpFloatDirectionTypeUp),
                                     // TODO: check
                                     @"animationDuration": @(0.3),
                                     @"autoHiddenDuration": @5,
                                     @"initShowState": @YES
                                     })
                        .build();
    self.statusBarComponent = [[YCPopUpFloatComponent alloc] initWithProps:popUpProps callbacks:nil];
    [self addSubview:self.statusBarComponent.view];
    
    [self layout];
}

- (void)layout {
    [self.playerComponent.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.and.right.equalTo(self);
    }];
    
    [self.gestureFloatComponent.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.and.right.equalTo(self);
    }];
    
    [self.switchStateComponent.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(102.5);
        make.right.equalTo(self).offset(-20);
        make.width.and.height.equalTo(@50);
    }];
    self.switchStateComponent.view.backgroundColor = [UIColor blueColor];
    
    [self.statusBarComponent.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.width.equalTo(self);
        make.height.equalTo(@61);
    }];
    [self.viewModel initStatusBarState];
    self.statusBarComponent.view.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
}

#pragma mark - YCAVPlayerCallbacks

- (void)player:(UIView *)player onPlayingCurrTime:(NSTimeInterval)currTime isPause:(BOOL)isPause {

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

@end
