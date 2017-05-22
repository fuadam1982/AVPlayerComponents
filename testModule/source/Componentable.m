//
//  Componentable.m
//  testModule
//
//  Created by fuhan on 2017/5/16.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import "Componentable.h"

@interface YCViewComponent ()

@property (nonatomic, strong) id<YCStates> states;
@property (nonatomic, strong) NSMutableArray<id<YCComponent>> *children;

@end

@implementation YCViewComponent

- (instancetype)initWithStates:(id<YCStates>)states {
    if (self = [super init]) {
        self.states = states;
        self.children = [[NSMutableArray alloc] initWithCapacity:32];
    }
    return self;
}

- (id<YCStates>)getStates {
    return self.states;
}

- (UIView *)getView {
    return self;
}

- (UIView *)addSubComponent:(id<YCComponent>)subComponent {
    [self.children addObject:subComponent];
    return [subComponent getView];
}

@end

//////////////////////////////////////////////////////////////

@interface YCViewControllerComponent ()

@property (nonatomic, strong) id<YCStates> states;
@property (nonatomic, strong) NSMutableArray<id<YCComponent>> *children;

@end

@implementation YCViewControllerComponent

- (instancetype)initWithStates:(id<YCStates>)states {
    if (self = [super init]) {
        self.states = states;
        self.children = [[NSMutableArray alloc] initWithCapacity:32];
    }
    return self;
}

- (id<YCStates>)getStates {
    return self.states;
}

- (UIView *)getView {
    return self.view;
}

- (UIView *)addSubComponent:(id<YCComponent>)subComponent {
    [self.children addObject:subComponent];
    return [subComponent getView];
}

@end
