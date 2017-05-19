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
#import "AdapterComponentStatesWrapper.h"

@interface ComponentPropsWrapper () <ReadonlyObjDataSource>

/** states对象，一般为viewmodel */
@property (nonatomic, strong) id<YCStates> states;
/** keyPath映射，可以用来转为plain object */
@property (nonatomic, strong) NSDictionary *nameMapping;
/** 不会改变的状态 */
@property (nonatomic, strong) NSDictionary *constVars;
/** 属性名-类型映射，用于ReadonlyObjWrapper */
@property (nonatomic, strong) NSDictionary *propTypesMapping;

@end

@implementation ComponentPropsWrapper

- (instancetype)initWithPropsProtocol:(Protocol *)propsProtocol
                               states:(id<YCStates>)states
                          nameMapping:(NSDictionary *)nameMapping
                            constVars:(NSDictionary *)constVars {
    self = [super initWithDataSource:self];
    self.states = states;
    self.nameMapping = nameMapping;
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
    
    if (self.states) {
        NSObject *obj = self.states;
        for (NSString *key in self.propTypesMapping.allKeys) {
            if ((self.constVars && self.constVars[key])
                || ([bindedProp containsObject:key])) {
                continue;
            }

            NSString *propName = key;
            if (self.nameMapping && self.nameMapping[key]) {
                propName = self.nameMapping[key];
            }
            
            // 处理AdapterComponentStatesWrapper KVO
            if ([obj isMemberOfClass:[AdapterComponentStatesWrapper class]]) {
                [((AdapterComponentStatesWrapper *)obj) dataBindingWithKeyPath:propName];
            }
            
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
        if (self.nameMapping && self.nameMapping[key]) {
            propName = self.nameMapping[key];
        }
        state = [obj valueForKeyPath:propName];
    }
    return state;
}

- (NSString* _Nonnull)propTypeForKey:(NSString* _Nonnull)key {
    return self.propTypesMapping[key];
}

@end
