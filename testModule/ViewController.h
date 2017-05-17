//
//  ViewController.h
//  testModule
//
//  Created by fuhan on 2017/5/15.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Componentable.h"

@protocol YCMoviePlayerComponentVCProps <NSObject, YCProps>

@property (nonatomic, strong, readonly) NSString *startVideoURL;
@property (nonatomic, strong, readonly) NSString *stopVideoURL;
@property (nonatomic, strong, readonly) NSString *videoURL;
@property (nonatomic, assign) BOOL notFlag;
@property (nonatomic, strong, readonly) NSString *name;

@end

@interface YCMoviePlayerComponentVC : YCComponentViewController

- (instancetype)initWithProps:(id<YCMoviePlayerComponentVCProps>)props callbacks:(id<YCCallbacks>)callbacks;

@end

