//
//  PropsConstVarWrapper.h
//  testModule
//
//  Created by fuhan on 2017/6/7.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReadonlyObjWrapper.h"
#import "Componentable.h"

@interface PropsConstVarWrapper : AccessObjWrapper<YCVars>

- (instancetype)initWithProtocol:(Protocol *)varsProtocol;

@end
