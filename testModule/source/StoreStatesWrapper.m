//
//  StoreStatesWrapper.m
//  testModule
//
//  Created by fuhan on 2017/5/17.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import "StoreStatesWrapper.h"

@interface StoreStatesWrapper () <AccessObjDataSource>

@end

@implementation StoreStatesWrapper

- (id)stateForKey:(NSString *)key {
    return nil;
}

- (NSString *)propTypeForKey:(NSString *)key {
    return nil;
}

@end
