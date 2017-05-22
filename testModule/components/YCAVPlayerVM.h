//
//  YCAVPlayerVM.h
//  testModule
//
//  Created by fuhan on 2017/5/22.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Componentable.h"

@protocol YCAVPlayerProps;
@interface YCAVPlayerVM : NSObject<YCStates>

@property (nonatomic, strong, readonly) id<YCAVPlayerProps> props;

@end
