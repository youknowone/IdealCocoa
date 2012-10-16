//
//  ICCacheStorage.m
//  IdealCocoa
//
//  Created by youknowone on 12. 2. 11..
//  Copyright (c) 2012 youknowone.org All rights reserved.
//

#import "ICCacheStorage.h"

@implementation ICCacheStorage
@synthesize dataStorage=_dataStorage;

- (id)initWithStorage:(ICStorage *)storage {
    self = [super init];
    if (self != nil) {
        self.dataStorage = storage;
    }
    return self;
}

+ (id)cacheStorageWithStorage:(ICStorage *)dataStorage {
    return [[[self alloc] initWithStorage:dataStorage] autorelease];
}

- (void)dealloc {
    self.dataStorage = nil;
    [super dealloc];
}

- (void)setData:(NSData *)data forKey:(NSString *)key {
    [self.dataStorage setData:data forKey:key];
}

- (void)setData:(NSData *)data forKey:(NSString *)key inGroup:(NSString *)group {
    [self.dataStorage setData:data forKey:key];
    [self.dataStorage setMetaData:group forMetaKey:@"group" forDataKey:key];
}

- (void)setData:(NSData *)data forKey:(NSString *)key before:(NSDate *)limit {
    [self.dataStorage setData:data forKey:key];
    [self.dataStorage setMetaData:limit forMetaKey:@"doomsday" forDataKey:key];
}

- (NSData *)dataForKey:(NSString *)key {
    return [self.dataStorage dataForKey:key];
}

- (NSDictionary *)dataDictionrayInGroup:(NSString *)group {
    return [self.dataStorage dictionaryWithValuesForKeys:[self.dataStorage keyArrayForMetaValue:group forMetaKey:@"group"]];
}

- (void)removeDataForKey:(NSString *)key {
    [self.dataStorage removeDataForKey:key];
}

- (void)removeAllDataInGroup:(NSString *)group {
    NSArray *keys = [self.dataStorage keyArrayForMetaValue:group forMetaKey:@"group"];
    for (NSString *key in keys) {
        [self removeDataForKey:key];
    }
}

- (void)removeAllDataBeforeNow {
    [self removeAllDataBeforeDate:[NSDate date]];
}

- (void)removeAllDataBeforeDate:(NSDate *)date {
    NSDictionary *keyArrayGroup = [self.dataStorage keyArrayGroupForMetaKey:@"doomsday"];
    for (NSDate *key in keyArrayGroup.keyEnumerator) {
        if ([date compare:key] == NSOrderedDescending) {
            NSArray *keyArray = [keyArrayGroup objectForKey:key];
            [self.dataStorage removeDatasetForKeys:keyArray];
        }
    }
}

- (void)removeAllData {
    [self.dataStorage removeAllData];
}

- (void)synchronize {
    [self.dataStorage synchronize];
}

#pragma mark -

- (void)request:(ICCacheRequest *)request didCachedData:(NSData *)data {
    [self setData:data forKey:[request.userInfo objectForKey:@"key"]];
}

- (void)request:(ICCacheRequest *)request didFailedRequestForError:(NSError *)error {
    
}

@end

#import "ICCacheRequest.h"

@implementation ICCacheStorage (ICCacheRequest)

- (ICCacheRequest *)requestWithURL:(NSURL *)URL {
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:URL.absoluteString forKey:@"key"];
    return [ICCacheRequest requestWithURL:URL delegate:self userInfo:userInfo];
}

- (ICCacheRequest *)requestWithURL:(NSURL *)URL group:(NSString *)groupName {
    return [ICCacheRequest requestWithURL:URL delegate:self userInfo:groupName];
}

- (ICCacheRequest *)requestWithURL:(NSURL *)URL doosday:(NSDate *)doomsday {
    return [ICCacheRequest requestWithURL:URL delegate:self userInfo:doomsday];
}

- (ICCacheRequest *)requestWithURL:(NSURL *)URL life:(NSTimeInterval)lifeInterval {
    return [ICCacheRequest requestWithURL:URL delegate:self userInfo:[NSDate dateWithTimeIntervalSinceNow:lifeInterval]];
}

@end