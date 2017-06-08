//
//  Tools.h
//  testModule
//
//  Created by fuhan on 2017/5/16.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 解析obj所拥有的协议的属性信息（暂时不用）
 根据协议的父协议来确定

 @param obj obj
 @param parentProtocl 拥有的协议的父协议
 @param forReadonly 只处理只读属性
 @return 属性信息字典
 */
NSDictionary * parseObjProtocolPropertiesInfo(id obj, Protocol *parentProtocl, BOOL forReadonly);



/**
 解析协议的属性信息（包括父协议属性）

 @param protocol 协议
 @param forReadonly 只处理只读属性
 @return 属性信息字典
 */
NSDictionary * parseProtocolPropertiesInfo(Protocol *protocol, BOOL forReadonly);

NSDictionary * parseClassPropertiesInfo(Class class);
