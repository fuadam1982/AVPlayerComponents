//
//  PropsConstVarWrapper.m
//  testModule
//
//  Created by fuhan on 2017/6/7.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import "PropsConstVarWrapper.h"
#import "Tools.h"

@interface PropsConstVarWrapper () <AccessObjDataSource>

/** constVars包装协议 */
@property (nonatomic, strong) Protocol *varsProtocol;
/** 用于存储state数据 */
@property (nonatomic, strong) NSMutableDictionary *data;
/** props属性名-类型映射，用于ReadonlyObjWrapper */
@property (nonatomic, strong) NSDictionary *propTypesMapping;

@end

@implementation PropsConstVarWrapper

- (instancetype)initWithProtocol:(Protocol *)varsProtocol {
    if (self = [super initWithDataSource:self]) {
        self.data = [[NSMutableDictionary alloc] initWithCapacity:16];
        self.varsProtocol = varsProtocol;
        
        // 缓存prop协议的属性类型信息
        static NSMutableDictionary<NSString *, NSDictionary *> *propTypesMappingCache = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            propTypesMappingCache = [[NSMutableDictionary alloc] initWithCapacity:64];
        });
        
        // 获取prop协议的属性类信息
        NSString *cacheKey = NSStringFromProtocol(varsProtocol);
        NSDictionary *propTypesMapping = propTypesMappingCache[cacheKey];
        if (!propTypesMapping) {
            @synchronized (propTypesMappingCache) {
                propTypesMapping = parseProtocolPropertiesInfo(varsProtocol, NO);
                propTypesMappingCache[cacheKey] = propTypesMapping;
            }
        }
        self.propTypesMapping = propTypesMapping;
    }
    return self;
}

- (NSDictionary *)toDictionary {
    return self.data;
}

#pragma mark - ReadonlyObjDataSource

- (id _Nullable)stateForKey:(NSString* _Nonnull)key {
    return self.data[key];
}

- (void)setState:(id)state key:(NSString *)key {
    self.data[key] = state;
}

- (NSString* _Nonnull)propTypeForKey:(NSString* _Nonnull)key {
    return self.propTypesMapping[key];
}

@end
