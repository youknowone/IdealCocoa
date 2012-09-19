//
//  ICCacheRequest.m
//  IdealCocoa
//
//  Created by youknowone on 12. 2. 10..
//  Copyright (c) 2012 youknowone.org. All rights reserved.
//

#import "ICCacheRequest.h"

@interface ICCacheRequest ()

- (void)notifyFailedWithError:(NSError *)error;
- (void)notifySuccessWithData:(NSData *)data;

@end

@implementation ICCacheRequest
@synthesize URL=_URL, trialCount=_trialCount, delegate=_delegate, userInfo=_userInfo;

NSMutableDictionary *ICCacheRequestDictionary = nil;

- (id)initWithURL:(NSURL *)URL delegate:(id)delegate userInfo:(id)userInfo {
    self = [super init];
    if (self != nil) {
        self->_URL = URL.copy;
        self->_delegate = delegate;
        self.userInfo = userInfo;
    }
    return self;
}

+ (id)requestWithURL:(NSURL *)URL delegate:(id)delegate userInfo:(id)userInfo {
    return [[[self alloc] initWithURL:URL delegate:delegate userInfo:userInfo] autorelease];
}

- (void)dealloc {
    self.userInfo = nil;
    [self->_URL release];
    [super dealloc];
}

- (NSData *)request {
    self->_trialCount += 1;
    NSError *error = nil;
    NSData *data = [NSData dataWithContentsOfURL:self.URL options:0 error:&error];
    if (error != nil) {
        [self performSelectorOnMainThread:@selector(notifyFailedWithError:) withObject:error waitUntilDone:NO];
        return nil;
    }
    
    [self performSelectorOnMainThread:@selector(notifySuccessWithData:) withObject:data waitUntilDone:NO];
    return data;
}

- (void)requestInBackgroundCollector {
    [[ICCacheCollector sharedCollector] addRequest:self];
}

- (void)notifyFailedWithError:(NSError *)error {
    [self.delegate request:self didFailedRequestForError:error];
}

- (void)notifySuccessWithData:(NSData *)data {
    [self.delegate request:self didCachedData:data];
}

@end

@interface ICCacheCollector ()

- (void)startCollecting;
- (void)stopCollecting;

@end

@implementation ICCacheCollector
@synthesize isCollecting=_isCollecting;

ICCacheCollector *ICCacheSharedCollector;

+ (void)initialize {
    if (self == [ICCacheCollector class]) {
        ICCacheSharedCollector = [[self alloc] init];
    }
}

+ (ICCacheCollector *)sharedCollector {
    return ICCacheSharedCollector;
}

- (id)init {
    if ((self = [super init]) != nil) {
        self->_thread = [[NSThread alloc] initWithTarget:self selector:@selector(collectingLoop) object:nil];
        queue = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc {
    [self stopCollecting];
    while (self.isCollecting) { }
    [queue release];
    [super dealloc];
}

- (void)startCollecting {
    if (!self.isCollecting) {
        [self->_thread start];
    }
}

- (void)stopCollecting {
    if (self.isCollecting) {
        self->_stopFlag = YES;
    }
}

- (void)collectingLoop {
    if (self->_isCollecting == YES) return;
    self->_isCollecting = YES;
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    while (!self->_stopFlag && queue.count > 0) {
        // dequeue one
        ICCacheRequest *request = [queue objectAtIndex:0];
        [self removeRequest:request];
        
        // try to get
        NSData *data = [request request];
        if (data == nil) {
            if (request.trialCount < 4) {
                [self addRequest:request];
                continue;
            }
            // else give up now
        }
    }
    [pool release];
    self->_isCollecting = NO;
    self->_stopFlag = NO;
}

- (ICCacheRequest *)queuedRequestForURL:(NSURL *)URL; {
    return [self->queueMap objectForKey:URL.absoluteString];
}

- (void)addRequest:(ICCacheRequest *)request {
    [self->queue addObject:request];
    [self->queueMap setObject:request forKey:request.URL.absoluteString];
    if (!self->_isCollecting) {
        [self->_thread start];
    }
}

- (void)removeRequest:(ICCacheRequest *)request {
    [self->queue removeObject:request];
    [self->queueMap removeObjectForKey:request.URL.absoluteString];
}

@end


