//
//  ViewModel.m
//  testModule
//
//  Created by fuhan on 2017/5/16.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import "ViewModel.h"
#import "Componentable.h"
#import "ComponentPropsBuilder.h"
#import "YCAVPlayerView.h"

@interface YCMoviePlayerVM2 () <YCStates>

/** 视频播放地址，如果发生变化即切换清晰度 */
@property (nonatomic, strong) NSString *videoURL;
/** 是否暂停，默认加载好立即播放 */
@property (nonatomic, assign) BOOL isPause;
/** 从指定时间点开始播放，默认值为-1 */
@property (nonatomic, assign) NSInteger seekTimePoint;

@end

@implementation YCMoviePlayerVM2

- (void)dealloc {
    NSLog(@"");
}

- (instancetype)init {
    if (self = [super init]) {
        self.isPause = NO;
        self.videoURL = @"https://o558dvxry.qnssl.com/mobileM/mobileM_586d9599065b7e9d7142953e.m3u8";
    }
    return self;
}

- (id<YCProps>)toProps {
    return toProps(@protocol(YCAVPlayerProps))
    .states(self)
    .constVars(@{
                 @"isWANNetworkingStopPreload": @YES,
                 @"minPlayTime": @5,
                 @"interactionTimes": @[]
                 })
    .build();
}

@end
