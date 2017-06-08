//
//  ReadonlyObjWrapper.h
//  OnionRings
//
//  Created by fuhan on 2017/3/15.
//  Copyright © 2017年 fuhan. All rights reserved.
//
// TODO: 修改文件名
#import <Foundation/Foundation.h>

/**
 *  访问真正持有State存储集合的协议
 */
@protocol AccessObjDataSource <NSObject>

/** 根据key获取state值 */
- (id _Nullable)stateForKey:(NSString* _Nonnull)key;

/** 根据key获取属性encoding类型 */
- (NSString* _Nonnull)propTypeForKey:(NSString* _Nonnull)key;

@optional
/** 根据key设置state值 */
- (void)setState:(id _Nullable)state key:(NSString *_Nonnull)key;

@end

/**
 *  动态访问对象属性包装类
 *  根据协议动态创建可以访问属性的对象
 */
@interface AccessObjWrapper : NSObject

/** 使用属性维护数据源初始化 */
- (instancetype _Nonnull)initWithDataSource:(id<AccessObjDataSource> _Nonnull)dataSource;

@end
