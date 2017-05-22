//
//  YCPlayerSkipBtnVM.m
//  testModule
//
//  Created by fuhan on 2017/5/19.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import "YCPlayerSkipBtnVM.h"
#import "ReactiveCocoa.h"
#import "YCPlayerSkipBtnVIew.h"

@interface YCPlayerSkipBtnVM ()

@property (nonatomic, strong) id<YCPlayerSkipBtnProps> props;
@property (nonatomic, strong) id<YCPlayerSkipBtnCallbacks> callbacks;
/** 提示用户多少秒后可以跳过 */
@property (nonatomic, assign) NSInteger skipSeconds;
/** 是否可以跳过 */
@property (nonatomic, assign) BOOL canSkip;

@end

@implementation YCPlayerSkipBtnVM

- (instancetype)initWithProps:(id<YCPlayerSkipBtnProps>)props callbacks:(id<YCPlayerSkipBtnCallbacks>)callbacks {
    if (self = [super init]) {
        self.props = props;
        self.callbacks = callbacks;
        self.skipSeconds = self.props.skipSeconds;
        [self dataBinding];
    }
    return self;
}

- (void)dataBinding {
    @weakify(self);
    [[RACObserve(self.props, isPlaying) ignore:@NO] subscribeNext:^(id x) {
        [[[RACSignal interval:1
                 onScheduler:[RACScheduler scheduler]]
          take:self.props.skipSeconds]
         subscribeNext:^(id x) {
             @strongify(self);
             self.skipSeconds -= 1;
        } completed:^{
            @strongify(self);
            self.canSkip = YES;
        }];
    }];
}

- (void)emitSkip {
    if ([self.callbacks respondsToSelector:@selector(onSkip)]) {
        [self.callbacks onSkip];
    }
}

@end
