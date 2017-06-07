//
//  YCPortraitPlayerVM.h
//  testModule
//
//  Created by fuhan on 2017/6/1.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Componentable.h"
#import "YCAVPlayerComponent.h"
#import "YCPortraitPlayerComponent.h"

@interface YCPortraitPlayerVM : NSObject<YCPortraitPlayerStates>

@property (nonatomic, strong, readonly) id<YCAVPlayerProps> props;
@property (nonatomic, weak, readonly) id<YCPortraitPlayerCallbacks> callbacks;
/** 内部存储状态用来判断是否已经隐藏状态栏 */
@property (nonatomic, assign, readonly) BOOL innerStatusBarChangeState;

/** 切换播放器暂停/播放状态 */
- (void)switchPlayerState;

/** 初始化状态栏状态 */
- (void)initStatusBarState;

/** 切换状态栏弹出/收起状态 */
- (void)switchStatusBarState;

/** 恢复手势响应 */
- (void)resetRespondGesture;

@end
