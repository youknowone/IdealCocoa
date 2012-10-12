//
//  NSDictionaryAdditions.h
//  IdealCocoa
//
//  Created by youknowone on 11. 1. 24..
//  Copyright 2011 3rddev.org. All rights reserved.
//
//	This program is free software: you can redistribute it and/or modify
//	it under the terms of the GNU Lesser General Public License as published by
//	the Free Software Foundation, either version 3 of the License, or
//	(at your option) any later version.
//	
//	This program is distributed in the hope that it will be useful,
//	but WITHOUT ANY WARRANTY; without even the implied warranty of
//	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//	GNU Lesser General Public License for more details.
//	
//	You should have received a copy of the GNU Lesser General Public License
//	along with this program.  If not, see <http://www.gnu.org/licenses/>.
//

@interface NSDictionary (IdealCocoa)

- (id)initWithData:(NSData *)data;
+ (id)dictionaryWithData:(NSData *)data;

- (id)initWithData:(NSData *)data options:(NSPropertyListReadOptions)opt format:(NSPropertyListFormat *)format error:(NSError **)error;// NS_AVAILABLE(10_6, 4_0);
+ (id)dictionaryWithData:(NSData *)data options:(NSPropertyListReadOptions)opt format:(NSPropertyListFormat *)format error:(NSError **)error;// NS_AVAILABLE(10_6, 4_0);

- (id)initWithContentsOfURLRequest:(NSURLRequest *)request;
+ (id)dictionaryWithContentsOfURLRequest:(NSURLRequest *)request;

- (id)initWithContentsOfURLRequest:(NSURLRequest *)request options:(NSPropertyListReadOptions)opt format:(NSPropertyListFormat *)format error:(NSError **)error;
+ (id)dictionaryWithContentsOfURLRequest:(NSURLRequest *)request options:(NSPropertyListReadOptions)opt format:(NSPropertyListFormat *)format error:(NSError **)error;

@end
