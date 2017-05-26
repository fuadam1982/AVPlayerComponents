//
//  YCAVAssetResourceLoaderDelegate.h
//  testModule
//
//  Created by fuhan on 2017/5/25.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import <Foundation/Foundation.h>
@import AVFoundation;

@interface YCAVAssetResourceLoaderDelegate : NSObject<AVAssetResourceLoaderDelegate>

- (instancetype)initWithURL:(NSString *)url;
- (NSString *)getCacheFolder;

@end
