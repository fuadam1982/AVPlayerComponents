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
/** 用于将Complex Object转为Plain Object */
@property (nonatomic, strong) ComplexObjectTransform transform;
/** 不会改变的状态 */
@property (nonatomic, strong) NSDictionary *constVars;
/** 属性名-类型映射，用于ReadonlyObjWrapper */
@property (nonatomic, strong) NSDictionary *propTypesMapping;

@end

@implementation ComponentPropsWrapper

- (instancetype)initWithPropsProtocol:(Protocol *)propsProtocol
                               states:(id<YCStates>)states
                            transform:(ComplexObjectTransform)transform
                            constVars:(NSDictionary *)constVars {
    self = [super initWithDataSource:self];
    self.states = states;
    self.transform = transform;
    self.constVars = constVars;

    static NSMutableDictionary<NSString *, NSDictionary *> *propTypesMappingCache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        propTypesMappingCache = [[NSMutableDictionary alloc] initWithCapacity:64];
    });
    
    // 获取属性类型映射信息
    NSString *cacheKey = NSStringFromProtocol(propsProtocol);
    NSDictionary *propTypesMapping = propTypesMappingCache[cacheKey];
    if (!propTypesMapping) {
        @synchronized (propTypesMappingCache) {
            propTypesMapping = parseProtocolPropertiesInfo(propsProtocol, YES);
            propTypesMappingCache[cacheKey] = propTypesMapping;
        }
    }
    self.propTypesMapping = propTypesMapping;
    [self dataBinding];
    
    return self;
}

/** 桥接KVO */
- (void)dataBinding {
    @weakify(self);
    // 记录已经绑定的字段名
    NSMutableSet *bindedProp = [[NSMutableSet alloc] initWithCapacity:self.propTypesMapping.count];
    
    if (self.transform) {
        for (NSString *key in self.propTypesMapping.allKeys) {
            if (self.constVars && self.constVars[key]) {
                continue;
            }
            RACTuple *coInfo = self.transform(key);
            if (coInfo) {
                [bindedProp addObject:key];
                NSObject *obj = coInfo.first;
                NSString *propName = coInfo.second ?: key;
                [[[obj rac_valuesForKeyPath:propName observer:obj]
                  takeUntil:obj.rac_willDeallocSignal]
                 subscribeNext:^(id x) {
                     @strongify(self);
                     [self setValue:x forKey:propName];
                }];
            }
        }
    }
    
    if (self.states) {
        NSObject *obj = self.states;
        for (NSString *key in self.propTypesMapping.allKeys) {
            if ((self.constVars && self.constVars[key])
                || ([bindedProp containsObject:key])) {
                continue;
            }
            NSLog(@"bind state prop: %@", key);
            [[[obj rac_valuesForKeyPath:key observer:obj]
              takeUntil:obj.rac_willDeallocSignal]
             subscribeNext:^(id x) {
                 @strongify(self);
                 [self setValue:x forKey:key];
             }];
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
    
    NSString *propName = nil;
    // 尝试从Complex Object读取
    if (!state && self.transform) {
        RACTuple *coInfo = self.transform(key);
        if (coInfo) {
            NSObject *obj = coInfo.first;
            propName = coInfo.second ?: key;
            state = [obj valueForKey:propName];
        }
    }
    
    // 尝试从states读取，判断propName泳衣防止出现undefinedKeyPath问题
    if (!state && !propName && self.states) {
        NSObject *obj = self.states;
        state = [obj valueForKey:key];
    }
    return state;
}

- (NSString* _Nonnull)propTypeForKey:(NSString* _Nonnull)key {
    return self.propTypesMapping[key];
}

@end
