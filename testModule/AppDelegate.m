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
#import "ViewModel.h"
#import <objc/runtime.h>
#import "Test-1.h"

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

- (instancetype)initWithProps:(id<YCProps>)props callbacks:(id<YCCallbacks>)callbacks {
    return [super init];
}

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
    
    // 测试设置属性
//    Test_1 *t1 = [Test_1 new];
//    id<MyAccess> my = (id<MyAccess>)t1;
//    my.address = @"ok";
//    NSLog(@"%@", my.address);
//    id<Test_1_Delegate> dd = [t1 test];
//    dd.age = 35;
//    dd.name = @"fh";
//    NSLog(@"%d - %@ - %@", dd.age, dd.name, [t1 toDict]);
    
    /*
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

    id<YCMoviePlayerComponentVCProps2> wrapper = (id<YCMoviePlayerComponentVCProps2>)toProps(@protocol(YCMoviePlayerComponentVCProps2))
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
    */
    
    YCMoviePlayerVC2 *vc = [YCMoviePlayerVC2 new];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = vc;
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

- (void)readProps {
    NSMutableDictionary* propTypes = [[NSMutableDictionary alloc] initWithCapacity:32];
    unsigned int count;

    Class class = [YCMoviePlayerVM2 class];
    objc_property_t* props = class_copyPropertyList(class, &count);
    
    for (int i = 0; i < count; i++) {
        objc_property_t property = props[i];
        const char * name = property_getName(property);
        const char * type = property_getAttributes(property);
        NSString * typeString = [NSString stringWithUTF8String:type];
        NSArray * attributes = [typeString componentsSeparatedByString:@","];
        
//        // 处理只读属性
//        if (forReadonly) {
//            BOOL isReadonly = NO;
//            for (NSString *ta in attributes) {
//                if ([ta isEqualToString:@"R"]) {
//                    isReadonly = YES;
//                    break;
//                }
//            }
//            if (!isReadonly) {
//                continue;
//            }
//        }
        
        // 处理属性encode
        NSString * typeAttribute = [attributes objectAtIndex:0];
        NSString * propertyType = [typeAttribute substringFromIndex:1];
        const char * rawPropertyType = [propertyType UTF8String];
        NSString* key = [NSString stringWithFormat:@"%s", name];
        
        if (strcmp(rawPropertyType, @encode(BOOL)) == 0) {
            propTypes[key] = [NSString stringWithFormat:@"%s", @encode(BOOL)];
        } else if (strcmp(rawPropertyType, @encode(int)) == 0) {
            propTypes[key] = [NSString stringWithFormat:@"%s", @encode(int)];
        } else if (strcmp(rawPropertyType, @encode(long)) == 0) {
            propTypes[key] = [NSString stringWithFormat:@"%s", @encode(long)];
        } else if (strcmp(rawPropertyType, @encode(long long)) == 0) {
            propTypes[key] = [NSString stringWithFormat:@"%s", @encode(long long)];
        } else if (strcmp(rawPropertyType, @encode(float)) == 0) {
            propTypes[key] = [NSString stringWithFormat:@"%s", @encode(float)];
        } else if (strcmp(rawPropertyType, @encode(double)) == 0) {
            propTypes[key] = [NSString stringWithFormat:@"%s", @encode(double)];
        } else if (strcmp(rawPropertyType, @encode(id)) == 0) {
            propTypes[key] = @"@";
        } else {
            propTypes[key] = @"@";
        }
    }
    
    free(props);
}

@end
