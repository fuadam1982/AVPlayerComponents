//
//  Test-1.m
//  testModule
//
//  Created by fuhan on 2017/6/7.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import "Test-1.h"
#import <objc/runtime.h>
#import "ComponentPropsBuilder.h"

@implementation Test_1

- (id)test {
    Method thisMethod = class_getInstanceMethod([self class], @selector(setAge:));
    const char * encoding1 = method_getTypeEncoding(thisMethod);
    NSLog(@"%@", [NSString stringWithCString:encoding1 encoding:NSUTF8StringEncoding]);
    
    thisMethod = class_getInstanceMethod([self class], @selector(age));
    const char * encoding2 = method_getTypeEncoding(thisMethod);
    NSLog(@"%@", [NSString stringWithCString:encoding2 encoding:NSUTF8StringEncoding]);
    
    return toProps(@protocol(Test_1_Delegate)).build();
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
    return nil;
}

@end