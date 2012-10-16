//
//  ICCache.h
//  IdealCocoa
//
//  Created by youknowone on 10. 8. 17..
//  Copyright 2010 3rddev.org. All rights reserved.
//

enum {
    ICCacheOptionMemory     = 1 << 0,
    ICCacheOptionDisk       = 1 << 1,
	ICCacheOptionPermanent  = 1 << 2,
    ICCacheOptionIgnoreFull = 1 << 3,
};
typedef NSUInteger ICCacheOptions;

#import <IdealCocoa/ICCacheStorage.h>

@interface ICCache: NSObject 

+ (BOOL)isCachedURL:(NSURL *)URL storage:(ICCacheStorage *)storage;
+ (BOOL)isCachedURL:(NSURL *)URL options:(ICCacheOptions)options;

+ (NSData *)cachedDataWithContentOfURL:(NSURL *)URL storage:(ICCacheStorage *)storage;
+ (NSData *)cachedDataWithContentOfURL:(NSURL *)URL options:(ICCacheOptions)options;

+ (NSData *)cachedDataWithContentOfAbstractPath:(NSString *)path __deprecated;


+ (ICCacheStorage *)defaultStorageForOptions:(ICCacheOptions)options;

@end


@interface NSData (ICCache)

+ (NSData *)cachedDataWithContentOfURL:(NSURL *)URL options:(ICCacheOptions)options;
+ (NSData *)cachedDataWithContentOfAbstractPath:(NSString *)path __deprecated;

@end
