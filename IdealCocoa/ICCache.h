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

typedef enum {
	//ICCachePolicyAutomatic	= 0, // not implemented yet
	//ICCachePolicyNever		= 0x10,
	ICCachePolicyPermanently= 0x20,
	//ICCachePolicyRuntime	= 0x30,
	//ICCachePolicyTimer		= 0x10000000,
}	ICCachePolicy;

@class ICPreference;
@interface ICCache: NSObject {
	ICPreference *cachePreference;
}

+ (BOOL)isExists:(NSString *)path __ICTESTING;
+ (void)addPathToAsyncronizedCollector:(NSString *)path __ICTESTING;

+ (NSData *)cachedDataWithContentOfURLString:(NSString *)path cachePolicy:(ICCachePolicy)policy;
+ (NSData *)cachedDataWithContentOfAbstractPath:(NSString *)path __ICTESTING;

+ (NSMutableDictionary *)hashDictionary;

@end

@interface NSData (ICCache)

+ (NSData *)cachedDataWithContentOfURLString:(NSString *)path cachePolicy:(ICCachePolicy)policy;
+ (NSData *)cachedDataWithContentOfAbstractPath:(NSString *)path __ICTESTING;

@end
