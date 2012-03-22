//
//  NSArrayAdditions.h
//  IdealCocoa
//
//  Created by youknowone on 11. 1. 25..
//  Copyright 2011 3rddev.org. All rights reserved.
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

@interface NSArray (IdealCocoaCreation)

- (id)initWithData:(NSData *)data;
+ (id)arrayWithData:(NSData *)data;

- (id)initWithData:(NSData *)data options:(NSPropertyListReadOptions)opt format:(NSPropertyListFormat *)format error:(NSError **)error;// NS_AVAILABLE(10_6, 4_0);
+ (id)arrayWithData:(NSData *)data options:(NSPropertyListReadOptions)opt format:(NSPropertyListFormat *)format error:(NSError **)error;// NS_AVAILABLE(10_6, 4_0);
- (id)initWithEnumerator:(NSEnumerator *)enumerator;
+ (id)arrayWithEnumerator:(NSEnumerator *)enumerator;

- (id)initWithContentsOfURLRequest:(NSURLRequest *)request;
+ (id)arrayWithContentsOfURLRequest:(NSURLRequest *)request;

- (id)initWithContentsOfURLRequest:(NSURLRequest *)request options:(NSPropertyListReadOptions)opt format:(NSPropertyListFormat *)format error:(NSError **)error;
+ (id)arrayWithContentsOfURLRequest:(NSURLRequest *)request options:(NSPropertyListReadOptions)opt format:(NSPropertyListFormat *)format error:(NSError **)error;

@end

@interface NSArray (IdealCocoaPremitive)

- (NSInteger)integerAtIndex:(NSUInteger)index;
- (NSUInteger)indexOfInteger:(NSInteger)value;

@end

@interface NSMutableArray (IdealCocoaPremitive)

- (void)addInteger:(NSInteger)value;
- (void)insertInteger:(NSInteger)value atIndex:(NSUInteger)index;

@end