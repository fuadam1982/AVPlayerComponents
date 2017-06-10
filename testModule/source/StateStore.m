//
//  StateStore.m
//  testModule
//
//  Created by fuhan on 2017/5/17.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import "StateStore.h"
#import "ComponentPropsBuilder.h"
#import "PropsConstVarWrapper.h"

StateStore *store() {
    return [StateStore shared];
}

@interface StateStore ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, NSDictionary<NSString *, NSObject *> *> *stores;

@end

@implementation StateStore

+ (instancetype)shared {
    static StateStore *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[StateStore alloc] init];
    });
    return instance;
}

- (RACSignal * (^)(StoreAction *))dispatch {
    return ^RACSignal * (StoreAction *action) {
        return nil;
    };
}

@end
