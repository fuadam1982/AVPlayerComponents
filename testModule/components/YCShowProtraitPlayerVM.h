//
//  YCShowProtraitPlayerVM.h
//  testModule
//
//  Created by lucifer on 11/06/2017.
//  Copyright © 2017 fuhan. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - components
#import "YCPortraitPlayerComponent.h"

#pragma mark - utils
#import "Componentable.h"

@interface YCShowProtraitPlayerVM : NSObject<YCStates>

#pragma mark - states
@property (nonatomic, strong, readonly) id<YCVideoPlayerProps> props;
@property (nonatomic, assign, readonly) id<YCVideoPlayerCallbacks> callbacks;

@end
