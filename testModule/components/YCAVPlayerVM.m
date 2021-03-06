//
//  YCAVPlayerVM.m
//  testModule
//
//  Created by fuhan on 2017/5/22.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import "YCAVPlayerVM.h"
#import "ReactiveCocoa.h"

static NSTimeInterval kRefreshInterval = 0.5f;

@interface YCAVPlayerVM ()

#pragma mark - YCStates
@property (nonatomic, strong) id<YCAVPlayerProps> props;
@property (nonatomic, weak) id<YCAVPlayerCallbacks> callbacks;

#pragma mark - YCAVPlayerStates
/** 播放中出现错误 */
@property (nonatomic, strong) NSError *error;
/** 视频的总时长(秒) */
@property (nonatomic, assign) NSTimeInterval videoDuration;
/** 视频播放结束 */
@property (nonatomic, assign) BOOL isPlayFinished;
/** 是否正在播放 */
@property (nonatomic, assign) BOOL isPlaying;
/** 是否卡顿 */
@property (nonatomic, assign) BOOL isLagged;
/** 是否已经加载完video */
@property (nonatomic, assign) BOOL isLoadedAllVideo;
/** 是否为HLS格式视频 */
@property (nonatomic, assign) BOOL isHLSVideo;
/** 已经缓存的视频所在路径，如果是HLS则为所有ts文件的目录 */
@property (nonatomic, strong) NSString *cachedVideoFolder;
/** 当前加载网速 */
@property (nonatomic, assign) float loadSpeed;
/** 已经加载的时间段 */
@property (nonatomic, strong) NSDictionary<NSNumber *, NSNumber *> * loadedDurations;
/** 当前播放的时间点 */
@property (nonatomic, assign) NSTimeInterval currTimePoint;
/** 实际观看时长 */
@property (nonatomic, assign) NSTimeInterval watchedDuration;
/** 观看总时长 */
@property (nonatomic, assign) NSTimeInterval stayDuration;
/** 当前的交互点, -1表示没有 */
@property (nonatomic, assign) NSTimeInterval currinteractionTimePoint;

#pragma mark - private
/** 用于delegate传出player实例 */
@property (nonatomic, weak) UIView *player;

@property (nonatomic, assign) BOOL isInitPlayingState;
/** seekToTime后是否可以播放 */
@property (nonatomic, assign) BOOL isCanPlay;
/** 最近加载的时间点 */
@property (nonatomic, assign) NSTimeInterval lastLoadedStartTime;
/** 最近加载的时间段 */
@property (nonatomic, assign) NSTimeInterval lastLoadedDuration;
/** 是否已经加载完毕 */
@property (nonatomic, assign) NSTimeInterval isLoadCompleted;

@end

@implementation YCAVPlayerVM

- (instancetype)initWithProps:(id<YCAVPlayerProps>)props callbacks:(id<YCAVPlayerCallbacks>)callbacks {
    if (self = [super init]) {
        self.props = props;
        self.callbacks = callbacks;
        self.loadedDurations = [[NSMutableDictionary alloc] initWithCapacity:8];
        [self dataBinding];
    }
    return self;
}

- (void)dataBinding {
    @weakify(self);
    // 播放器初始化时不可播放
    [self detectLagging:0 loadedDuration:0 currTimePoint:0 videoDuration:0];
    
    // TODO: delete
//    // 暂停
//    [[[RACObserve(self.props, isPause) ignore:@NO] filter:^BOOL(id value) {
//        @strongify(self);
//        // 视频播放器被创建后才开始关注该状态
//        return self.player != nil;
//    }]
//     subscribeNext:^(id x) {
//        @strongify(self);
//        [self setVideoCurrTimePoint:self.currTimePoint];
//     }];
    
    // 记录停留时间
    [[[RACSignal interval:kRefreshInterval
              onScheduler:[RACScheduler scheduler]]
      takeUntil:self.rac_willDeallocSignal]
     subscribeNext:^(id x) {
         @strongify(self);
         self.stayDuration += kRefreshInterval;
     }];
}

- (void)setPlayer:(UIView *)player {
    _player = player;
}

- (void)setPlayerError:(NSError *)error {
    _error = error;
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.callbacks respondsToSelector:@selector(player:onError:)]) {
            [self.callbacks player:self.player onError:self.error];
        }
    });
}

- (void)setCachedVideoFolder:(NSString *)cachedVideoFolder {
    _cachedVideoFolder = cachedVideoFolder;
}

- (void)setVideoDuration:(NSTimeInterval)videoDuration {
    _videoDuration = videoDuration;
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.callbacks respondsToSelector:@selector(player:onReadVideoDuration:)]) {
            [self.callbacks player:self.player onReadVideoDuration:self.videoDuration];
        }
    });
}

- (void)setNetSpeed:(double)netSpeed {
    self.loadSpeed = netSpeed;
}

- (void)seekToTime:(NSTimeInterval)timePoint {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.isCanPlay = NO;
        self.isPlaying = NO;
        self.currTimePoint = timePoint;
        [self setVideoCurrTimePoint:timePoint];
    });
}

- (void)setLoadedDuration:(NSTimeInterval)startTime duration:(NSTimeInterval)duration {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableDictionary *loadedDurations = (NSMutableDictionary *)self.loadedDurations;
        NSNumber *currKey = @(startTime);
        NSNumber *currDuration = @(duration);
        NSMutableArray *removeKeys = [[NSMutableArray alloc] initWithCapacity:4];

        // 合并已加载的数据段
        for (NSNumber *key in self.loadedDurations.allKeys) {
            NSNumber *val = self.loadedDurations[key];
            if (startTime > key.floatValue
                && fabs(startTime - key.floatValue) > 0.001) {
                if ((key.floatValue + val.floatValue) >= startTime) {
                    currKey = key;
                    currDuration = @(startTime + duration);
                }
            }
            if (startTime < key.floatValue
                && fabs(key.floatValue - startTime) > 0.001
                && (startTime + duration) >= key.floatValue) {
                [removeKeys addObject:key];
            }
        }
        // 删除重复的数据段
        for (NSString *key in removeKeys) {
            [loadedDurations removeObjectForKey:key];
        }
        // 更新缓存段
        loadedDurations[currKey] = currDuration;
        self.loadedDurations = loadedDurations;

        if ([self.callbacks respondsToSelector:@selector(player:onLoadedDurations:)]) {
            [self.callbacks player:self.player onLoadedDurations:self.loadedDurations];
        }
        // 判定延迟
        [self detectLagging:startTime
             loadedDuration:duration
              currTimePoint:self.currTimePoint
              videoDuration:self.videoDuration];
    });
}

- (void)detectLagging:(NSTimeInterval)loadedStartTime
       loadedDuration:(NSTimeInterval)loadedDuration
        currTimePoint:(NSTimeInterval)currTimePoint
        videoDuration:(NSTimeInterval)videoDuration {
    // seekToTime后会出现加载的时间小于当前时间
    if (loadedStartTime < currTimePoint) {
        self.currTimePoint = loadedStartTime;
    }
    
    self.lastLoadedStartTime = loadedStartTime;
    self.lastLoadedDuration = loadedDuration;
    // 判断是否加载完毕
    if (self.videoDuration > 0
        && ((self.lastLoadedStartTime + self.lastLoadedDuration > self.videoDuration)
        || (fabs(self.lastLoadedStartTime + self.lastLoadedDuration - self.videoDuration) < 1))) {
        self.isLoadCompleted = YES;
    }
    // 计算buffer
    NSTimeInterval buffer = loadedStartTime + loadedDuration - self.currTimePoint;
    BOOL isLagging = YES;
    if (self.isLoadCompleted
        || buffer > self.props.minPlayTime
        || fabs(buffer - self.props.minPlayTime) < 0.001) {
        isLagging = NO;
    } else {
        // 视频即将结束
        BOOL isWillCompleted = videoDuration > 0 && (videoDuration - self.currTimePoint) < self.props.minPlayTime;
        if (isWillCompleted) {
            isLagging = !(buffer > self.currTimePoint
                         || fabs(videoDuration - loadedStartTime - loadedDuration) < 0.001);
        }
    }
    
    [self _detectLagging:isLagging];
}

- (void)_detectLagging:(BOOL)isLagging {
    if (self.isLagged != isLagging) {
        self.isLagged = isLagging;
    }
    if (self.isCanPlay && !self.props.isPause) {
        BOOL isPlaying = !self.isLagged;
        if (self.isPlaying != isPlaying) {
            self.isPlaying = isPlaying;
        }
    }
    
    if ([self.callbacks respondsToSelector:@selector(player:onLagged:loadSpeed:)]) {
        [self.callbacks player:self.player onLagged:self.isLagged loadSpeed:self.loadSpeed];
    }
}

- (void)setVideoCurrTimePoint:(NSTimeInterval)currTimePoint {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSTimeInterval interval = currTimePoint - self.currTimePoint;
        if (self.isPlaying) {
            self.currTimePoint += interval;
            self.watchedDuration += interval;
        }
        if (self.isCanPlay) {
            // 正常播放时判断是否会卡顿
            if (self.isPlaying && !self.isLoadCompleted) {
                NSTimeInterval buffer = self.lastLoadedStartTime + self.lastLoadedDuration - self.currTimePoint;
                if (fabs(buffer) < 0.001) {
                    [self _detectLagging:YES];
                }
                // 无网状态下是否需要检查buffer
                BOOL notCheck = self.props.isLostNetworking && self.props.isCanPlayWithoutNetworking;
                if (!notCheck && buffer < self.props.minPlayTime) {
                    [self _detectLagging:YES];
                }
            }
            
            if ([self.callbacks respondsToSelector:@selector(player:onPlayingCurrTime:isPause:)]) {
                [self.callbacks player:self.player
                     onPlayingCurrTime:self.currTimePoint
                               isPause:!self.isPlaying];
            }
        }
    });
}

- (void)videoReadyToPlay {
    self.isCanPlay = YES;
    
    // 处理已经缓存， playerItem不回调loadedTimeRanges情况
    if (self.isLoadCompleted && !self.isPlaying) {
        self.isPlaying = YES;
    } else {
        // 延迟0.25s，如果还是无法播放判断是否已经加载过了缓冲
        [[[[RACSignal interval:0.25
                   onScheduler:[RACScheduler scheduler]] take:1] deliverOnMainThread]
         subscribeNext:^(id x) {
             if (!self.isPlaying
                && self.lastLoadedStartTime + self.lastLoadedDuration >= self.currTimePoint) {
                 [self receiveSystemStallNotify];
             }
        }];
    }
}

- (void)videoPlayFinishedByInterrupt:(BOOL)interrupt {
    if (self.watchedDuration > self.stayDuration) {
        if ((self.stayDuration + kRefreshInterval) > self.watchedDuration) {
            self.stayDuration += kRefreshInterval;
        } else {
            self.stayDuration = self.watchedDuration;
        }
    }
    self.isPlayFinished = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.callbacks respondsToSelector:@selector(player:onFinishedByInterrupt:watchedDuration:stayDuration:)]) {
            [self.callbacks player:self.player
             onFinishedByInterrupt:interrupt
                   watchedDuration:self.watchedDuration
                      stayDuration:self.stayDuration];
        }
    });
}

- (void)receiveSystemStallNotify {
    [self detectLagging:self.lastLoadedStartTime
         loadedDuration:self.lastLoadedDuration
          currTimePoint:self.currTimePoint
          videoDuration:self.videoDuration];
}

- (void)switchPlayerState:(BOOL)isPause {
    if (self.isInitPlayingState && self.isPlaying == isPause) {
        self.isPlaying = !self.isPlaying;
    } else {
        self.isInitPlayingState = YES;
    }
}

@end
