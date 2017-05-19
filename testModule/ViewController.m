//
//  ViewController.m
//  testModule
//
//  Created by fuhan on 2017/5/15.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import "ViewController.h"
#import "ViewModel.h"

@implementation YCMoviePlayerComponent

- (instancetype)initWithProps:(id<YCProps>)props callbacks:(id<YCCallbacks>)callbacks {
    YCMoviePlayerVM *states = [[YCMoviePlayerVM alloc] initWithProps:props callbacks:callbacks];
    YCMoviePlayerVC *tempate = [[YCMoviePlayerVC alloc] initWithStates:states];
    if (self = [super initWithTemplate:tempate]) {

    }
    return self;
}

@end

//////////////////////////////////////////////////////////////////

@implementation YCMoviePlayerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    
}

@end
