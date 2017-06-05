//
//  ReadonlyObjWrapper.m
//  OnionRings
//
//  Created by fuhan on 2017/3/15.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import "ReadonlyObjWrapper.h"

@interface ReadonlyObjWrapper ()

/** 属性访问数据源 */
@property (nonatomic, assign) id<ReadonlyObjDataSource> dataSource;

@end

@implementation ReadonlyObjWrapper

- (instancetype)initWithDataSource:(id<ReadonlyObjDataSource>)dataSource {
    self = [super init];
    self.dataSource = dataSource;
    return self;
}

/** 利用runtime捕获对prop的get方法 */
- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
    NSString* key = NSStringFromSelector(selector);
    if ([key rangeOfString:@"set"].location == NSNotFound) {
        NSString* propEncoding = [self.dataSource propTypeForKey:key];
        if (propEncoding.length > 0) {
            const char *methodEncoding = [[NSString stringWithFormat:@"%@@:", propEncoding]
                                          cStringUsingEncoding:NSUTF8StringEncoding];
            return [NSMethodSignature signatureWithObjCTypes:methodEncoding];
        }
    }
    return nil;
}

/** 返回真实的数据 */
- (void)forwardInvocation:(NSInvocation *)invocation {
    NSString *key = NSStringFromSelector([invocation selector]);
    if ([key rangeOfString:@"set"].location == NSNotFound) {
        id obj = [self.dataSource stateForKey:key];
        NSString* propEncoding = [self.dataSource propTypeForKey:key];
        if (propEncoding.length > 0) {
            const char * rawPropertyType = [propEncoding cStringUsingEncoding:NSUTF8StringEncoding];
            if (strcmp(rawPropertyType, @encode(BOOL)) == 0) {
                BOOL bVal = [obj boolValue];
                [invocation setReturnValue:&bVal];
            } else if (strcmp(rawPropertyType, @encode(int)) == 0) {
                int iVal = [obj intValue];
                [invocation setReturnValue:&iVal];
            } else if (strcmp(rawPropertyType, @encode(long)) == 0) {
                long lVal = [obj longValue];
                [invocation setReturnValue:&lVal];
            } else if (strcmp(rawPropertyType, @encode(float)) == 0) {
                float fVal = [obj floatValue];
                [invocation setReturnValue:&fVal];
            } else if (strcmp(rawPropertyType, @encode(long long)) == 0) {
                long long llVal = [obj longLongValue];
                [invocation setReturnValue:&llVal];
            } else if (strcmp(rawPropertyType, @encode(double)) == 0) {
                double dVal = [obj doubleValue];
                [invocation setReturnValue:&dVal];
            } else if ([propEncoding isEqualToString:@"@"]) {
                [invocation setReturnValue:&obj];
            }
        }
    }
}

/** 用于捕获KVO的属性访问 */
- (id)valueForUndefinedKey:(NSString *)key {
    return [self.dataSource stateForKey:key];
}

/** 用于实现KVO的赋值后通知 */
- (void)setValue:(nullable id)value forUndefinedKey:(NSString *)key {
    
}

@end
