//
//  YCGestureFloatVM.h
//  testModule
//
//  Created by fuhan on 2017/6/2.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Componentable.h"
#import "YCGestureFloatView.h"

@interface YCGestureFloatVM : NSObject<YCStates>

@property (nonatomic, strong, readonly) id<YCGestureFloatProps> props;

- (instancetype)initWithProps:(id<YCGestureFloatProps>)props callbacks:(id<YCGestureFloatCallbacks>)callbacks;
- (void)setGesturer:(UIView *)gesturer;
- (void)onDoubleTap;
- (void)onTap;
- (void)onLongPress;
- (void)onSwipWithDirection:(YCGestureFloatDirectionType)direction;
- (void)onPanWithDirection:(YCGestureFloatDirectionType)direction;

@end
