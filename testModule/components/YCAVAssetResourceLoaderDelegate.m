//
//  YCAVAssetResourceLoaderDelegate.m
//  testModule
//
//  Created by fuhan on 2017/5/25.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import "YCAVAssetResourceLoaderDelegate.h"

NSString *localStringFromRemoteString(NSString *remoteURLString) {
    NSURLComponents *components = [[NSURLComponents alloc] initWithString:remoteURLString];
    NSArray *paths = [components.path componentsSeparatedByString:@"/"];
    NSString *fileName = paths[paths.count - 1];
    return [fileName stringByReplacingOccurrencesOfString:@".ts" withString:@".data"];
}

@interface AssetResponse : NSObject

@property (nonatomic, assign) BOOL finished;
@property (nonatomic, strong) AVAssetResourceLoadingRequest *loadingRequest;
@property (nonatomic, strong) NSURLResponse *response;
@property (nonatomic, strong) NSMutableData *data;

@end

@implementation AssetResponse

@end

//////////////////////////////////////////////////////

@interface YCAVAssetResourceLoaderDelegate ()

@property (nonatomic, strong) NSString *urlScheme;
@property (nonatomic, strong) NSString *cacheRootPath;
@property (nonatomic, strong) NSMutableDictionary *pendingRequests;
@property (nonatomic, strong) NSMutableSet *cachedFragments;

@end

@implementation YCAVAssetResourceLoaderDelegate

- (instancetype)initWithURL:(NSString *)url {
    if (self = [super init]) {
        static NSString *tmpFolder = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            tmpFolder = NSTemporaryDirectory();
            tmpFolder = [tmpFolder stringByAppendingPathComponent:@"fragmentCache"];
            if (![[NSFileManager defaultManager] fileExistsAtPath:tmpFolder]) {
                [[NSFileManager defaultManager] createDirectoryAtPath:tmpFolder
                                          withIntermediateDirectories:YES
                                                           attributes:nil
                                                                error:NULL];
            }
        });
        
        NSURLComponents *components = [[NSURLComponents alloc] initWithString:url];
        self.urlScheme = components.scheme;
        // cacheRootPath
        NSArray *paths = [components.path componentsSeparatedByString:@"/"];
        NSString *identity = paths[paths.count - 1];
        self.cacheRootPath = [tmpFolder stringByAppendingPathComponent:identity];
        if (![[NSFileManager defaultManager] fileExistsAtPath:self.cacheRootPath]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:self.cacheRootPath
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:NULL];
        }
        self.cachedFragments = [NSMutableSet setWithArray:[[NSFileManager defaultManager]
                                                           contentsOfDirectoryAtPath:self.cacheRootPath error:nil]];
        self.pendingRequests = [[NSMutableDictionary alloc] initWithCapacity:128];
    }
    return self;
}

- (NSString *)getCacheFolder {
    return self.cacheRootPath;
}

#pragma mark - AVURLAsset resource loading

- (void)processPendingRequestsForResponse:(AssetResponse *)assetResponse request:(NSURLRequest *)request {
    BOOL didRespondCompletely = [self respondWithDataForRequest:assetResponse];
    
    if (didRespondCompletely) {
        NSLog(@"Completed %@", request.URL.absoluteString);
        [assetResponse.loadingRequest finishLoading];
        [self.pendingRequests removeObjectForKey:request];
    }
}

- (void)fillInContentInformation:(AVAssetResourceLoadingContentInformationRequest *)contentInformationRequest
                        response:(NSURLResponse *)response {
//    if (contentInformationRequest == nil || response == nil) {
//        return;
//    }
    if (response == nil) {
        return;
    }
    
    contentInformationRequest.byteRangeAccessSupported = YES; // NO
    contentInformationRequest.contentType = [response MIMEType];
    contentInformationRequest.contentLength = [response expectedContentLength];
}

- (BOOL)respondWithDataForRequest:(AssetResponse *)assetResponse {
    AVAssetResourceLoadingDataRequest *dataRequest = assetResponse.loadingRequest.dataRequest;
    long long startOffset = dataRequest.requestedOffset;
    if (dataRequest.currentOffset != 0) {
        startOffset = dataRequest.currentOffset;
    }
    
    // Don't have any data at all for this request
    if (assetResponse.data.length < startOffset
        || !assetResponse.finished) {
        return NO;
    }
    
    // This is the total data we have from startOffset to whatever has been downloaded so far
    NSUInteger unreadBytes = assetResponse.data.length - (NSUInteger)startOffset;
    
    // Respond with whatever is available if we can't satisfy the request fully yet
    NSUInteger numberOfBytesToRespondWith = MIN((NSUInteger)dataRequest.requestedLength, unreadBytes);
    
    [dataRequest respondWithData:[assetResponse.data
                                  subdataWithRange:NSMakeRange((NSUInteger)startOffset, numberOfBytesToRespondWith)]];
    
    long long endOffset = startOffset + dataRequest.requestedLength;
    BOOL didRespondFully = assetResponse.data.length >= endOffset;
    
    NSLog(@"%@ - Requested %lli to %li, have %li", assetResponse.loadingRequest.request.URL.absoluteString, dataRequest.currentOffset, (long)dataRequest.requestedLength, (unsigned long)assetResponse.data.length);
    
    // dataRequest.requestedLength数据不准，暂时不用
//    return didRespondFully || assetResponse.finished;
    return assetResponse.finished;
}


- (BOOL)resourceLoader:(AVAssetResourceLoader *)resourceLoader shouldWaitForLoadingOfRequestedResource:(AVAssetResourceLoadingRequest *)loadingRequest {
    NSLog(@">>> shouldWaitForLoadingOfRequestedResource %@ - %ld", loadingRequest.request.URL.absoluteString, loadingRequest.dataRequest.requestedLength);
    // start downloading the fragment.
    NSURL *interceptedURL = [loadingRequest.request URL];
    
    NSURLComponents *actualURLComponents = [[NSURLComponents alloc] initWithURL:interceptedURL resolvingAgainstBaseURL:NO];
    
    NSString *localFile = localStringFromRemoteString(actualURLComponents.URL.absoluteString);
    if ([self.cachedFragments containsObject:localFile] && [localFile hasSuffix:@".data"]) {
        NSData *fileData = [[NSFileManager defaultManager] contentsAtPath:[self.cacheRootPath
                                                                           stringByAppendingPathComponent:localFile]];
        loadingRequest.contentInformationRequest.contentLength = fileData.length;
        loadingRequest.contentInformationRequest.contentType = @"video/mpegts"; // @"video/mp2t";
        loadingRequest.contentInformationRequest.byteRangeAccessSupported = YES;
        NSRange range = NSMakeRange(loadingRequest.dataRequest.requestedOffset,
                                    MIN(loadingRequest.dataRequest.requestedLength, fileData.length));
        [loadingRequest.dataRequest respondWithData:[fileData subdataWithRange:range]];
        [loadingRequest finishLoading];
        NSLog(@"Responded with cached data for %@", actualURLComponents.URL.absoluteString);
        return YES;
    }
    
    NSMutableURLRequest* mutableRequest = [loadingRequest.request mutableCopy];
    mutableRequest.URL = [[NSURL alloc] initWithScheme:self.urlScheme
                                                  host:mutableRequest.URL.host
                                                  path:mutableRequest.URL.path];
    // TODO: cache setting, NSURLRequestReloadIgnoringCacheData
    // TODO: replace
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:mutableRequest
                                                                  delegate:self
                                                          startImmediately:NO];
    [connection setDelegateQueue:[NSOperationQueue mainQueue]];
    [connection start];
    

    AssetResponse *assetResponse = [AssetResponse new];
    assetResponse.data = [NSMutableData new];
    assetResponse.loadingRequest = loadingRequest;
    
    [self.pendingRequests setObject:assetResponse forKey:mutableRequest];
    
    return YES;
}

- (BOOL)resourceLoader:(AVAssetResourceLoader *)resourceLoader shouldWaitForRenewalOfRequestedResource:(AVAssetResourceRenewalRequest *)renewalRequest {
    NSLog(@"shouldWaitForRenewalOfRequestedResource %@", renewalRequest.request.URL.absoluteString);
    return YES;
}

- (void)resourceLoader:(AVAssetResourceLoader *)resourceLoader didCancelLoadingRequest:(AVAssetResourceLoadingRequest *)loadingRequest {
    NSLog(@"Resource request cancelled for %@", loadingRequest.request.URL.absoluteString);
    NSURLConnection *connectionForRequest = nil;
    NSEnumerator *enumerator = self.pendingRequests.keyEnumerator;
    BOOL found = NO;
    while ((connectionForRequest = [enumerator nextObject]) && !found) {
        AssetResponse *assetResponse = [self.pendingRequests objectForKey:connectionForRequest];
        if (assetResponse.loadingRequest == loadingRequest) {
            [connectionForRequest cancel];
            found = YES;
        }
    }
    
    if (found) {
        [self.pendingRequests removeObjectForKey:connectionForRequest];
    }
}

#pragma mark - NSURLConnection delegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    AssetResponse *assetResponse = [self.pendingRequests objectForKey:connection.originalRequest];
    assetResponse.response = response;
    assetResponse.loadingRequest.response = response;
    [self fillInContentInformation:assetResponse.loadingRequest.contentInformationRequest response:assetResponse.response];
    [self processPendingRequestsForResponse:assetResponse request:connection.originalRequest];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    AssetResponse *assetResponse = [self.pendingRequests objectForKey:connection.originalRequest];
    [assetResponse.data appendData:data];
    // TODO: 不下载完也应该set datarequest
    [self processPendingRequestsForResponse:assetResponse request:connection.originalRequest];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    AssetResponse *assetResponse = [self.pendingRequests objectForKey:connection.originalRequest];
    assetResponse.finished = YES;
    [self processPendingRequestsForResponse:assetResponse request:connection.originalRequest];
    
    NSString *localName = localStringFromRemoteString(assetResponse.response.URL.absoluteString);
    NSString *cachedFilePath = [self.cacheRootPath stringByAppendingPathComponent:localName];
    if ([cachedFilePath hasSuffix:@".data"]) {
        // TODO: async to write
        [self.cachedFragments addObject:localName];
        [assetResponse.data writeToFile:cachedFilePath atomically:YES];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"todo: finishLoadingWithError");
}

@end
