//
//  Tools.h
//  testModule
//
//  Created by fuhan on 2017/5/16.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 解析obj所拥有的协议的只读属性信息

 @param obj obj
 @param parentProtocl 拥有的协议的父协议
 @param forReadonly 只处理只读属性
 @return 属性信息数组
 */
NSDictionary * parseProtocolPropertiesInfo(id obj, Protocol *parentProtocl, BOOL forReadonly);
