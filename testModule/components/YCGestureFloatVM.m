//
//  YCGestureFloatVM.m
//  testModule
//
//  Created by fuhan on 2017/6/2.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import "YCGestureFloatVM.h"
#import "YCGestureFloatView.h"

@interface YCGestureFloatVM ()

@property (nonatomic, strong) id<YCGestureFloatProps> props;
@property (nonatomic, weak) id<YCGestureFloatCallbacks> callbacks;

@end

@implementation YCGestureFloatVM

- (instancetype)initWithProps:(id<YCGestureFloatProps>)props callbacks:(id<YCGestureFloatCallbacks>)callbacks {
    if (self = [super init]) {
        self.props = props;
        self.callbacks = callbacks;
    }
    return self;
}

@end
