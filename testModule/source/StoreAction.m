//
//  StoreAction.m
//  testModule
//
//  Created by fuhan on 2017/5/17.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import "StoreAction.h"
#import "PropsConstVarWrapper.h"

@interface StoreAction ()

@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSMutableDictionary *payload;

@end

@implementation StoreAction

- (instancetype)initWithCategory:(NSString *)category
                            type:(NSString *)type
                         payload:(NSDictionary *)payload {
    if (self = [super init]) {
        self.category = category;
        self.type = type;
        self.payload = [payload mutableCopy];
    }
    return self;
}

@end
