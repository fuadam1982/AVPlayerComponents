//
//  YCGestureFloatVM.h
//  testModule
//
//  Created by fuhan on 2017/6/2.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Componentable.h"

@protocol YCGestureFloatProps, YCGestureFloatCallbacks;
@interface YCGestureFloatVM : NSObject<YCStates>

@property (nonatomic, strong, readonly) id<YCGestureFloatProps> props;

- (instancetype)initWithProps:(id<YCGestureFloatProps>)props callbacks:(id<YCGestureFloatCallbacks>)callbacks;

@end
