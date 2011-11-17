//
//  ICCache.m
//  IdealCocoa
//
//  Created by youknowone on 10. 8. 17..
//  Copyright 2010 3rddev.org. All rights reserved.
//
//	This program is free software: you can redistribute it and/or modify
//	it under the terms of the GNU General Public License as published by
//	the Free Software Foundation, either version 3 of the License, or
//	(at your option) any later version.
//	
//	This program is distributed in the hope that it will be useful,
//	but WITHOUT ANY WARRANTY; without even the implied warranty of
//	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//	GNU General Public License for more details.
//	
//	You should have received a copy of the GNU General Public License
//	along with this program.  If not, see <http://www.gnu.org/licenses/>.
//

#define CACHE_DEBUG FALSE

#include <unistd.h>
#import "NSBundleAdditions.h"
#import "NSURLAdditions.h"
#import "NSDataAdditions.h"
#import "NSPathUtilitiesAddtions.h"
#import "ICCrypto.h"
#import "ICPreference.h"
#import "ICCache.h"

@interface ICCacheCollector : NSObject
{
  @public
	NSMutableArray *queue;
}

- (BOOL)collectItem:(NSString *)path;

@end

@implementation ICCacheCollector

- (id)init {
	if ((self = [super init]) != nil) {
		queue = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void)dealloc {
	[queue release];
	[super dealloc];
}

- (BOOL)collectItem:(NSString *)path {
	return [ICCache cachedDataWithContentOfAbstractPath:path] != nil;
}

- (void)collectItems {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSMutableDictionary *invalidItems = [[NSMutableDictionary alloc] init];
	while ( TRUE ) {
		while ( [queue count] > 0 ) {
			id item = [queue objectAtIndex:0];
			ICLog(CACHE_DEBUG, @"trying to collect one: %@", item);
			if ( ![self collectItem:item] ) {
   				[queue addObject:item];
                if ([[invalidItems allKeys] indexOfObject:item] != NSNotFound) {
                    [invalidItems setObject:[NSNumber numberWithInteger:0] forKey:item];
                } else {
                    NSNumber *number = [invalidItems objectForKey:item];
                    if ([number integerValue] > 3) {
                        [queue removeLastObject];
                        [invalidItems removeObjectForKey:item];
                    } else {
                        [invalidItems setObject:[NSNumber numberWithInteger:[number integerValue] + 1] forKey:item];
                    }
                }
				ICLog(CACHE_DEBUG, @"but failed");
			}
			[queue removeObjectAtIndex:0];
            if ([invalidItems objectForKey:item] != nil) {
                [invalidItems removeObjectForKey:item];
            }
       		usleep(200000);
		}
		usleep(300000);
	}
    [invalidItems release];
	[pool release];
}

@end

// TODO: rewrite to divide life-cycle and collector
@implementation ICCache

ICPreference *permanentCache;
ICCacheCollector *collector;
NSThread *collectorThread;

+ (void)initialize {
	if ( self == [ICCache class] ) {
		permanentCache = [[ICPreference alloc] initWithContentsOfFile:NSPathForUserConfigurationFile(@"PermanentCache.plist")];
		collector = [[ICCacheCollector alloc] init];
		collectorThread = [[NSThread alloc] initWithTarget:collector selector:@selector(collectItems) object:nil];
		[collectorThread start];
	}
}

+ (BOOL) isExists:(NSString *)path {
	NSString *prefix = @"http://";
	if ( [[path substringToIndex:[prefix length]] isEqualToString:prefix] ) {
		NSString *hashkey = [path digestStringByMD5];
		ICPreference *cache = permanentCache;
		NSString *cachedPath = [cache.attributes objectForKey:hashkey];
		if ( nil == cachedPath || ![cachedPath isEqualToString:path] ) {
			return NO;
		}
		return YES;
	} else {
		return YES;
	}
}

+ (void)addPathToAsyncronizedCollector:(NSString *)path {
	if ( [ICCache isExists:path] ) return;
	if ( [collector->queue indexOfObject:path] != NSNotFound ) return;
	[collector->queue addObject:path];
}

+ (NSData *)cachedDataWithContentOfURLString:(NSString *)path cachePolicy:(ICCachePolicy)policy {
	assert( policy == ICCachePolicyPermanently );
	NSString *hashkey = [path digestStringByMD5];
	NSString *hashPath = NSPathForUserConfigurationFile([hashkey stringByAppendingString:@".cache"]);
	ICPreference *cache = permanentCache;
	NSString *cachedPath = [cache.attributes objectForKey:hashkey];
	if ( nil == cachedPath || ![cachedPath isEqualToString:path] ) {
		NSError *error = nil;
		NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:path] options:0 error:&error];
		if ( error == nil ) {
			[data writeToFile:hashPath atomically:YES];
			[cache.attributes setObject:path forKey:hashkey];
			[cache writeToFile];
		} else {
			ICLog(CACHE_DEBUG, @"Cannot connect to service: %@", error);
			return nil;
		}
	}
	return [NSData dataWithContentsOfFile:hashPath];	
}

+ (NSData *)cachedDataWithContentOfAbstractPath:(NSString *)path {
	ICLog(CACHE_DEBUG, @"abstract data load: %@", path);
	if ( [path hasURLPrefix] ) {
		ICLog(CACHE_DEBUG, @"remote data");
		return [self cachedDataWithContentOfURLString:path cachePolicy:ICCachePolicyPermanently];
	} else {
		ICLog(CACHE_DEBUG, @"local data");
		return [NSData dataWithContentsOfAbstractPath:path];
	}
}

+ (NSMutableDictionary *)hashDictionary {
	ICPreference *cache = permanentCache;
	return cache.attributes;
}

@end

@implementation NSData (ICCache)

+ (NSData *) cachedDataWithContentOfURLString:(NSString *)path cachePolicy:(ICCachePolicy)policy {
	return [ICCache cachedDataWithContentOfURLString:path cachePolicy:policy];
}

+ (NSData *)cachedDataWithContentOfAbstractPath:(NSString *)path {
	return [ICCache cachedDataWithContentOfAbstractPath:path];
}

@end

