//
//  ViewModel.h
//  testModule
//
//  Created by fuhan on 2017/5/16.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Componentable.h"

@protocol YCAVPlayerProps;
@class ComponentPropsWrapper;
@interface YCMoviePlayerVM2 : NSObject

@property (nonatomic, strong, readonly, getter=toProps) id<YCAVPlayerProps> subComponentProps;

@end
