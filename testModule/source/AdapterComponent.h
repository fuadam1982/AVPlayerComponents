//
//  AdapterComponent.h
//  testModule
//
//  Created by fuhan on 2017/5/18.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Componentable.h"

@class AdapterComponentStatesWrapper;
@interface YCAdapterComponent : YCBaseComponent<YCComponent>

- (instancetype)initWithProps:(id<YCStates>)states origin:(id<YCComponent>)origin;
- (void)addSubComponentUseBlock:(id<YCComponent> (^)(AdapterComponentStatesWrapper *states, id<YCCallbacks>callbacks))block;

@end
