//
//  ReadonlyObjWrapper.h
//  OnionRings
//
//  Created by fuhan on 2017/3/15.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  访问真正持有State存储集合的协议
 */
@protocol ReadonlyObjDataSource <NSObject>

- (id _Nullable)stateForKey:(NSString* _Nonnull)key;
- (NSString* _Nonnull)propTypeForKey:(NSString* _Nonnull)key;

@end

/**
 *  只读对象包装类
 *  因为OC没有访问控制操作符，所以只能利用Runtime方法对真实的存储对象（Dictionary）做一层包装
 */
@interface ReadonlyObjWrapper : NSObject

- (instancetype _Nonnull)initWithDataSource:(id<ReadonlyObjDataSource> _Nonnull)dataSource;

@end
