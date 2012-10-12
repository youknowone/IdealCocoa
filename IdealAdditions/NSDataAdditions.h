//
//  NSDataAdditions.h
//  IdealCocoa
//
//  Created by youknowone on 10. 10. 17..
//  Copyright 2010 3rddev.org. All rights reserved.
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

@interface NSData (IdealCocoa)

- (id)initWithContentsOfURLRequest:(NSURLRequest *)request;
+ (NSData *)dataWithContentsOfURLRequest:(NSURLRequest *)request;

- (id)initWithContentsOfURLRequest:(NSURLRequest *)request error:(NSError **)error;
+ (NSData *)dataWithContentsOfURLRequest:(NSURLRequest *)request error:(NSError **)error;

- (NSString *)hexadecimalString;
- (id)initWithHexadecimalString:(NSString *)hexadecimal;
+ (NSData *)dataWithHexadecimalString:(NSString *)hexadecimal;


// deprecation: use NSString -smartURL
- (id)initWithContentsOfAbstractPath:(NSString *)path __deprecated;
+ (NSData *)dataWithContentsOfAbstractPath:(NSString *)path __deprecated;

- (id)initWithContentsOfAbstractPath:(NSString *)path options:(NSDataReadingOptions)opt error:(NSError **)error __deprecated;
+ (NSData *)dataWithContentsOfAbstractPath:(NSString *)path options:(NSDataReadingOptions)opt error:(NSError **)error __deprecated;

// deprecation: use -initWithCOntentsOfURLRequest:
- (id)initWithContentsOfURL:(NSURL *)url postBody:(NSDictionary *)bodyDictionary encoding:(NSStringEncoding)encoding __deprecated;
+ (NSData *)dataWithContentsOfURL:(NSURL *)url postBody:(NSDictionary *)bodyDictionary encoding:(NSStringEncoding)encoding __deprecated;

@end
