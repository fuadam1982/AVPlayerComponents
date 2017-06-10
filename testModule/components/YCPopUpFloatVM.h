//
//  YCPopUpFloatVM.h
//  testModule
//
//  Created by fuhan on 2017/6/6.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - component
#import "YCPopUpFloatComponent.h"

#pragma mark - utils
#import "Componentable.h"

@interface YCPopUpFloatVM : NSObject<YCStates>

#pragma mark - YCStates
@property (nonatomic, strong, readonly) id<YCPopUpFloatProps> props;
/** 是否初始化 */
@property (nonatomic, assign, readonly) BOOL isInited;
/** 弹出还是收起状态 */
@property (nonatomic, assign, readonly) BOOL isShow;

/** 用于callbacks回调 */
- (void)setPopUpView:(UIView *)popUpView;

/** 初始化完成 */
- (void)initCompleted;

/** 切换弹出/收起状态 */
- (void)switchState;

@end
