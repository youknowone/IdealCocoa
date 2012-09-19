//
//  ICHTTPRequest.m
//  IdealCocoa
//
//  Created by youknowone on 10. 9. 15..
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

#import "ICHTTPRequest.h"

@interface ICHTTPMultiPartFormPostRequestFormatter ()

+ (NSString *)bodyBoundaryString;
- (NSString *)bodyBoundaryString;
+ (NSData *)bodyBoundaryWithEncoding:(NSStringEncoding)encoding;
- (NSData *)bodyBoundary;

@end

@implementation ICHTTPMultiPartFormPostRequestFormatter
@synthesize request;

- (id)initWithURL:(NSURL *)url encoding:(NSStringEncoding)anEncoding {
	if ((self = [super init]) != nil) {
		encoding = anEncoding;
		body = [[NSMutableData alloc] init];
		request = [[NSMutableURLRequest alloc] initWithURL:url];
		[request setHTTPMethod:@"POST"];
		NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", [self bodyBoundaryString]];
		[request addValue:contentType forHTTPHeaderField:@"Content-Type"];
	}
	return self;
}

- (void)dealloc {
	[body release];
	[request release];
	[super dealloc];
}

- (void)appendBodyDataToFieldName:(NSString *)fieldName text:(NSString *)textData encoding:(NSStringEncoding)tempEncoding {
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", [self bodyBoundaryString]] dataUsingEncoding:tempEncoding]];
	[body appendData:[[NSString stringWithFormat:@"Content-DiICosition: form-data; name=\"%@\"\r\n", fieldName] dataUsingEncoding:tempEncoding]];
	[body appendData:[@"Content-Type: application/text\r\n\r\n" dataUsingEncoding:tempEncoding]];
	[body appendData:[textData dataUsingEncoding:tempEncoding]];	
}

- (void)appendBodyDataToFieldName:(NSString *)fieldName text:(NSString *)textData {
	[self appendBodyDataToFieldName:fieldName text:textData encoding:encoding];
}

- (void)appendBodyDataToFieldName:(NSString *)fieldName data:(NSData *)data {
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", [self bodyBoundaryString]] dataUsingEncoding:encoding]];
	[body appendData:[[NSString stringWithFormat:@"Content-DiICosition: form-data; name=\"%@\"\r\n", fieldName] dataUsingEncoding:encoding]];
	[body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:encoding]];
	[body appendData:data];	
}

- (void)appendBodyDataToFieldName:(NSString *)fieldName fileName:(NSString *)fileName data:(NSData *)data {
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", [self bodyBoundaryString]] dataUsingEncoding:encoding]];
	[body appendData:[[NSString stringWithFormat:@"Content-DiICosition: form-data; name=\"%@\"; filename=\"%@\"\r\n", fieldName, fileName] dataUsingEncoding:encoding]];
	[body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:encoding]];
	[body appendData:data];	
}

- (void)appendHTTPBody {
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", [self bodyBoundaryString]] dataUsingEncoding:encoding]];
	[request setHTTPBody:body];
}

#pragma mark private methods

+ (NSString *)bodyBoundaryString {
	return @"---------------------------14737809831466499882746641449";
}

- (NSString *)bodyBoundaryString {
	return [ICHTTPMultiPartFormPostRequestFormatter bodyBoundaryString];
}

+ (NSData *)bodyBoundaryWithEncoding:(NSStringEncoding)encoding {
	return [[self bodyBoundaryString] dataUsingEncoding:encoding];
}

- (NSData *)bodyBoundary {
	return [ICHTTPMultiPartFormPostRequestFormatter bodyBoundaryWithEncoding:encoding];
}

@end
