//
//  ComponentPropsBuilder.h
//  testModule
//
//  Created by fuhan on 2017/5/17.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Componentable.h"
#import "ComponentPropsWrapper.h"

/** 快捷入口函数 */
@class ComponentPropsBuilder;
ComponentPropsBuilder * toProps(Protocol *propsProtocol);

/** 构造nameMaping PropName的快捷方法 */
NSString *toKeyPath(NSString *rootPath, NSString *key);

/*!
 *  使用构造器模式，链式构造ComponentPropsWrapper对象实例
 */
@interface ComponentPropsBuilder : NSObject

/** 用Props协议对象进行初始化，应为YCProps的子协议 */
- (instancetype)initWithPropsProtocol:(Protocol *)propsProtocol;

/** 设置组件的states对象作为Props数据提供者 */
- (ComponentPropsBuilder * (^) (id<YCStates>))states;

/** 
 * 如果设置了states对象，那么用nameMapping作为映射适配YCProps协议的只读字段名
 * dict参数: key为Props字段，value为States字段
 */
- (ComponentPropsBuilder * (^) (NSDictionary *))nameMapping;

/** 手动控制映射逻辑，目前如果设置了nameMappingBlock会忽略nameMapping */
- (ComponentPropsBuilder * (^) (NSString * (^)(NSString *)))nameMappingBlock;

/** 设置YCProps的不需要联动的属性值 */
- (ComponentPropsBuilder * (^) (NSDictionary *))constVars;

/** 构造ComponentPropsWrapper对象实例 */
- (ComponentPropsWrapper * (^) ())build;

@end
