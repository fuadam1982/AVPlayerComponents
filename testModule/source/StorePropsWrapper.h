//
//  StorePropsWrapper.h
//  testModule
//
//  Created by lucifer on 11/06/2017.
//  Copyright © 2017 fuhan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PropsConstVarWrapper.h"

@interface StorePropsWrapper : PropsConstVarWrapper

- (void)syncData:(NSDictionary *)data;

@end
