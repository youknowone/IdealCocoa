//
//  ICCache.h
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

+ (NSData *)cachedDataWithContentOfAbstractPath:(NSString *)path __ICTESTING;


+ (ICCacheStorage *)defaultStorageForOptions:(ICCacheOptions)options;

@end


@interface NSData (ICCache)

+ (NSData *)cachedDataWithContentOfURL:(NSURL *)URL options:(ICCacheOptions)options;
+ (NSData *)cachedDataWithContentOfAbstractPath:(NSString *)path __ICTESTING;

@end
