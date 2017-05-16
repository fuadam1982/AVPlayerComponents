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
#import "Tools.h"

@interface FooObj : NSObject<YCMoviePlayerComponentVCProps>

@property (nonatomic, assign) BOOL notFlag;

@end

@interface FooObj ()

@property (nonatomic, strong) NSString *startVideoURL;
@property (nonatomic, strong) NSString *stopVideoURL;
@property (nonatomic, strong) NSString *videoURL;

@end

@implementation FooObj

@end

//////////////////////////////////////////////////////////////////

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    FooObj *foo = [FooObj new];
    parseProtocolPropertiesInfo(foo, @protocol(YCProps));
    
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
