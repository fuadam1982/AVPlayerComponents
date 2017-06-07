//
//  ReadonlyObjWrapper.m
//  OnionRings
//
//  Created by fuhan on 2017/3/15.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import "ReadonlyObjWrapper.h"

@interface AccessObjWrapper ()

/** 属性访问数据源 */
@property (nonatomic, assign) id<AccessObjDataSource> dataSource;

@end

@implementation AccessObjWrapper

- (instancetype)initWithDataSource:(id<AccessObjDataSource>)dataSource {
    self = [super init];
    self.dataSource = dataSource;
    return self;
}

/** 利用runtime捕获对prop的get方法 */
- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
    NSString *key = NSStringFromSelector(selector);
    if ([key rangeOfString:@"set"].location == NSNotFound) {
        NSString *propEncoding = [self.dataSource propTypeForKey:key];
        if (propEncoding.length > 0) {
            const char *methodEncoding = [[NSString stringWithFormat:@"%@@:", propEncoding]
                                          cStringUsingEncoding:NSUTF8StringEncoding];
            return [NSMethodSignature signatureWithObjCTypes:methodEncoding];
        }
    } else {
        key = [self getKeyFromSetMethod:key];
        NSString *propEncoding = [self.dataSource propTypeForKey:key];
        if (propEncoding.length > 0) {
            const char *methodEncoding = [[NSString stringWithFormat:@"v@:%@", propEncoding]
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
    } else {
        key = [self getKeyFromSetMethod:key];
        NSString* propEncoding = [self.dataSource propTypeForKey:key];
        if (propEncoding.length > 0) {
            const char * rawPropertyType = [propEncoding cStringUsingEncoding:NSUTF8StringEncoding];
            if (strcmp(rawPropertyType, @encode(BOOL)) == 0) {
                BOOL bVal = NO;
                [invocation getArgument:&bVal atIndex:2];
                [self.dataSource setValue:@(bVal) key:key];
            } else if (strcmp(rawPropertyType, @encode(int)) == 0) {
                int iVal = 0;
                [invocation getArgument:&iVal atIndex:2];
                [self.dataSource setValue:@(iVal) key:key];
            } else if (strcmp(rawPropertyType, @encode(long)) == 0) {
                long lVal = 0;
                [invocation getArgument:&lVal atIndex:2];
                [self.dataSource setValue:@(lVal) key:key];
            } else if (strcmp(rawPropertyType, @encode(float)) == 0) {
                float fVal = 0;
                [invocation getArgument:&fVal atIndex:2];
                [self.dataSource setValue:@(fVal) key:key];
            } else if (strcmp(rawPropertyType, @encode(long long)) == 0) {
                long long llVal = 0;
                [invocation getArgument:&llVal atIndex:2];
                [self.dataSource setValue:@(llVal) key:key];
            } else if (strcmp(rawPropertyType, @encode(double)) == 0) {
                double dVal = 0;
                [invocation getArgument:&dVal atIndex:2];
                [self.dataSource setValue:@(dVal) key:key];
            } else if ([propEncoding isEqualToString:@"@"]) {
                __unsafe_unretained id oVal = nil;
                [invocation getArgument:&oVal atIndex:2];
                [self.dataSource setValue:oVal key:key];
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

#pragma mark - private methods

- (NSString *)getKeyFromSetMethod:(NSString *)setMethodKey {
    NSString *key = setMethodKey;
    key = [key stringByReplacingOccurrencesOfString:@"set" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@":" withString:@""];
    NSString *firstChar = [[key substringToIndex:1] lowercaseString];
    key = [NSString stringWithFormat:@"%@%@", firstChar, [key substringFromIndex:1]];
    return key;
}

@end
