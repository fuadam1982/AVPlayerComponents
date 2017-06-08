//
//  Test-1.h
//  testModule
//
//  Created by fuhan on 2017/6/7.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Componentable.h"

@protocol MyReadOnly <NSObject>

@property (nonatomic, strong, readonly) NSString *address;

@end

@protocol MyAccess <MyReadOnly>

- (void)setAddress:(NSString *)address;

@end

@protocol Test_1_Delegate <MyReadOnly>

@property (nonatomic, assign) int age;
@property (nonatomic, strong) NSString *name;

@end

@protocol YCTest_1Immutable <NSObject>

@end

@protocol YCTest_1Porps <YCProps>

@end

@interface Test_1 : NSObject<MyAccess>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) int age;

- (id)test;
- (NSDictionary *)toDict;

@end
