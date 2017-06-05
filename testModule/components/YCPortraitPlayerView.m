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

#pragma mark - viewmodel
#import "YCPortraitPlayerVM.h"

#pragma mark - utils
#import "Masonry.h"
#import "ComponentPropsBuilder.h"

@interface YCPortraitPlayerView () <YCAVPlayerCallbacks, YCGestureFloatCallbacks>

@property (nonatomic, strong) YCPortraitPlayerVM *viewModel;
// TODO: 共享实例
@property (nonatomic, strong) YCAVPlayerComponent *playerComponent;
@property (nonatomic, strong) YCGestureFloatComponet *gestureFloatComponent;

@end

@implementation YCPortraitPlayerView

- (id<YCStates>)viewModel {
    return [self getStates];
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
                                     @"useDoubleTap": @YES,
                                     })
                        .build();
    self.gestureFloatComponent = [[YCGestureFloatComponet alloc] initWithProps:gestureProps
                                                                     callbacks:self];
    [self.playerComponent.view addSubview:self.gestureFloatComponent.view];
    
    [self layout];
}

- (void)layout {
    [self.playerComponent.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.and.right.equalTo(self);
    }];
    [self.gestureFloatComponent.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.and.right.equalTo(self);
    }];
}

#pragma mark - YCAVPlayerCallbacks

#pragma mark - YCGestureFloatCallbacks

- (void)gesturerOnTap:(UIView *)gesturer {

}

- (void)gesturerOnDoubleTap:(UIView *)gesturer {
    [self.viewModel switchPlayerState];
}

@end
