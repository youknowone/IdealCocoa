//
//  NSURLRequestAdditions.h
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

@interface NSURLRequest (IdealCocoa)

@property(readonly) NSURL *URL;
@property(readonly) NSURLRequestCachePolicy cachePolicy;
@property(readonly) NSTimeInterval timeoutInterval;
#if TARGET_OS_IPHONE
@property(readonly) NSURLRequestNetworkServiceType networkServiceType;
#endif
@property(readonly) NSURL *mainDocumentURL;

@property(readonly) NSDictionary *allHTTPHeaderFields;
@property(readonly) NSString *HTTPMethod;
@property(readonly) NSData *HTTPBody;
#if MAC_OS_X_VERSION_10_4 <= MAC_OS_X_VERSION_MAX_ALLOWED || __IPHONE_2_0 <= __IPHONE_OS_VERSION_MAX_ALLOWED
@property(readonly) NSInputStream *HTTPBodyStream;
#endif
@property(readonly) BOOL HTTPShouldHandleCookies;
@property(readonly) BOOL HTTPShouldUsePipelining;

- (id)initWithURLFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2);
- (id)initWithFilePath:(NSString *)filePath;
- (id)initWithFilePathFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2);
- (id)initWithAbstractPath:(NSString *)filePath;
- (id)initWithAbstractPathFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2);

+ (id)URLRequestWithURLFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2);
+ (id)URLRequestWithFilePath:(NSString *)filepath;
+ (id)URLRequestWithFilePathFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2);
+ (id)URLRequestWithAbstractPath:(NSString *)filePath;
+ (id)URLRequestWithAbstractPathFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2);

@end


@interface NSMutableURLRequest (IdealCocoa)

@property(retain) NSURL *URL;
@property NSURLRequestCachePolicy cachePolicy;
@property NSTimeInterval timeoutInterval;
#if TARGET_OS_IPHONE
@property NSURLRequestNetworkServiceType networkServiceType;
#endif
@property(retain) NSURL *mainDocumentURL;

@property(retain) NSDictionary *allHTTPHeaderFields;
@property(retain) NSString *HTTPMethod;
@property(retain) NSData *HTTPBody;
#if MAC_OS_X_VERSION_10_4 <= MAC_OS_X_VERSION_MAX_ALLOWED || __IPHONE_2_0 <= __IPHONE_OS_VERSION_MAX_ALLOWED
@property(retain) NSInputStream *HTTPBodyStream;
#endif
@property BOOL HTTPShouldHandleCookies;
@property BOOL HTTPShouldUsePipelining;

- (void)setHTTPPostBody:(NSDictionary *)bodyDictionary encoding:(NSStringEncoding)encoding;

@end


@interface NSAURLRequestHTTPBodyMultiPartFormPostFormatter : NSObject {
	NSMutableData *_body;
	NSStringEncoding _encoding;
}

- (id)initWithEncoding:(NSStringEncoding)encoding;
- (void)appendBodyDataToFieldName:(NSString *)fieldName text:(NSString *)textData;
- (void)appendBodyDataToFieldName:(NSString *)fieldName text:(NSString *)textData encoding:(NSStringEncoding)encoding;
- (void)appendBodyDataToFieldName:(NSString *)fieldName data:(NSData *)data;
- (void)appendBodyDataToFieldName:(NSString *)fieldName fileName:(NSString *)fileName data:(NSData *)data;
- (void)appendBodyDataEndian;

- (NSData *)HTTPBody;

@end

@interface NSMutableURLRequest (ICHTTPMultiPartFormPostRequest)

- (void)setHTTPMultiPartFormPostBody:(NSDictionary *)bodyDictionary encoding:(NSStringEncoding)encoding;

@end

