//
//  YCSwitchPlayerStateVM.h
//  testModule
//
//  Created by fuhan on 2017/6/6.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Componentable.h"
#import "YCSwitchPlayerStateComponent.h"

@interface YCSwitchPlayerStateVM : NSObject<YCStates>

@property (nonatomic, strong, readonly) id<YCSwitchPlayerStateProps> props;

/** 触发回调 */
- (void)onTap;

@end
