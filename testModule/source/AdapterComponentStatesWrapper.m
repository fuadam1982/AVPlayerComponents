//
//  AdapterComponentStatesWrapper.m
//  testModule
//
//  Created by fuhan on 2017/5/18.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import "AdapterComponentStatesWrapper.h"
#import "Tools.h"
#import "ReactiveCocoa.h"

@interface AdapterComponentStatesWrapper () <ReadonlyObjDataSource>

/** 原始Component的states对象 */
@property (nonatomic, strong) id<YCProps> props;
/** 属性名|类型映射，用于ReadonlyObjWrapper */
@property (nonatomic, strong) NSDictionary *propTypesMapping;

@end

@implementation AdapterComponentStatesWrapper

- (instancetype)initWithProps:(id<YCProps>)props callbacks:(id<YCCallbacks>)callbacks {
    self = [super initWithDataSource:self];
    self.props = props;
    
    static NSMutableDictionary<NSString *, NSDictionary *> *propTypesMappingCache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        propTypesMappingCache = [[NSMutableDictionary alloc] initWithCapacity:64];
    });
    
    // 获取属性类型映射信息
    Class class = [props class];
    NSString *cacheKey = NSStringFromClass(class);
    NSDictionary *propTypesMapping = propTypesMappingCache[cacheKey];
    if (!propTypesMapping) {
        @synchronized (propTypesMappingCache) {
            propTypesMapping = parseClassPropertiesInfo(class);
            propTypesMappingCache[cacheKey] = propTypesMapping;
        }
    }
    self.propTypesMapping = propTypesMapping;

    return self;
}

- (void)updateState:(id)state keyPath:(NSString *)keyPath {
    NSObject *props = self.props;
    [props setValue:state forKeyPath:keyPath];
}

- (void)dataBindingWithKeyPath:(NSString *)keyPath {
    @weakify(self);
    
    // 不处理多级路径
    // 对于多级路径，例boo.coo.doo.name.系统会进行如下处理：
    // 1. 访问"boo", 此时触发stateForKey
    // 2. 获取boo实例后，反复执行获取到doo实例。该过程已经脱离了当前对象，所以是正常执行
    // 3. 系统对doo.name进行KVO
    // 4. 因此不需要在当前类中进行处理
    if ([keyPath containsString:@"."]) {
        return;
    }

    NSObject *props = self.props;
    [[[props rac_valuesForKeyPath:keyPath
                         observer:props]
      takeUntil:props.rac_willDeallocSignal]
     subscribeNext:^(id x) {
         @strongify(self);
         [self setValue:x forKeyPath:keyPath];
     }];
}

#pragma mark - ReadonlyObjDataSource

- (id _Nullable)stateForKey:(NSString* _Nonnull)key {
    NSObject *props = self.props;
    return [props valueForKeyPath:key];
}

- (NSString* _Nonnull)propTypeForKey:(NSString* _Nonnull)key {
    return self.propTypesMapping[key];
}

@end
