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

//////////////////////////////////////////////////////////////

// 因为无protect关键字，只能卸载一起
@interface StorePropsWrapper : PropsConstVarWrapper

- (instancetype)initWithProtocol:(Protocol *)varsProtocol data:(NSDictionary *)data;
- (void)syncData:(NSDictionary *)data;

@end

@interface MutableStorePropsWrapper : StorePropsWrapper

@end
