//
//  YCShowProtraitPlayerComponent.h
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
// TODO: 文件名

@protocol YCShowProtraitPlayerCallbacks <YCVideoPlayerCallbacks>

- (void)playerOnWillFullScreen:(UIView *)player;
- (void)playerOnDidFullScreen:(UIView *)player;

@end

//////////////////////////////////////////////////////////////

@interface YCShowProtraitPlayerComponent : YCComponent

@end
