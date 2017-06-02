//
//  ViewController.m
//  testModule
//
//  Created by fuhan on 2017/5/15.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import "ViewController.h"
#import "ViewModel.h"

#pragma mark - views
#import "YCAVPlayerView.h"

#pragma mark - utils
#import "Masonry.h"

@interface YCMoviePlayerVC2 () <YCAVPlayerCallbacks>

@property (nonatomic, strong) YCMoviePlayerVM2 *viewModel;
@property (nonatomic, strong) YCAVPlayerView *playerView;

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
    self.playerView = [[YCAVPlayerView alloc] initWithProps:[self.viewModel toProps]
                                                  callbacks:self];
    self.playerView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.playerView];
    
    [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(@0);
        make.height.equalTo(@(180 * [UIScreen mainScreen].bounds.size.height / 568));
//        make.top.and.bottom.equalTo(self.view);
    }];
    
//    CGAffineTransform transform = CGAffineTransformIdentity;
//    transform                   = CGAffineTransformRotate(transform, M_PI/2);// 弧度， 逆时针旋转
//    self.view.transform         = transform;
}

#pragma mark - YCAVPlayerCallbacks

//- (void)playerOnReadyToPlay:(YCAVPlayerView *)player {
//    NSLog(@">>> readyToPlay ...");
//}

- (void)player:(YCViewComponent *)player onLoadedDurations:(NSDictionary<NSNumber *,NSNumber *> *)loadedDurations {
    NSLog(@">>> loaded: %@", loadedDurations);
}

// TODO: ignore isLagged = NO
- (void)player:(YCViewComponent *)player onLagged:(BOOL)isLagging loadSpeed:(CGFloat)loadSpeed {
    NSLog(@">>> isLagged: %d, loadSpeed:%0.2f ...", isLagging, loadSpeed);
}

- (void)player:(YCViewComponent *)player onPlayingCurrTime:(NSTimeInterval)currTime isPause:(BOOL)isPause {
    NSLog(@">>> currTime: %0.2f, isPause: %d", currTime, isPause);
}

- (void)player:(YCViewComponent *)player onFinishedByInterrupt:(BOOL)isInterrupt watchedDuration:(NSTimeInterval)watchedDuration stayDuration:(NSTimeInterval)stayDuration {
    NSLog(@">>> interrupt: %d, watch: %0.2f, stay: %0.2f", isInterrupt, watchedDuration, stayDuration);
}

@end
