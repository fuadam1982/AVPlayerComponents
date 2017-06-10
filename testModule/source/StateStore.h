//
//  StateStore.h
//  testModule
//
//  Created by fuhan on 2017/5/17.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "StoreAction.h"
#import "ReactiveCocoa.h"

/** 快捷方法 */
@class StateStore;
StateStore *store();

@interface StateStore : NSObject

+ (instancetype)shared;
- (RACSignal * (^)(StoreAction *))dispatch;

@end
