//
//  ICCacheStorage.h
//  IdealCocoa
//
//  Created by youknowone on 12. 2. 11..
//  Copyright (c) 2012 youknowone.org All rights reserved.
//

//  ICCacheStorage provides common storage interface for data cache.

#import <IdealCocoa/ICStorage.h>
#import <IdealCocoa/ICCacheRequest.h>

@interface ICCacheStorage: NSObject<ICCacheRequestDelegate> {
    ICStorage *_dataStorage;
}
@property(nonatomic, retain) ICStorage *dataStorage;

- (id)initWithStorage:(ICStorage *)dataStorage;
+ (id)cacheStorageWithStorage:(ICStorage *)dataStorage;

- (void)setData:(NSData *)data forKey:(NSString *)key;
- (void)setData:(NSData *)data forKey:(NSString *)key inGroup:(NSString *)group;
- (void)setData:(NSData *)data forKey:(NSString *)key before:(NSDate *)limit;
- (NSData *)dataForKey:(NSString *)key;
- (NSDictionary *)dataDictionrayInGroup:(NSString *)group;
- (void)removeDataForKey:(NSString *)key;
- (void)removeAllDataInGroup:(NSString *)group;
- (void)removeAllDataBeforeNow;
- (void)removeAllDataBeforeDate:(NSDate *)date;
- (void)removeAllData;

- (void)synchronize;

@end

@class ICCacheRequest;
@interface ICCacheStorage (ICCacheRequest)

- (ICCacheRequest *)requestWithURL:(NSURL *)URL;
- (ICCacheRequest *)requestWithURL:(NSURL *)URL group:(NSString *)groupName;
- (ICCacheRequest *)requestWithURL:(NSURL *)URL doosday:(NSDate *)doomsday;
- (ICCacheRequest *)requestWithURL:(NSURL *)URL life:(NSTimeInterval)lifeInterval;

@end
