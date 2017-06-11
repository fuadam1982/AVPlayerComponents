//
//  YCLandscapePlayerComponent.h
//  testModule
//
//  Created by fuhan on 2017/6/5.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YCShowProtraitPlayerCallbacks <NSObject>

- (void)playerOnWillPortraitScreen:(UIView *)player;
- (void)playerOnDidPortraitScreen:(UIView *)player;

@end

@interface YCShowLandscapePlayerComponent : NSObject

@end
