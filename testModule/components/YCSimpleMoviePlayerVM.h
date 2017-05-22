//
//  YCSimpleMoviePlayerVM.h
//  testModule
//
//  Created by fuhan on 2017/5/19.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Componentable.h"

@protocol YCSimpleMoviePlayerProps;
@interface YCSimpleMoviePlayerVM : NSObject<YCStates>

@property (nonatomic, strong, readonly) id<YCSimpleMoviePlayerProps> props;

@end
