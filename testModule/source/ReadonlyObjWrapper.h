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

/** 根据key获取state值 */
- (id _Nullable)stateForKey:(NSString* _Nonnull)key;

/** 根据key获取属性encoding类型 */
- (NSString* _Nonnull)propTypeForKey:(NSString* _Nonnull)key;

@end

/**
 *  只读对象包装类
 *  因为OC没有访问控制操作符，所以只能利用Runtime方法对真实的存储对象（Dictionary）做一层包装
 */
@interface ReadonlyObjWrapper : NSObject

/** 使用属性维护数据源初始化 */
- (instancetype _Nonnull)initWithDataSource:(id<ReadonlyObjDataSource> _Nonnull)dataSource;

@end
