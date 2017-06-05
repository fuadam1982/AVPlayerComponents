//
//  YCTeacherShowPlayerComponent.h
//  testModule
//
//  Created by fuhan on 2017/6/5.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - utils
#import "Componentable.h"

@protocol YCTeacherShowPlayerProps <YCProps>

/** 视频Id */
@property (nonatomic, strong, readonly) NSString *videoId;
/** 视频地址: 0-高清地址、1-低清地址 */
@property (nonatomic, strong, readonly) NSArray<NSString *> *videoURLs;
/** 视频标题 */
@property (nonatomic, strong, readonly) NSString *videoTitle;
/** TODO: 分享信息 */

@end

//////////////////////////////////////////////////////////////

@interface YCTeacherShowPlayerComponent : YCComponent

@end
