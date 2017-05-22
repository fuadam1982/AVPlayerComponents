//
//  YCSimpleMoviePlayerVM.m
//  testModule
//
//  Created by fuhan on 2017/5/19.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import "YCSimpleMoviePlayerVM.h"
#import "YCSimpleMoviePlayerComponent.h"

@interface YCSimpleMoviePlayerVM ()

@property (nonatomic, strong) id<YCSimpleMoviePlayerProps> props;
@property (nonatomic, weak) id<YCSimpleMoviePlayerCallbacks> callbacks;

@end

@implementation YCSimpleMoviePlayerVM

- (instancetype)initWithProps:(id<YCSimpleMoviePlayerProps>)props callbacks:(id<YCSimpleMoviePlayerCallbacks>)callbacks {
    if (self = [super init]) {
        self.props = props;
        self.callbacks = callbacks;
    }
    return self;
}

@end
