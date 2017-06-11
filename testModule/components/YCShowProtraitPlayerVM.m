//
//  YCShowProtraitPlayerVM.m
//  testModule
//
//  Created by lucifer on 11/06/2017.
//  Copyright © 2017 fuhan. All rights reserved.
//

#import "YCShowProtraitPlayerVM.h"

@interface YCShowProtraitPlayerVM ()

#pragma mark - states
@property (nonatomic, strong) id<YCVideoPlayerProps> props;
@property (nonatomic, assign) id<YCVideoPlayerCallbacks> callbacks;

@end

@implementation YCShowProtraitPlayerVM

- (instancetype)initWithProps:(id<YCVideoPlayerProps>)props callbacks:(id<YCVideoPlayerCallbacks>)callbacks {
    if (self = [super init]) {
        self.props = props;
        self.callbacks = callbacks;
    }
    return self;
}

@end
