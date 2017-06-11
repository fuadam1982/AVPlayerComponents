//
//  YCPortraitPlayerComponent.m
//  testModule
//
//  Created by fuhan on 2017/6/5.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import "YCPortraitPlayerComponent.h"

#pragma mark - viewmodel
#import "YCPortraitPlayerVM.h"

#pragma mark - view
#import "YCPortraitPlayerView.h"

#pragma mark - unitls
#import "ComponentPropsBuilder.h"
#import "PropsConstVarWrapper.h"

// TODO: remove to module define
static NSString *kCategory = @"[C]::VideoPlayer";
static NSString *kTypeSharePlayer = @"[T]::SharePlayer";
static NSString *kPayloadPlayerId = @"[P]::PlayerId";
static NSString *kPayloadSharedPlayer = @"[P]::SharedPlayer";
static NSString *kTypeRemoveSharedPlayer = @"[T]::RemoveSharedPlayer";

StoreAction *sharePlayerAction(NSString *videoId, YCComponent *player) {
    return [[StoreAction alloc] initWithCategory:kCategory
                                            type:kTypeSharePlayer
                                         payload:@{
                                                   kPayloadPlayerId: videoId,
                                                   kPayloadSharedPlayer: player
                                                   }];
}

StoreAction *removeSharedPlayerAction(NSString *videoId) {
    return [[StoreAction alloc] initWithCategory:kCategory
                                            type:kTypeRemoveSharedPlayer
                                         payload:@{
                                                   kPayloadPlayerId: videoId
                                                   }];
}

@implementation YCVideoPlayerComponent

+ (void)load {
    [[StateStore shared] registStoreProtocol:@protocol(YCVideoPlayerStore)
                        mutableStoreProtocol:@protocol(YCVideoPlayerMutableStore)
                                    category:kCategory];
    [[StateStore shared] registReducerByCategory:kCategory
                                            type:kTypeSharePlayer
                                           block:^NSDictionary *(id<YCVideoPlayerMutableStore> store, StoreAction * action) {
                                               store.sharedPlayerInstance = @[
                                                                              action.payload[kPayloadPlayerId],
                                                                              action.payload[kPayloadSharedPlayer]
                                                                              ];
                                               return [store toDictionary];
                                           }];
    [[StateStore shared] registReducerByCategory:kCategory
                                            type:kTypeRemoveSharedPlayer
                                           block:^NSDictionary *(id<YCVideoPlayerMutableStore> store, StoreAction * action) {
                                               if ([action.payload[kPayloadPlayerId] isEqualToString:
                                                    store.sharedPlayerInstance[0]]) {
                                                   store.sharedPlayerInstance = nil;
                                                   return [store toDictionary];
                                               } else {
                                                   return nil;
                                               }
                                           }];
}

- (instancetype)initWithProps:(id<YCVideoPlayerProps>)props callbacks:(id<YCVideoPlayerCallbacks>)callbacks {
    YCVideoPlayerVM *states = [[YCVideoPlayerVM alloc] initWithProps:props callbacks:callbacks];
    YCVideoPlayerView *template = [[YCVideoPlayerView alloc] init];
    return [super initWithStates:states template:template];
}

+ (id<YCVarProps>)getChildrenVarProps {
    return (id<YCVarProps>)toProps(@protocol(YCVideoPlayerVarProps))
    .constVars(@{
                 @"gesture": [[PropsConstVarWrapper alloc] initWithProtocol:@protocol(YCGestureFloatVars)],
                 @"gesturePlay": [[PropsConstVarWrapper alloc] initWithProtocol:@protocol(YCPlayStateVars)],
                 @"status": [[PropsConstVarWrapper alloc] initWithProtocol:@protocol(YCPopUpFloatVars)],
                 @"statusPlay": [[PropsConstVarWrapper alloc] initWithProtocol:@protocol(YCPlayStateVars)],
                 })
    .build();
}

@end
