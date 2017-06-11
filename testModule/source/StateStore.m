//
//  StateStore.m
//  testModule
//
//  Created by fuhan on 2017/5/17.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import "StateStore.h"

#import "StoreAction.h"
#import "ComponentPropsBuilder.h"
#import "PropsConstVarWrapper.h"

StateStore *store() {
    return [StateStore shared];
}

//////////////////////////////////////////////////////////////

typedef NSDictionary * (^ReducerFn)(id<YCMutableStore>, StoreAction *);
static NSString * kActionInitStore = @"InitStore";

@interface StateStore ()

@property (nonatomic, strong) dispatch_queue_t queue;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSDictionary<NSString *, id> *> *storesData;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSArray<Protocol *> *> *storeProtocolMapping;
@property (nonatomic, strong) NSMutableDictionary<NSString *, ReducerFn> *reducers;
@property (nonatomic, strong) NSMutableDictionary<NSString *, StorePropsWrapper *> *stores;

@end

@implementation StateStore

+ (instancetype)shared {
    static StateStore *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[StateStore alloc] init];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        self.queue = dispatch_queue_create("CUSTOM_STATESTORE_QUEUE", DISPATCH_QUEUE_SERIAL);
        self.storesData = [[NSMutableDictionary alloc] initWithCapacity:16];
        self.storeProtocolMapping = [[NSMutableDictionary alloc] initWithCapacity:16];
        self.reducers = [[NSMutableDictionary alloc] initWithCapacity:128];
        self.stores = [[NSMutableDictionary alloc] initWithCapacity:16];
    }
    return self;
 }

- (void)registStoreProtocol:(Protocol *)storeProtocol
       mutableStoreProtocol:(Protocol *)mutableStoreProtocol
                   category:(NSString *)category {
    @synchronized (self) {
        self.storeProtocolMapping[category] = @[storeProtocol, mutableStoreProtocol];
        self.storesData[category] = @{};
    }
}

- (void)registInitStoreByCategory:(NSString *)category block:(RACSignal *(^)())block {
    // TODO: thunk middleware
}

- (void)registReducerByCategory:(NSString *)category
                           type:(NSString *)type
                          block:(NSDictionary * (^)(id<YCMutableStore>, StoreAction *))block {
    NSString *key = [NSString stringWithFormat:@"%@-%@", category, type];
    @synchronized (self) {
        self.reducers[key] = block;
    }
}

- (id<YCStore>)getStoreByCategory:(NSString *)category {
    StorePropsWrapper *store = self.stores[category];
    if (!store) {
    Protocol *storeProtocol = self.storeProtocolMapping[category][0];
        store = [[StorePropsWrapper alloc] initWithProtocol:storeProtocol
                                                       data:self.storesData[category]];
        self.stores[category] = store;
    }
    return (id<YCStore>)store;
}

- (RACSignal * (^)(StoreAction *))dispatch {
    return ^RACSignal * (StoreAction *action) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            dispatch_async(self.queue, ^{
                NSMutableDictionary *storeData = [self.storesData[action.category] mutableCopy];
                Protocol *mutableStoreProtocol = self.storeProtocolMapping[action.category][1];
                NSString *key = [NSString stringWithFormat:@"%@-%@", action.category, action.type];
                ReducerFn block = self.reducers[key];
                id mutableStore = [[MutableStorePropsWrapper alloc] initWithProtocol:mutableStoreProtocol
                                                                                data:storeData];
                NSDictionary *modifiedStoreData = block(mutableStore, action);
                [storeData addEntriesFromDictionary:modifiedStoreData];
                self.storesData[action.category] = storeData;
                
                StorePropsWrapper *store = self.stores[action.category];
                if (store && storeData) {
                    [store syncData:storeData];
                }
                
                [subscriber sendNext:@YES];
                [subscriber sendCompleted];
            });

            return nil;
        }];
    };
}

@end
