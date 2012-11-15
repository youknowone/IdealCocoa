//
//  ICCache.m
//  IdealCocoa
//
//  Created by youknowone on 10. 8. 17..
//  Copyright 2010 3rddev.org. All rights reserved.
//

#define CACHE_DEBUG FALSE

#include <unistd.h>

#import "ICPreference.h"
#import "ICCache.h"
#import "ICStorage.h"
// TODO: rewrite to divide life-cycle and collector
@implementation ICCache

+ (BOOL)isCachedURL:(NSURL *)URL options:(ICCacheOptions)options {
    return [self isCachedURL:URL storage:[self defaultStorageForOptions:options]];
}

+ (BOOL)isCachedURL:(NSURL *)URL storage:(ICCacheStorage *)storage {
    NSString *key = URL.absoluteString;
    return [storage dataForKey:key] != nil;
}

+ (NSData *)cachedDataWithContentOfURL:(NSURL *)URL options:(ICCacheOptions)options {
    return [self cachedDataWithContentOfURL:URL storage:[self defaultStorageForOptions:options]];
}

+ (NSData *)cachedDataWithContentOfURL:(NSURL *)URL storage:(ICCacheStorage *)storage {
    NSData *data = [storage dataForKey:URL.absoluteString];
    if (data == nil) {
        data = [[storage requestWithURL:URL] request];
    }
    return data;
}

+ (NSData *)cachedDataWithContentOfAbstractPath:(NSString *)path {
    dlog(CACHE_DEBUG, @"abstract data load: %@", path);
    if ( [path hasURLPrefix] ) {
        dlog(CACHE_DEBUG, @"remote data");
        return [self cachedDataWithContentOfURL:[NSURL URLWithString:path] options:ICCacheOptionDisk|ICCacheOptionPermanent];
    } else {
        dlog(CACHE_DEBUG, @"local data");
        return [NSData dataWithContentsOfAbstractPath:path];
    }
}

ICCacheStorage *ICCacheDefaultStorages[16] = { nil, };

+ (void)initialize {
    if (self == [ICCache class]) {
        {   // 1
            ICCacheStorage *cacheStorage = [[ICCacheStorage alloc] initWithStorage:[ICMemoryStorage storage]];
            ICCacheDefaultStorages[ICCacheOptionMemory] = cacheStorage;
        }
        {   // 2
            ICCacheStorage *cacheStorage = [[ICCacheStorage alloc] initWithStorage:[ICDiskStorage storageWithBaseDirectory:@"runtimediskcache"]];
            ICCacheDefaultStorages[ICCacheOptionDisk] = cacheStorage;
        }
        {   // 3
            ICCacheStorage *cacheStorage = [[ICCacheStorage alloc] initWithStorage:[ICDiskStorage storageWithBaseDirectory:@"runtimememdiskcache" secondaryCacheStorage:[ICMemoryStorage storage]]];
            ICCacheDefaultStorages[ICCacheOptionDisk|ICCacheOptionMemory] = cacheStorage;
        }
        {   // 5
            ICCacheStorage *cacheStorage = [[ICCacheStorage alloc] initWithStorage:[ICUserDefaultsStorage storageWithUserDefaults:[NSUserDefaults standardUserDefaults] baseKey:@"memcache"]];
            ICCacheDefaultStorages[ICCacheOptionPermanent|ICCacheOptionDisk] = cacheStorage;
        }
        {   // 6
            ICCacheStorage *cacheStorage = [[ICCacheStorage alloc] initWithStorage:[ICDiskStorage storageWithBaseDirectory:@"diskcache"]];
            ICCacheDefaultStorages[ICCacheOptionPermanent|ICCacheOptionDisk] = cacheStorage;
        }
        {   // 7
            ICCacheStorage *cacheStorage = [[ICCacheStorage alloc] initWithStorage:[ICDiskStorage storageWithBaseDirectory:@"memdiskcache" secondaryCacheStorage:[ICMemoryStorage storage]]];
            ICCacheDefaultStorages[ICCacheOptionPermanent|ICCacheOptionDisk|ICCacheOptionMemory] = cacheStorage;
        }
    }
}

+ (ICCacheStorage *)defaultStorageForOptions:(ICCacheOptions)options {
    options &= ~ICCacheOptionIgnoreFull; // ignore this option
    return ICCacheDefaultStorages[options];
}

@end

@implementation NSData (ICCache)

+ (NSData *) cachedDataWithContentOfURL:(NSURL *)URL options:(ICCacheOptions)options {
    return [ICCache cachedDataWithContentOfURL:URL options:options];
}

+ (NSData *)cachedDataWithContentOfAbstractPath:(NSString *)path {
    return [ICCache cachedDataWithContentOfAbstractPath:path];
}

@end

