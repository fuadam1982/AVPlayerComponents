//
//  YCPlayerSkipBtnVM.h
//  testModule
//
//  Created by fuhan on 2017/5/19.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Componentable.h"

@protocol YCPlayerSkipBtnProps;
@interface YCPlayerSkipBtnVM : NSObject<YCStates>

@property (nonatomic, strong, readonly) id<YCPlayerSkipBtnProps> props;
/** 提示用户多少秒后可以跳过 */
@property (nonatomic, assign, readonly) NSInteger skipSeconds;
/** 是否可以跳过 */
@property (nonatomic, assign, readonly) BOOL canSkip;

/** 发送跳过事件 */
- (void)emitSkip;

@end
