//
//  StoreAction.m
//  testModule
//
//  Created by fuhan on 2017/5/17.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import "StoreAction.h"
#import "PropsConstVarWrapper.h"

StoreAction * toAction(NSString *category, NSString *type, Protocol *payloadProtocol) {
    return [[StoreAction alloc] initWithCategory:category
                                            type:type
                                         payload:payloadProtocol];
}

@interface StoreAction ()

@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) id<YCVars> pPayload;

@end

@implementation StoreAction

- (instancetype)initWithCategory:(NSString *)category
                            type:(NSString *)type
                         payload:(Protocol *)payloadProtocol {
    if (self = [super init]) {
        self.category = category;
        self.type = type;
        self.pPayload = [[PropsConstVarWrapper alloc] initWithProtocol:payloadProtocol];
    }
    return self;
}

- (void (^)(AccessPayloadFn))payload {
    return ^void (AccessPayloadFn block) {
        block(self.pPayload);
    };
}

@end
