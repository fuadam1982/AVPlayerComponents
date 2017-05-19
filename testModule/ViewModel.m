//
//  ViewModel.m
//  testModule
//
//  Created by fuhan on 2017/5/16.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import "ViewModel.h"

@interface YCMoviePlayerVM ()

@property (nonatomic, strong) id<YCProps> props;
@property (nonatomic, strong) id<YCCallbacks> callbacks;
@property (nonatomic, assign) CGFloat currTimePoint;

@end

@implementation YCMoviePlayerVM

- (instancetype)initWithProps:(id<YCProps>)props callbacks:(id<YCCallbacks>)callbacks {
    if (self = [super init]) {
        
    }
    return self;
}

@end
