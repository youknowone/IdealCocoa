//
//  NSURLRequestAdditions.m
//  IdealCocoa
//
//  Created by youknowone on 10. 10. 17..
//  Copyright 2010 3rddev.org. All rights reserved.
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.
//

#import "NSStringAdditions.h"
#import "NSURLAdditions.h"
#import "NSURLRequestAdditions.h"

#import "ICHTTPRequest.h"

@implementation NSURLRequest (IdealCocoa)
@dynamic cachePolicy, timeoutInterval;
#if TARGET_OS_IPHONE
@dynamic networkServiceType;
#endif
@dynamic URL, mainDocumentURL;

@dynamic allHTTPHeaderFields, HTTPMethod, HTTPBody;
#if MAC_OS_X_VERSION_10_4 <= MAC_OS_X_VERSION_MAX_ALLOWED || __IPHONE_2_0 <= __IPHONE_OS_VERSION_MAX_ALLOWED
@dynamic HTTPBodyStream;
#endif
@dynamic HTTPShouldHandleCookies, HTTPShouldUsePipelining;

- (id)initWithURLString:(NSString *)URLString {
    return [self initWithURL:[NSURL URLWithString:URLString]];
}

- (id)initWithURLFormat:(NSString *)format, ... {
    va_list args;
    va_start(args, format);
    self = [self initWithURL:[NSURL URLWithString:[NSString stringWithFormat:format arguments:args]]];
    va_end(args);
    return self;
}

- (id)initWithFilePath:(NSString *)filePath {
    return [self initWithURL:[NSURL fileURLWithPath:filePath]];
}

- (id)initWithFilePathFormat:(NSString *)format, ... {
    va_list args;
    va_start(args, format);
    self = [self initWithURL:[NSURL fileURLWithPath:[NSString stringWithFormat:format arguments:args]]];
    va_end(args);
    return self;
}

- (id)initWithAbstractPath:(NSString *)filePath {
    return [self initWithURL:[NSURL URLWithAbstractPath:filePath]];
}

- (id)initWithAbstractPathFormat:(NSString *)format, ... {
    va_list args;
    va_start(args, format);
    self = [self initWithURL:[NSURL URLWithAbstractPath:[NSString stringWithFormat:format arguments:args]]];
    va_end(args);
    return self;
}

+ (id)URLRequestWithURLString:(NSString *)URLString {
    return [self requestWithURL:[NSURL URLWithString:URLString]];
}

+ (id)URLRequestWithURLFormat:(NSString *)format, ... {
    va_list args;
    va_start(args, format);
    NSURLRequest *request = [[self allocWithZone:NULL] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:format arguments:args]]];
    va_end(args);
    return [request autorelease];
}

+ (id)URLRequestWithFilePath:(NSString *)filePath {
    return [self requestWithURL:[NSURL fileURLWithPath:filePath]];
}

+ (id)URLRequestWithFilePathFormat:(NSString *)format, ... {
    va_list args;
    va_start(args, format);
    NSURLRequest *request = [[self allocWithZone:NULL] initWithURL:[NSURL fileURLWithPath:[NSString stringWithFormat:format arguments:args]]];
    va_end(args);
    return [request autorelease];
}

+ (id)URLRequestWithAbstractPath:(NSString *)filePath {
    return [self requestWithURL:[NSURL URLWithAbstractPath:filePath]];
}

+ (id)URLRequestWithAbstractPathFormat:(NSString *)format, ... {
    va_list args;
    va_start(args, format);
    NSURLRequest *request = [[self allocWithZone:NULL] initWithURL:[NSURL URLWithAbstractPath:[NSString stringWithFormat:format arguments:args]]];
    va_end(args);
    return [request autorelease];
}

@end


@implementation NSMutableURLRequest (IdealCocoa)
@dynamic cachePolicy, timeoutInterval;
#if TARGET_OS_IPHONE
@dynamic networkServiceType;
#endif
@dynamic URL, mainDocumentURL;

@dynamic allHTTPHeaderFields, HTTPMethod, HTTPBody;
#if MAC_OS_X_VERSION_10_4 <= MAC_OS_X_VERSION_MAX_ALLOWED || __IPHONE_2_0 <= __IPHONE_OS_VERSION_MAX_ALLOWED
@dynamic HTTPBodyStream;
#endif
@dynamic HTTPShouldHandleCookies, HTTPShouldUsePipelining;

- (void)setHTTPPostBody:(NSDictionary *)bodyDictionary encoding:(NSStringEncoding)encoding {
    self.HTTPMethod = @"POST";
    if (bodyDictionary.count == 0) return;

    NSMutableArray *parts = [[NSMutableArray alloc] initWithCapacity:[bodyDictionary count]];

    for ( NSString *key in [bodyDictionary keyEnumerator] ) {
        NSString *value = [bodyDictionary objectForKey:key];
        NSString *part = [NSString stringWithFormat:@"%@=%@", [key stringByAddingPercentEscapesUsingEncoding:encoding], [value stringByAddingPercentEscapesUsingEncoding:encoding]];
        [parts addObject:part];
    }

    self.HTTPBody = [[parts componentsJoinedByString:@"&"] dataUsingEncoding:NSASCIIStringEncoding];
    [parts release];
}

- (void)setHTTPMultiPartFormPostBody:(NSDictionary *)bodyDictionary encoding:(NSStringEncoding)encoding {
    self.HTTPMethod = @"POST";
    ICHTTPMultiPartFormPostRequestFormatter *formatter = [[ICHTTPMultiPartFormPostRequestFormatter alloc] initWithURL:self.URL encoding:encoding];
    for ( NSString *key in [bodyDictionary keyEnumerator] ) {
        id object = [bodyDictionary objectForKey:@"key"];
        if ( [object isKindOfClass:[NSData class]] )
            [formatter appendBodyDataToFieldName:key data:object];
        else
            [formatter appendBodyDataToFieldName:key text:object];
    }
    [formatter appendHTTPBody];
    self.HTTPBody = formatter.request.HTTPBody;
    [formatter release];
}

@end
