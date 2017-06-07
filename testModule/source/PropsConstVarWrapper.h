//
//  PropsConstVarWrapper.h
//  testModule
//
//  Created by fuhan on 2017/6/7.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReadonlyObjWrapper.h"

@interface PropsConstVarWrapper : AccessObjWrapper

- (instancetype)initWithProtocol:(Protocol *)propsProtocol;
- (NSDictionary *)toDictionary;

@end
