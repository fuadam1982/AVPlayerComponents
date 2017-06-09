//
//  ViewController.m
//  testModule
//
//  Created by fuhan on 2017/5/15.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import "ViewController.h"

#pragma mark - component
#import "YCAVPlayerComponent.h"
#import "YCPortraitPlayerComponent.h"
#import "YCPopUpFloatComponent.h"

#pragma mark - viewmodel
#import "ViewModel.h"

#pragma mark - utils
#import "Masonry.h"

@interface YCMoviePlayerVC2 () <YCAVPlayerCallbacks>

@property (nonatomic, strong) YCMoviePlayerVM2 *viewModel;
// TODO: remove
@property (nonatomic, strong) YCVideoPlayerComponent *portraitPlayerComponent;

@end

@implementation YCMoviePlayerVC2

- (instancetype)init {
    if (self = [super init]) {
        self.viewModel = [[YCMoviePlayerVM2 alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    
    // TODO: ShowPortraitPlayer wrapper
    id playerComponent = toComponent([YCVideoPlayerComponent class])
                            .childrenVarProps(^(id<YCVideoPlayerVarProps> varProps) {
                                varProps.gesture.useTap = YES;
                                varProps.gesture.useDoubleTap = YES;
                                varProps.gesture.initGestureType = YCGestureFloatTypeTap;
                                
                                varProps.status.direction = YCPopUpFloatDirectionTypeUp;
                                varProps.status.animationDuration = 0.2;
                                varProps.status.autoHiddenDuration = 5;
                            })
                            .states([self.viewModel toProps])
                            .callbacks(self)
                            .superView(self.view)
                            .build();
    self.portraitPlayerComponent = playerComponent;
    self.portraitPlayerComponent.view.backgroundColor = [UIColor blackColor];
    
    [self.portraitPlayerComponent layoutChildrenUI:^(id<YCVideoPlayerLayout> layout, UIView *parent) {
        // 视频播放器
        [layout.playerComponent.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.and.right.equalTo(parent);
        }];
        
        // 手势浮动层
        [layout.gestureFloatComponent.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.and.right.equalTo(parent);
        }];
        
        // 手势浮动层上的播放按钮
        [layout.gesturePlayComponent.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(parent).offset(102.5);
            make.right.equalTo(parent).offset(-20);
            make.width.and.height.equalTo(@50);
        }];
        layout.gesturePlayComponent.view.backgroundColor = [UIColor blueColor];
        
        // 状态控制栏
        [layout.statusBarComponent.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(parent);
            make.height.equalTo(@61);
        }];
        
        // 状态栏上的播放按钮
        [layout.statusPlayComponent.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@22);
            make.size.equalTo([NSValue valueWithCGSize:CGSizeMake(12, 14)]);
            make.centerY.equalTo(layout.statusBarComponent.view);
        }];
        layout.statusPlayComponent.view.backgroundColor = [UIColor blueColor];
        
        // 状态栏上的视频播放时间
        [layout.videoDurationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(layout.statusBarComponent.view).offset(-50);
            make.centerY.equalTo(layout.statusBarComponent.view);
        }];
        [layout.playDurationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(layout.statusPlayComponent.view.mas_right).offset(16);
            make.centerY.equalTo(layout.statusBarComponent.view);
        }];
    }];
    
    [self.portraitPlayerComponent.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(@0);
        make.height.equalTo(@(210.5 * [UIScreen mainScreen].bounds.size.height / 667));
//        make.top.and.bottom.equalTo(self.view);
    }];
    
    
    // test 横屏
//    CGAffineTransform transform = CGAffineTransformIdentity;
//    transform                   = CGAffineTransformRotate(transform, M_PI/2);// 弧度， 逆时针旋转
//    self.view.transform         = transform;
}

#pragma mark - YCAVPlayerCallbacks

- (void)player:(UIView *)player onLoadedDurations:(NSDictionary<NSNumber *,NSNumber *> *)loadedDurations {
    NSLog(@">>> loaded: %@", loadedDurations);
}

- (void)player:(UIView *)player onLagged:(BOOL)isLagging loadSpeed:(CGFloat)loadSpeed {
    NSLog(@">>> isLagged: %d, loadSpeed:%0.2f ...", isLagging, loadSpeed);
}

- (void)player:(UIView *)player onPlayingCurrTime:(NSTimeInterval)currTime isPause:(BOOL)isPause {
    NSLog(@">>> currTime: %0.2f, isPause: %d", currTime, isPause);
}

- (void)player:(UIView *)player onFinishedByInterrupt:(BOOL)isInterrupt watchedDuration:(NSTimeInterval)watchedDuration stayDuration:(NSTimeInterval)stayDuration {
    NSLog(@">>> interrupt: %d, watch: %0.2f, stay: %0.2f", isInterrupt, watchedDuration, stayDuration);
}

@end
