//
//  ViewController.m
//  testModule
//
//  Created by fuhan on 2017/5/15.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import "ViewController.h"
#import "ViewModel.h"

@implementation YCMoviePlayerComponent2

- (instancetype)initWithProps:(id<YCProps>)props callbacks:(id<YCCallbacks>)callbacks {
    YCMoviePlayerVM2 *states = [[YCMoviePlayerVM2 alloc] initWithProps:props callbacks:callbacks];
    YCMoviePlayerVC2 *tempate = [[YCMoviePlayerVC2 alloc] initWithStates:states];
    if (self = [super initWithTemplate:tempate]) {

    }
    return self;
}

@end

//////////////////////////////////////////////////////////////////

@implementation YCMoviePlayerVC2

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    
}

@end
