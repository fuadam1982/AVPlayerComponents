//
//  YCAVPlayerVM.m
//  testModule
//
//  Created by fuhan on 2017/5/22.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import "YCAVPlayerVM.h"
#import "YCAVPlayerView.h"

@interface YCAVPlayerVM () <YCAVPlayerStates>

@property (nonatomic, strong) id<YCAVPlayerProps> props;
@property (nonatomic, weak) id<YCAVPlayerCallbacks> callbacks;
/** 播放中出现错误 */
@property (nonatomic, strong) NSError *error;
/** 是否可以播放 */
@property (nonatomic, assign) BOOL canPlay;
/** 是否正在播放 */
@property (nonatomic, assign) BOOL isPlaying;
/** 是否卡顿即需要loading */
@property (nonatomic, assign) BOOL needLoading;
/** 当前加载网速 */
@property (nonatomic, assign) CGFloat loadSpeed;
/** 当前播放的时间点 */
@property (nonatomic, assign) NSInteger currTimePoint;

@end

@implementation YCAVPlayerVM

- (instancetype)initWithProps:(id<YCAVPlayerProps>)props callbacks:(id<YCAVPlayerCallbacks>)callbacks {
    if (self = [super init]) {
        self.props = props;
        self.callbacks = callbacks;
    }
    return self;
}

@end
