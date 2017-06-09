//
//  Componentable.m
//  testModule
//
//  Created by fuhan on 2017/5/16.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import "Componentable.h"

#pragma mark - untils
#import "PropsConstVarWrapper.h"

@interface YCViewTemplate ()

@property (nonatomic, strong) id<YCStates> states;

@end

@implementation YCViewTemplate

- (void)setStates:(id<YCStates>)states {
    _states = states;
}

- (id<YCStates>)getStates {
    return self.states;
}

- (UIView *)getView {
    return self;
}

- (id<YCLayout>)getLayout {
    return (id<YCLayout>)self;
}

- (void)renderWithVarProps:(id<YCVarProps>)varProps {
    // 由组合组件子类实现
}

@end

//////////////////////////////////////////////////////////////

@interface YCViewControllerTemplate ()

@property (nonatomic, strong) id<YCStates> states;

@end

@implementation YCViewControllerTemplate

- (void)setStates:(id<YCStates>)states {
    _states = states;
}

- (id<YCStates>)getStates {
    return self.states;
}

- (UIView *)getView {
    return self.view;
}

- (id<YCLayout>)getLayout {
    return (id<YCLayout>)self;
}

- (void)renderWithVarProps:(id<YCVarProps>)varProps {
    // 由组合组件子类实现
}

@end

//////////////////////////////////////////////////////////////

@interface YCComponent ()

@property (nonatomic, strong) id<YCStates> states;
@property (nonatomic, strong) id<YCTemplate> template;
@property (nonatomic, strong) void (^varPropsBlock)(id<YCVarProps>);

@end

@implementation YCComponent

- (instancetype)initWithProps:(id<YCProps>)props callbacks:(id<YCCallbacks>)callbacks {
    // 需由子类实现
    return nil;
}

- (instancetype)initWithStates:(id<YCStates>)states template:(id<YCTemplate>)template {
    if (self = [super init]) {
        self.states = states;
        self.template = template;
        [self.template setStates:self.states];
    }
    return self;
}

- (UIView *)view {
    return [self.template getView];
}

- (id<YCProps>)toProps:(id<YCProps> (^)(id<YCStates>))block {
    return block(self.states);
}

- (void)setVarPropsBlock:(void (^)(id<YCVarProps>))varPropsBlock {
    _varPropsBlock = varPropsBlock;
}

- (void)render {
    id<YCVarProps> varProps = nil;
    
    // 处理子控件的varsProps
    if ([[self class] respondsToSelector:@selector(getChildrenVarProps)]) {
        varProps = [[self class] getChildrenVarProps];
        if (self.varPropsBlock) {
            self.varPropsBlock(varProps);
        }
    }
    [self.template renderWithVarProps:varProps];
}

- (void)layoutChildrenUI:(void (^)(id<YCLayout>, UIView *))layoutChildrenUIBlock {
    layoutChildrenUIBlock([self.template getLayout], self.view);
}

@end

//////////////////////////////////////////////////////////////

@interface YCComponentBuilder ()

@property (nonatomic, strong) Class componentClass;
@property (nonatomic, strong) Protocol * pVarsProtocol;
@property (nonatomic, strong) id<YCCallbacks> pCallbacks;
@property (nonatomic, strong) UIView *pSuperView;
@property (nonatomic, strong) NSDictionary * (^toConstVarsBlock)(id<YCVars>);
@property (nonatomic, strong) void (^setVarProps)(id<YCVarProps>);
@property (nonatomic, strong) id<YCProps> (^toPropsBlock)(NSDictionary *);

@end

@implementation YCComponentBuilder

- (instancetype)initWithComponentClass:(Class)componentClass {
    if (self = [super init]) {
        self.componentClass = componentClass;
    }
    return self;
}

- (YCComponentBuilder * (^)(Protocol *varsProtocol))varsProtocol {
    return ^YCComponentBuilder * (Protocol *varsProtocol) {
        self.pVarsProtocol = varsProtocol;
        return self;
    };
}

- (YCComponentBuilder * (^)(NSDictionary * (^)(id<YCVars>)))constVars {
    return ^YCComponentBuilder * (id toConstVarsBlock) {
        self.toConstVarsBlock = toConstVarsBlock;
        return self;
    };
}

- (YCComponentBuilder * (^)(id<YCVars>))varsObj {
    return ^YCComponentBuilder * (id<YCVars> varsObj) {
        if (self.toConstVarsBlock) {
            NSDictionary * (^preBlock)(id<YCVars>) = self.toConstVarsBlock;
            self.toConstVarsBlock = ^NSDictionary *(id<YCVars> vars) {
                NSMutableDictionary *tmpConstVars = [preBlock(vars) mutableCopy];
                [tmpConstVars addEntriesFromDictionary:[varsObj toDictionary]];
                return tmpConstVars;
            };
        } else {
            self.toConstVarsBlock = ^NSDictionary * (id _) {
                return [varsObj toDictionary];
            };
        }
        return self;
    };
}

- (YCComponentBuilder * (^)(void (^)(id<YCVarProps>)))childrenVarProps {
    return ^YCComponentBuilder * (id setVarProps) {
        self.setVarProps = setVarProps;
        return self;
    };
}

- (YCComponentBuilder * (^)(id<YCProps> (^)(NSDictionary *)))props {
    return ^YCComponentBuilder * (id toPropsBlock) {
        self.toPropsBlock = toPropsBlock;
        return self;
    };
}

- (YCComponentBuilder * (^)(id<YCStates>))states {
    return ^YCComponentBuilder * (id<YCStates> states) {
        self.toPropsBlock = ^id<YCProps> (NSDictionary *_) {
            return (id<YCProps>)states;
        };
        return self;
    };
}

- (YCComponentBuilder * (^)(id<YCCallbacks>))callbacks {
    return ^YCComponentBuilder * (id<YCCallbacks> callbacks) {
        self.pCallbacks = callbacks;
        return self;
    };
}

- (YCComponentBuilder *(^)(UIView *))superView {
    return ^YCComponentBuilder * (UIView *superView) {
        self.pSuperView = superView;
        return self;
    };
}

- (YCComponent *(^)())build {
    return ^YCComponent * {
        // 处理constVars
        NSDictionary *constVars = nil;
        if (self.pVarsProtocol) {
            PropsConstVarWrapper *wrapper = [[PropsConstVarWrapper alloc] initWithProtocol:self.pVarsProtocol];
            constVars = self.toConstVarsBlock((id<YCVars>)wrapper);
        } else if (self.toConstVarsBlock) {
            constVars = self.toConstVarsBlock(nil);
        }
        // 获得Props
        id<YCProps> props = self.toPropsBlock(constVars);
        // 创建Component实例
        YCComponent *component = [[self.componentClass alloc] initWithProps:props callbacks:self.pCallbacks];
        // 设置VarProps回调
        if (self.setVarProps) {
            [component setVarPropsBlock:self.setVarProps];
        }
        // 设置superView的目的是解决子组件在初始化时layout，但是还未被addSubView的情况
        if (self.pSuperView) {
            [self.pSuperView addSubview:component.view];
        }
        
        [component render];
        return component;
    };
}

@end

YCComponentBuilder *toComponent(Class componentClass) {
    return [[YCComponentBuilder alloc] initWithComponentClass:componentClass];
}
