//
//  StoreAction.h
//  testModule
//
//  Created by fuhan on 2017/5/17.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Componentable.h"

@interface StoreAction : NSObject

@property (nonatomic, strong, readonly) NSString *category;
@property (nonatomic, strong, readonly) NSString *type;
@property (nonatomic, strong, readonly) NSMutableDictionary *payload;

- (instancetype)initWithCategory:(NSString *)category
                            type:(NSString *)type
                         payload:(NSDictionary *)payload;

@end
