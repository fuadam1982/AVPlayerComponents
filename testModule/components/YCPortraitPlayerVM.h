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

@interface YCPortraitPlayerVM : NSObject<YCStates>

@property (nonatomic, strong, readonly) id<YCAVPlayerProps> props;
@property (nonatomic, weak, readonly) id<YCAVPlayerCallbacks> callbacks;

@end
