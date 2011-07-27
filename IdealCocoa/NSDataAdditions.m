//
//  NSDataAdditions.m
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

#import "NSURLAdditions.h"
#import "NSURLRequestAdditions.h"
#import "NSDataAdditions.h"

@implementation NSData (IdealCocoa)

- (id)initWithContentsOfAbstractPath:(NSString *)path {
	return [self initWithContentsOfURL:[NSURL URLWithAbstractPath:path]];
}

+ (NSData *)dataWithContentsOfAbstractPath:(NSString *)path {
	return [[[self allocWithZone:NULL] initWithContentsOfURL:[NSURL URLWithAbstractPath:path]] autorelease];
}

- (id)initWithContentsOfAbstractPath:(NSString *)path options:(NSDataReadingOptions)opt error:(NSError **)error {
	return [self initWithContentsOfURL:[NSURL URLWithAbstractPath:path] options:opt error:error];
}

+ (NSData *)dataWithContentsOfAbstractPath:(NSString *)path options:(NSDataReadingOptions)opt error:(NSError **)error {
	return [[[self allocWithZone:NULL] initWithContentsOfURL:[NSURL URLWithAbstractPath:path] options:opt error:error] autorelease];
}

- (id)initWithContentsOfURL:(NSURL *)url postBody:(NSDictionary *)bodyDictionary encoding:(NSStringEncoding)encoding {
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
	[request setHTTPPostBody:bodyDictionary encoding:encoding];
	return [self initWithData:[NSURLConnection sendSynchronousRequest:request returningResponse:NULL error:NULL]];
}

+ (NSData *)dataWithContentsOfURL:(NSURL *)url postBody:(NSDictionary *)bodyDictionary encoding:(NSStringEncoding)encoding {
	return [[[self allocWithZone:NULL] initWithContentsOfURL:url postBody:bodyDictionary encoding:encoding] autorelease];
}

- (id)initWithContentsOfURLRequest:(NSURLRequest *)request {
	return [self initWithData:[NSURLConnection sendSynchronousRequest:request returningResponse:NULL error:NULL]];
}

+ (NSData *)dataWithContentsOfURLRequest:(NSURLRequest *)request {
	return [[[self allocWithZone:NULL] initWithContentsOfURLRequest:request] autorelease];
}

- (id)initWithContentsOfURLRequest:(NSURLRequest *)request error:(NSError **)error {
	return [self initWithData:[NSURLConnection sendSynchronousRequest:request returningResponse:NULL error:error]];
}

+ (NSData *)dataWithContentsOfURLRequest:(NSURLRequest *)request error:(NSError **)error {
	return [[[self allocWithZone:NULL] initWithContentsOfURLRequest:request error:error] autorelease];
}

@end
