//
//  AdapterComponent.m
//  testModule
//
//  Created by fuhan on 2017/5/18.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import "AdapterComponent.h"
#import "AdapterComponentStatesWrapper.h"

@interface YCAdapterComponent ()

@property (nonatomic, weak) id<YCComponent> origin;
@property (nonatomic, strong) AdapterComponentStatesWrapper *statesWrapper;

@end

@implementation YCAdapterComponent

- (instancetype)initWithProps:(id<YCStates>)states origin:(id<YCComponent>)origin {
    if (self = [super init]) {
        self.origin = origin;
        self.statesWrapper = [[AdapterComponentStatesWrapper alloc] initWithProps:(id<YCProps>)states callbacks:nil];
    }
    return self;
}

- (UIView *)getView {
    return [self.origin getView];
}

- (void)addSubComponentUseBlock:(id<YCComponent> (^)(AdapterComponentStatesWrapper *states, id<YCCallbacks>callbacks))block {
    id<YCComponent> subComponent = block(self.statesWrapper, (id<YCCallbacks>)self);
    [super addSubComponent:subComponent];
}

@end
