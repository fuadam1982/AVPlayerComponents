//
//  AdapterComponentStatesWrapper.h
//  testModule
//
//  Created by fuhan on 2017/5/18.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Componentable.h"
#import "ReadonlyObjWrapper.h"

@interface AdapterComponentStatesWrapper : ReadonlyObjWrapper<YCStates>

- (void)updateState:(id)state keyPath:(NSString *)keyPath;
- (void)dataBindingWithKeyPath:(NSString *)keyPath;

@end
