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


///////////////////////////////////////////////////////

@protocol Callbacks <YCCallbacks>

- (void)onFinished;
- (void)onError:(NSError *)error;

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

@interface FooObj (xxxSubComponent) <Callbacks>

@end

@implementation FooObj (xxxSubComponent)

- (void)onError:(NSError *)error {
    NSLog(@"FooObj handle onError event ...");
}

- (void)onFinished {
    NSLog(@"FooObj handle onFinished event ...");
    self.boo.coo.doo.name = @"finished ...";
}

@end

@interface SubC : NSObject

@property (nonatomic, assign) id<Callbacks> delegate;

- (instancetype)initWithDelegate:(id<Callbacks>)delegate;

@end

@implementation SubC

- (instancetype)initWithDelegate:(id<Callbacks>)delegate {
    if (self = [super init]) {
        self.delegate = delegate;
    }
    return self;
}

- (void)doComplete {
    [self.delegate onFinished];
}

@end

//////////////////////////////////////////////////////////////////

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // test props
    FooObj *foo = [FooObj new];
    SubC *sub = [[SubC alloc] initWithDelegate:foo];
    
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
    
    [sub doComplete];
    
    // build root component
    UIViewController* container = [UIViewController new];
    YCMoviePlayerComponent *component = [[YCMoviePlayerComponent alloc] initWithProps:nil callbacks:nil];
    [component addToContainer:container];
    
    
    
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
