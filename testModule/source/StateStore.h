//
//  StateStore.h
//  testModule
//
//  Created by fuhan on 2017/5/17.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Componentable.h"
#import "ReactiveCocoa.h"

/** 快捷方法 */
@class StateStore;
StateStore *store();

//////////////////////////////////////////////////////////////

@protocol YCStore <YCConstVars>

@end

@protocol YCMutableStore <YCVars>

@end

@class StoreAction;
@interface StateStore : NSObject

+ (instancetype)shared;
- (void)registStoreProtocol:(Protocol *)storeProtocol
       mutableStoreProtocol:(Protocol *)mutableStoreProtocol
                   category:(NSString *)category;
- (void)registInitStoreByCategory:(NSString *)category block:(RACSignal * (^)())block;
- (void)registReducerByCategory:(NSString *)category
                           type:(NSString *)type
                          block:(NSDictionary * (^)(id<YCMutableStore>, StoreAction *))block;
- (id<YCStore>)getStoreByCategory:(NSString *)category;
- (RACSignal * (^)(StoreAction *))dispatch;

@end
