//
//  ICCacheRequest.h
//  IdealCocoa
//
//  Created by youknowone on 12. 2. 10..
//  Copyright (c) 2012년 youknowone.org. All rights reserved.
//

@class ICCacheRequest;
@protocol ICCacheRequestDelegate<NSObject>

- (void)request:(ICCacheRequest *)request didCachedData:(NSData *)data;
- (void)request:(ICCacheRequest *)request didFailedRequestForError:(NSError *)error;

@end

@interface ICCacheRequest: NSObject {
    NSURL *_URL;
    NSInteger _trialCount;
    id<ICCacheRequestDelegate> _delegate;
    id _userInfo;
}

@property(nonatomic, readonly) NSURL *URL;
@property(nonatomic, readonly) NSInteger trialCount;
@property(nonatomic, assign) id<ICCacheRequestDelegate> delegate;
@property(nonatomic, retain) id userInfo;

- (id)initWithURL:(NSURL *)URL delegate:(id)delegate userInfo:(id)userInfo;
+ (id)requestWithURL:(NSURL *)URL delegate:(id)delegate userInfo:(id)userInfo;

// synced request
- (NSData *)request;
// async request
- (void)requestInBackgroundCollector;

@end

@interface ICCacheCollector : NSObject
{
    NSMutableArray *queue;
    NSMutableDictionary *queueMap;
    NSThread *_thread;
    
    BOOL _isCollecting, _stopFlag;
}
@property(nonatomic, readonly) BOOL isCollecting;

+ (ICCacheCollector *)sharedCollector;

- (void)addRequest:(ICCacheRequest *)request;
- (void)removeRequest:(ICCacheRequest *)request;
- (ICCacheRequest *)queuedRequestForURL:(NSURL *)URL;

@end