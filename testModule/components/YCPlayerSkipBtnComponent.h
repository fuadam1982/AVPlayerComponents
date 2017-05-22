//
//  YCPlayerSkipBtnComponent.h
//  testModule
//
//  Created by fuhan on 2017/5/19.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Componentable.h"

@protocol YCPlayerSkipBtnProps <NSObject>

/** 是否开始播放 */
@property (nonatomic, assign, readonly) BOOL isPlaying;
/** 开始播放多少秒后可以跳过 */
@property (nonatomic, assign, readonly) NSInteger skipSeconds;

@end

@protocol YCPlayerSkipBtnCallbacks <NSObject>

- (void)onSkip;

@end

/*!
 *  播放器跳过按钮组件
 */
@interface YCPlayerSkipBtnComponent : YCComponent

@end
