//
//  Componentable.m
//  testModule
//
//  Created by fuhan on 2017/5/16.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import "Componentable.h"

@interface YCComponent ()

@property (nonatomic, strong) id<YCTemplate> template;

@end

@implementation YCComponent

- (instancetype)initWithTemplate:(id<YCTemplate>)template {
    if (self = [super init]) {
        self.template = template;
    }
    return self;
}

- (void)addToParent:(YCComponent *)parent {
    [[[parent getTemplate] getView] addSubview:[self.template getView]];
}

- (void)addToContainer:(UIViewController *)container {
    [container.view addSubview:[self.template getView]];
}

- (id<YCTemplate>)getTemplate {
    return self.template;
}

- (id<YCStates>)getStates {
    return [self.template getStates];
}

@end

//////////////////////////////////////////////////////////////////

@interface YCTemplateView ()

@property (nonatomic, strong) id<YCStates> states;

@end

@implementation YCTemplateView

- (instancetype)init {
    return nil;
}

- (instancetype)initWithStates:(id<YCStates>)states {
    if (self = [super init]) {
        self.states = states;
    }
    return self;
}

- (UIView *)getView {
    return self;
}

- (id<YCStates>)getStates {
    return self.states;
}

@end

//////////////////////////////////////////////////////////////////

@interface YCTemplateViewController ()

@property (nonatomic, strong) id<YCStates> states;

@end

@implementation YCTemplateViewController

- (instancetype)init {
    return nil;
}

- (instancetype)initWithStates:(id<YCStates>)states {
    if (self = [super init]) {
        self.states = states;
    }
    return self;
}

- (UIView *)getView {
    return self.view;
}

- (id<YCStates>)getStates {
    return self.states;
}

@end
