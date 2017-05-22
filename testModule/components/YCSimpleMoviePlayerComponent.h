//
//  YCSimpleMoviePlayerComponent.h
//  testModule
//
//  Created by fuhan on 2017/5/19.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Componentable.h"

@protocol YCSimpleMoviePlayerProps <NSObject>

@property (nonatomic, strong, readonly) NSString *movieURL;

@end

@protocol YCSimpleMoviePlayerCallbacks <NSObject>

- (void)onFinished:(BOOL)isSkiped;

@end

/*!
 *  简单视频播放组件
 *  组件结构:
 *  YCAVPlayerComponent
 *      YCPlayerSkipBtnComponent
 */
@interface YCSimpleMoviePlayerComponent : YCComponent

@end
