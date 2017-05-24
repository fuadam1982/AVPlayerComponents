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
- (void)getVideoDuration:(NSTimeInterval)videoDuration;
- (void)videoReadyToPlay;

@end
