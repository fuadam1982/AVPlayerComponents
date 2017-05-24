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
    
    self.playerView = [[YCAVPlayerView alloc] initWithProps:[self.viewModel toProps] callbacks:self];
    self.playerView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.playerView];
    
    [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(@20);
        make.height.equalTo(@260);
    }];
}

#pragma mark - YCAVPlayerCallbacks

@end
