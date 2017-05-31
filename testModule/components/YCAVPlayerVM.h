//
//  YCAVPlayerVM.h
//  testModule
//
//  Created by fuhan on 2017/5/22.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Componentable.h"
#import "YCAVPlayerView.h"

@class YCAVPlayerView;
@interface YCAVPlayerVM : NSObject<YCAVPlayerStates>

@property (nonatomic, strong, readonly) id<YCAVPlayerProps> props;

- (void)setPlayer:(YCAVPlayerView *)player;
- (void)setPlayerError:(NSError *)error;
- (void)setCachedVideoFolder:(NSString *)cachedVideoFolder;
- (void)setVideoDuration:(NSTimeInterval)videoDuration;
- (void)setVideoCurrTimePoint:(NSTimeInterval)currTimePoint;
- (void)seekToTime:(NSTimeInterval)timePoint;

- (void)videoReadyToPlay;
- (void)videoPlayFinishedByInterrupt:(BOOL)interrupt;

@end
