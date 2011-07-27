//
//  NSDictionaryAdditions.m
//  IdealCocoa
//
//  Created by youknowone on 11. 1. 24..
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

#import "NSPathUtilitiesAddtions.h"
#import "NSDataAdditions.h"
#import "NSDictionaryAdditions.h"

@implementation NSDictionary (IdealCocoa)

- (id) initWithData:(NSData *)data {
	return [self initWithData:data options:0 format:NULL error:NULL];
}

+ (id) dictionaryWithData:(NSData *)data {
	return [[[self allocWithZone:NULL] initWithData:data] autorelease];
}

- (id) initWithData:(NSData *)data options:(NSPropertyListReadOptions)opt format:(NSPropertyListFormat *)format error:(NSError **)error {
	NSDictionary *contents;
	//TODO: check deployment version
	if ( [NSPropertyListSerialization respondsToSelector:@selector(propertyListWithData:options:format:error:)] ) {
		contents = [NSPropertyListSerialization propertyListWithData:data options:opt format:format error:error];
	} else { // support os < osx10.6 or ios4.0
		contents = [NSPropertyListSerialization propertyListFromData:data mutabilityOption:NSPropertyListImmutable format:NULL errorDescription:NULL];
	}
	if (contents==nil) {
		[self release];
		return nil;
	}
	return [self initWithDictionary:contents];
}

+ (id) dictionaryWithData:(NSData *)data options:(NSPropertyListReadOptions)opt format:(NSPropertyListFormat *)format error:(NSError **)error {
	return [[[self allocWithZone:NULL] initWithData:data options:opt format:format error:error] autorelease];
}

- (id) initWithContentsOfURLRequest:(NSURLRequest *)request {
	return [self initWithContentsOfURLRequest:request options:0 format:NULL error:NULL];
}

+ (id) dictionaryWithContentsOfURLRequest:(NSURLRequest *)request {
	return [[[self allocWithZone:NULL] initWithContentsOfURLRequest:request options:0 format:NULL error:NULL] autorelease];
}
		
- (id) initWithContentsOfURLRequest:(NSURLRequest *)request options:(NSPropertyListReadOptions)opt format:(NSPropertyListFormat *)format error:(NSError **)error {
	NSData *data = [NSData dataWithContentsOfURLRequest:request error:error];
	if (data == nil) {
		[self release];
		return nil;
	}
	return [self initWithData:data options:opt format:format error:error];
}

+ (id) dictionaryWithContentsOfURLRequest:(NSURLRequest *)request options:(NSPropertyListReadOptions)opt format:(NSPropertyListFormat *)format error:(NSError **)error {
	return [[[self allocWithZone:NULL] initWithContentsOfURLRequest:request options:opt format:format error:error] autorelease];
}

@end
