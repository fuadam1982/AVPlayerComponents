//
//  YCPortraitPlayerVM.h
//  testModule
//
//  Created by fuhan on 2017/6/1.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Componentable.h"
#import "YCAVPlayerComponent.h"
#import "YCPortraitPlayerComponent.h"

@interface YCPortraitPlayerVM : NSObject<YCPortraitPlayerStates>

@property (nonatomic, strong, readonly) id<YCAVPlayerProps> props;
@property (nonatomic, weak, readonly) id<YCPortraitPlayerCallbacks> callbacks;

/** 切换播放器暂停/播放状态 */
- (void)switchPlayerState;

@end
