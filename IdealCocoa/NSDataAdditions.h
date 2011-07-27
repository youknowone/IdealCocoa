//
//  NSDataAdditions.h
//  IdealCocoa
//
//  Created by youknowone on 10. 10. 17..
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

@interface NSData (IdealCocoa)

- (id)initWithContentsOfAbstractPath:(NSString *)path;
+ (NSData *)dataWithContentsOfAbstractPath:(NSString *)path;

- (id)initWithContentsOfAbstractPath:(NSString *)path options:(NSDataReadingOptions)opt error:(NSError **)error;
+ (NSData *)dataWithContentsOfAbstractPath:(NSString *)path options:(NSDataReadingOptions)opt error:(NSError **)error;

- (id)initWithContentsOfURL:(NSURL *)url postBody:(NSDictionary *)bodyDictionary encoding:(NSStringEncoding)encoding;
+ (NSData *)dataWithContentsOfURL:(NSURL *)url postBody:(NSDictionary *)bodyDictionary encoding:(NSStringEncoding)encoding;

- (id)initWithContentsOfURLRequest:(NSURLRequest *)request;
+ (NSData *)dataWithContentsOfURLRequest:(NSURLRequest *)request;

- (id)initWithContentsOfURLRequest:(NSURLRequest *)request error:(NSError **)error;
+ (NSData *)dataWithContentsOfURLRequest:(NSURLRequest *)request error:(NSError **)error;

@end
