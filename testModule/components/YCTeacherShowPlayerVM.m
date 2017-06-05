//
//  YCTeacherShowPlayerVM.m
//  testModule
//
//  Created by fuhan on 2017/6/5.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import "YCTeacherShowPlayerVM.h"
#import "YCTeacherShowPlayerComponent.h"

@interface YCTeacherShowPlayerVM ()

@property (nonatomic, strong) id<YCTeacherShowPlayerProps> props;

@end

@implementation YCTeacherShowPlayerVM

- (instancetype)initWithProps:(id<YCTeacherShowPlayerProps>)props callbacks:(id<YCCallbacks>)callbacks {
    if (self = [super init]) {
        self.props = props;
    }
    return self;
}

@end
