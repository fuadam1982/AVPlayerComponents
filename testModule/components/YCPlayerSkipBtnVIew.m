//
//  YCPlayerSkipBtnVIew.m
//  testModule
//
//  Created by fuhan on 2017/5/19.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import "YCPlayerSkipBtnVIew.h"
#import "YCPlayerSkipBtnVM.h"

@interface YCPlayerSkipBtnView ()

@property (nonatomic, strong, readonly, getter=getStates) YCPlayerSkipBtnVM *states;
@property (nonatomic, strong) UIButton *btnSkip;
@property (nonatomic, strong) UILabel *lblTips;

@end

@implementation YCPlayerSkipBtnView

- (instancetype)initWithProps:(id<YCProps>)props callbacks:(id<YCCallbacks>)callbacks {
    YCPlayerSkipBtnVM *states = [[YCPlayerSkipBtnVM alloc] initWithProps:props callbacks:callbacks];
    if (self = [super initWithStates:states]) {
        [self layout];
    }
    return self;
}

- (void)layout {
    self.btnSkip = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.btnSkip];
    self.lblTips = [[UILabel alloc] init];
    self.lblTips.textColor = [UIColor blackColor];
    self.lblTips.font = [UIFont systemFontOfSize:12];
    self.lblTips.text = [NSString stringWithFormat:@"%ld秒后可以跳过", (long)self.states.props.skipSeconds];
    [self addSubview:self.lblTips];

}

@end
