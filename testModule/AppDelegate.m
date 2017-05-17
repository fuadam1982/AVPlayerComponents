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
#import "ComponentPropsWrapper.h"

@interface FooObj : NSObject<YCStates>

@property (nonatomic, assign) BOOL notFlag;

@end

@interface FooObj ()

@property (nonatomic, strong) NSString *XXXstartVideoURL;
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
    foo.XXXstartVideoURL = @"start video url xxx";
    id<YCMoviePlayerComponentVCProps> wrapper = (id<YCMoviePlayerComponentVCProps>)[[ComponentPropsWrapper alloc] initWithPropsProtocol:@protocol(YCMoviePlayerComponentVCProps) states:foo
                                                                                transform:^RACTuple *(NSString *propKey) {
                                                                                    if ([propKey isEqualToString:@"startVideoURL"]) {
                                                                                        return RACTuplePack(foo, @"XXXstartVideoURL");
                                                                                    }
                                                                                    return nil;
    }
                                                                                constVars:@{
                                                                                            @"stopVideoURL": @"stopURL.html"
                                                                                            }];
    NSLog(@">>> %@", wrapper.stopVideoURL);
    NSLog(@">>> %@", wrapper.startVideoURL);
    NSLog(@">>> %@", wrapper.videoURL);
    
    [[RACObserve(wrapper, videoURL) ignore:nil] subscribeNext:^(id x) {
        NSLog(@"### %@", wrapper.videoURL);
    }];
    foo.videoURL = @"low video url xxx";
    
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
