//
//  NSURLAdditions.m
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

#define PATH_DEBUG FALSE

#import "NSBundleAdditions.h"
#import "NSPathUtilitiesAddtions.h"
#import "NSStringAdditions.h"
#import "NSURLAdditions.h"

@implementation NSURL (ICAdditions)

- (id)initWithAbstractPath:(NSString *)path {
	if ( [path hasURLPrefix] )
		return [self initWithString:path];
	NSString *resKey = @"res://";
	if ( [path hasPrefix:resKey] ) {
		NSString *pathPart = [path substringFromIndex:[resKey length]];
		NSString *resPath = [[NSBundle mainBundle] pathForResourceFile:pathPart];
		if ( resPath != nil ) {
			path = resPath;
		} else {
			path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:pathPart]; // iPhoneOS3 support
		}
		ICLog(PATH_DEBUG, @"abstract resource path: %@", path);
	}
	NSString *confKey = @"conf://";
	if ( [path hasPrefix:confKey] ) {
		path = NSPathForUserConfigurationFile([path substringFromIndex:[confKey length]]);
	}
	return [self initFileURLWithPath:path];
}

- (id)initWithAbstractFormat:(NSString *)format, ... {
	va_list args;
	va_start(args, format);
	self = [self initWithAbstractPath:[NSString stringWithFormat:format arguments:args]];
	va_end(args);
	return self;
}

- (id)initWithFormat:(NSString *)format, ... {
	va_list args;
	va_start(args, format);
	self = [self initWithString:[NSString stringWithFormat:format arguments:args]];
	va_end(args);
	return self;
}

- (id)initFileURLWithFormat:(NSString *)format, ... {
	va_list args;
	va_start(args, format);
	self = [self initFileURLWithPath:[NSString stringWithFormat:format arguments:args]];
	va_end(args);
	return self;
}

+ (NSURL *)URLWithFormat:(NSString *)format, ... {
	va_list args;
	va_start(args, format);
	NSURL *url = [[self allocWithZone:NULL] initWithString:[NSString stringWithFormat:format arguments:args]];
	va_end(args);
	return [url autorelease];
}

+ (NSURL *)URLWithAbstractPath:(NSString *)path {
	return [[[self allocWithZone:NULL] initWithAbstractPath:path] autorelease];
}

+ (NSURL *)URLWithAbstractFormat:(NSString *)format, ... {
	va_list args;
	va_start(args, format);
	NSURL *url = [[self allocWithZone:NULL] initWithAbstractPath:[NSString stringWithFormat:format arguments:args]];
	va_end(args);
	return [url autorelease];	
}

+ (NSURL *)fileURLWithFormat:(NSString *)format, ... {
	va_list args;
	va_start(args, format);
	NSURL *url = [[self allocWithZone:NULL] initFileURLWithPath:[NSString stringWithFormat:format arguments:args]];
	va_end(args);
	return [url autorelease];
}

@end

@implementation NSString (IdealCocoaNSURLAdditions)

- (BOOL)hasURLPrefix {
	NSString *regexkey = @"^https?://.*";	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexkey];
	return [predicate evaluateWithObject:self];	
}

- (NSString *)pathProtocol {
	NSString *regexkey = @"^[a-zA-Z]*://.*";
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexkey];
	if (![predicate evaluateWithObject:self])
		return nil;
	NSRange delemeterRange = [self rangeOfString:@"://"];
	return [self substringFromIndex:0 length:delemeterRange.location];
}

- (NSURL *)URL {
    return [NSURL URLWithString:self];
}

- (NSURL *)abstractURL {
    return [NSURL URLWithAbstractPath:self];
}

@end
