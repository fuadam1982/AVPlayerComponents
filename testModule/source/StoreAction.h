//
//  StoreAction.h
//  testModule
//
//  Created by fuhan on 2017/5/17.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Componentable.h"

/** 快速访问 */
@class StoreAction;
StoreAction * toAction(NSString *category, NSString *type, Protocol *payloadProtocol);

//////////////////////////////////////////////////////////////

typedef void (^AccessPayloadFn)(id<YCVars>);

@interface StoreAction : NSObject

@property (nonatomic, strong, readonly) NSString *category;
@property (nonatomic, strong, readonly) NSString *type;

- (instancetype)initWithCategory:(NSString *)category
                            type:(NSString *)type
                         payload:(Protocol *)payloadProtocol;
- (void (^)(AccessPayloadFn))payload;

@end
