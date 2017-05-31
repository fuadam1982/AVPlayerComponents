//
//  YCAVPlayerVM.m
//  testModule
//
//  Created by fuhan on 2017/5/22.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import "YCAVPlayerVM.h"
#import "ReactiveCocoa.h"

@interface YCAVPlayerVM ()

// MARK: YCStates
@property (nonatomic, strong) id<YCAVPlayerProps> props;
@property (nonatomic, weak) id<YCAVPlayerCallbacks> callbacks;

// MARK: YCAVPlayerStates
/** 播放中出现错误 */
@property (nonatomic, strong) NSError *error;
/** 视频的总时长(秒) */
@property (nonatomic, assign) NSTimeInterval videoDuration;
/** 是否可以播放 */
@property (nonatomic, assign) BOOL readyToPlay;
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

// MARK: private
/** 用于delegate传出player实例 */
@property (nonatomic, weak) YCAVPlayerView *player;
/** 已加载的最大时间点 */
@property (nonatomic, assign) float loadedTimePoint;
/** 暂停preload，例如3G网络下不需要下载, 同时不需要loading */
@property (nonatomic, assign) BOOL isPausePreloading;
/** seekToTime后是否可以播放 */
@property (nonatomic, assign) BOOL isCanPlay;

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
    // 暂停
    [[[RACObserve(self.props, isPause) ignore:@NO] filter:^BOOL(id value) {
        @strongify(self);
        // 视频播放器被创建后才开始关注该状态
        return self.player != nil;
    }]
     subscribeNext:^(id x) {
        @strongify(self);
        [self setVideoCurrTimePoint:self.currTimePoint];
     }];
    // 记录停留时间
    NSTimeInterval interval = 0.5;
    [[[RACSignal interval:interval
              onScheduler:[RACScheduler scheduler]]
      takeUntil:self.rac_willDeallocSignal]
     subscribeNext:^(id x) {
         @strongify(self);
         self.stayDuration += interval;
     }];
}

- (void)setPlayer:(YCAVPlayerView *)player {
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

- (void)setVideoCurrTimePoint:(NSTimeInterval)currTimePoint {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSTimeInterval interval = 0;
        if (currTimePoint > self.currTimePoint) {
            interval = currTimePoint - self.currTimePoint;
            self.currTimePoint = currTimePoint;
        }
        if (self.isPlaying) {
            self.watchedDuration += interval;
        }
        if ([self.callbacks respondsToSelector:@selector(player:onPlayingCurrTime:isPause:)]) {
            [self.callbacks player:self.player onPlayingCurrTime:self.currTimePoint isPause:self.isPlaying];
        }
    });
}

- (void)seekToTime:(NSTimeInterval)timePoint {
    self.currTimePoint = timePoint;
    self.isPlaying = NO;
    dispatch_async(dispatch_get_main_queue(), ^{
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
    });
}

- (void)videoReadyToPlay {
    self.isPlaying = !self.props.isPause;
    if (self.readyToPlay) return;
    // 只记录第一次
    self.readyToPlay = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.callbacks respondsToSelector:@selector(playerOnReadyToPlay:)]) {
            [self.callbacks playerOnReadyToPlay:self.player];
        }
    });
}

- (void)videoPlayFinishedByInterrupt:(BOOL)interrupt {
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

@end
