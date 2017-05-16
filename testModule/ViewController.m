//
//  ViewController.m
//  testModule
//
//  Created by fuhan on 2017/5/15.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import "ViewController.h"
#import "ViewModel.h"

//////////////////////////////////////////////////////////////////

@interface YCMoviePlayerComponentVC ()

@property (nonatomic, strong) YCMoviePlayerComponentVM *viewModel;

@end

@implementation YCMoviePlayerComponentVC

- (instancetype)initWithProps:(id<YCMoviePlayerComponentVCProps>)props callbacks:(id<YCCallbacks>)callbacks {
    if (self = [super initWithProps:props callbacks:callbacks]) {
        self.viewModel = [YCMoviePlayerComponentVM new];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    
}

@end
