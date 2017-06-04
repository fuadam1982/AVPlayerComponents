//
//  YCPortraitPlayerView.h
//  testModule
//
//  Created by fuhan on 2017/6/1.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Componentable.h"
#import "YCAVPlayerComponent.h"

@interface YCPortraitPlayerComponent: YCComponent

- (instancetype)initWithProps:(id<YCAVPlayerProps>)props callbacks:(id<YCAVPlayerCallbacks>)callbacks;

@end
