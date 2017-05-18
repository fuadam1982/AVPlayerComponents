//
//  AppDelegate.m
//  testModule
//
//  Created by fuhan on 2017/5/15.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import "AppDelegate.h"
#import "ReactiveCocoa.h"
#import "ViewController.h"
#import "ComponentPropsBuilder.h"


@class CooObj, DooObj;
@interface BooObj : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) CooObj *coo;

@end

@implementation BooObj

@end


@interface CooObj : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) DooObj *doo;

@end

@implementation CooObj

@end


@interface DooObj : NSObject

@property (nonatomic, strong) NSString *name;

@end

@implementation DooObj

@end

@interface FooObj : NSObject<YCStates>

@property (nonatomic, assign) BOOL notFlag;
@property (nonatomic, strong) BooObj *boo;

@end

@interface FooObj ()

@property (nonatomic, strong) NSString *XXXstartVideoURL;
@property (nonatomic, strong) NSString *videoURL;

@end

@implementation FooObj

@end


@interface Callbacks1 : NSObject<YCCallbacks>

@property (nonatomic, strong, readonly) RACSignal *onFinished;
@property (nonatomic, strong, readonly) RACSignal *onError;

@end

@implementation Callbacks1

@end

@protocol Callbacks <YCCallbacks>

- (void)onFinished;
- (void)onError:(NSError *)error;

@end

//////////////////////////////////////////////////////////////////

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // test props
    FooObj *foo = [FooObj new];
    foo.XXXstartVideoURL = @"start video url xxx";
    DooObj *doo = [DooObj new];
    CooObj *coo = [CooObj new];
    coo.doo = doo;
    BooObj *boo = [BooObj new];
    boo.coo = coo;
    foo.boo = boo;

    id<YCMoviePlayerComponentVCProps> wrapper = (id<YCMoviePlayerComponentVCProps>)toProps(@protocol(YCMoviePlayerComponentVCProps))
    .states(foo)
    .nameMapping(@{
                   @"name": @"boo.coo.doo.name",
                   @"startVideoURL": @"XXXstartVideoURL",
    })
    .constVars(@{@"stopVideoURL": @"stopURL.html"})
    .build();
    
    
    
    NSLog(@">>> %@", wrapper.stopVideoURL);
    NSLog(@">>> %@", wrapper.name);
    NSLog(@">>> %@", wrapper.startVideoURL);
    NSLog(@">>> %@", wrapper.videoURL);
    
    [[RACObserve(wrapper, videoURL) ignore:nil] subscribeNext:^(id x) {
        NSLog(@"### videoURL: %@", x);
    }];
    [[RACObserve(wrapper, name) ignore:nil] subscribeNext:^(id x) {
        NSLog(@"### name: %@", x);
    }];
    foo.videoURL = @"low video url xxx";
    doo.name = @"doo name";
    
    // build root component
    UIViewController* container = [UIViewController new];
    YCMoviePlayerComponentVC *vc = [[YCMoviePlayerComponentVC alloc] initWithProps:nil callbacks:nil];
    [vc addToContainer:container];
    
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = container;
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}


- (void)applicationWillTerminate:(UIApplication *)application {
    
}


@end
