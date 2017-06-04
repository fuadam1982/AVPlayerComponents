//
//  YCSimpleMoviePlayerView.h
//  testModule
//
//  Created by fuhan on 2017/5/19.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Componentable.h"

@protocol YCSimpleMoviePlayerProps <NSObject>

@property (nonatomic, strong, readonly) NSString *movieURL;

@end

@protocol YCSimpleMoviePlayerCallbacks <NSObject>

- (void)onFinished:(BOOL)isSkiped;

@end

/*!
 *  简单视频播放组件
 */
@interface YCSimpleMoviePlayerView : UIView

@end
