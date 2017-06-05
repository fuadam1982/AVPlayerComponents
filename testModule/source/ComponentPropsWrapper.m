//
//  ComponentPropsWrapper.m
//  testModule
//
//  Created by fuhan on 2017/5/16.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import "ComponentPropsWrapper.h"
#import "Tools.h"
#import "ReactiveCocoa.h"

@interface ComponentPropsWrapper () <ReadonlyObjDataSource>

/** states对象，一般为viewmodel */
@property (nonatomic, strong) id<YCStates> states;
/** keyPath映射，可以用来转为plain object */
@property (nonatomic, strong) NSString * (^nameMappingBlock)(NSString *key);
/** 不会改变的状态 */
@property (nonatomic, strong) NSDictionary *constVars;
/** props属性名-类型映射，用于ReadonlyObjWrapper */
@property (nonatomic, strong) NSDictionary *propTypesMapping;
/** state属性名-类型映射，避免valueForUndefinedKey */
@property (nonatomic, strong) NSDictionary *stateTypesMapping;

@end

@implementation ComponentPropsWrapper

- (instancetype)initWithPropsProtocol:(Protocol *)propsProtocol
                               states:(id<YCStates>)states
                          nameMapping:(NSDictionary *)nameMapping
                            constVars:(NSDictionary *)constVars {
    return [self initWithPropsProtocol:propsProtocol
                                states:states
                      nameMappingBlock:^(NSString * key) { return nameMapping[key]; }
                             constVars:constVars];
}

- (instancetype)initWithPropsProtocol:(Protocol *)propsProtocol
                               states:(id<YCStates>)states
                     nameMappingBlock:(NSString * (^)(NSString *))nameMappingBlock
                            constVars:(NSDictionary *)constVars {
    self = [super initWithDataSource:self];
    self.states = states;
    self.nameMappingBlock = nameMappingBlock;
    self.constVars = constVars;

    // 缓存prop协议的属性类型信息
    static NSMutableDictionary<NSString *, NSDictionary *> *propTypesMappingCache = nil;
    // 缓存state类型的属性类型信息
    static NSMutableDictionary<NSString *, NSDictionary *> *statePropTypesMappingCache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        propTypesMappingCache = [[NSMutableDictionary alloc] initWithCapacity:64];
        statePropTypesMappingCache = [[NSMutableDictionary alloc] initWithCapacity:64];
    });
    
    // 获取prop协议的属性类信息
    NSString *cacheKey = NSStringFromProtocol(propsProtocol);
    NSDictionary *propTypesMapping = propTypesMappingCache[cacheKey];
    if (!propTypesMapping) {
        @synchronized (propTypesMappingCache) {
            propTypesMapping = parseProtocolPropertiesInfo(propsProtocol, YES);
            propTypesMappingCache[cacheKey] = propTypesMapping;
        }
    }
    self.propTypesMapping = propTypesMapping;
    
    // 获取state类型的属性类型信息
    if (states) {
        cacheKey = NSStringFromClass([states class]);
        NSDictionary *stateTypesMapping = statePropTypesMappingCache[cacheKey];
        if (!stateTypesMapping) {
            @synchronized (statePropTypesMappingCache) {
                stateTypesMapping = parseClassPropertiesInfo([states class]);
                statePropTypesMappingCache[cacheKey] = stateTypesMapping;
            }
        }
        self.stateTypesMapping = stateTypesMapping;
    }
    
    [self dataBinding];
    
    return self;
}

/** 桥接KVO */
- (void)dataBinding {
    @weakify(self);
    // 记录已经绑定的字段名
    NSMutableSet *bindedProp = [[NSMutableSet alloc] initWithCapacity:self.propTypesMapping.count];
    
    if (self.states) {
        NSObject *obj = self.states;
        for (NSString *key in self.propTypesMapping.allKeys) {
            if ((self.constVars && self.constVars[key])
                || ([bindedProp containsObject:key])) {
                continue;
            }

            NSString *propName = key;
            if (self.nameMappingBlock) {
                NSString *mappedName = self.nameMappingBlock(key);
                if (mappedName) {
                    propName = mappedName;
                }
            }

            if (self.stateTypesMapping[propName]) {
                [[[obj rac_valuesForKeyPath:propName
                                   observer:obj]
                  takeUntil:obj.rac_willDeallocSignal]
                 subscribeNext:^(id x) {
                     @strongify(self);
                     [self setValue:x forKey:key];
                 }];
            }
        }
    }
}

#pragma mark - ReadonlyObjDataSource

- (id _Nullable)stateForKey:(NSString* _Nonnull)key {
    // 尝试从constVars读取
    id state = nil;
    if (self.constVars) {
        state = self.constVars[key];
    }
  
    if (!state && self.states) {
        NSObject *obj = self.states;
        NSString *propName = key;
        if (self.nameMappingBlock) {
            NSString *mappedName = self.nameMappingBlock(key);
            if (mappedName) {
                propName = mappedName;
            }
        }
        state = [obj valueForKeyPath:propName];
    }
    return state;
}

- (NSString* _Nonnull)propTypeForKey:(NSString* _Nonnull)key {
    return self.propTypesMapping[key];
}

@end
