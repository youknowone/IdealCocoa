//
//  ICIconv.m
//  IdealCocoa
//
//  Created by youknowone on 11. 3. 2..
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

#import "ICIconv.h"

@interface ICIconv ()
- (void)freeOutbuf;
@end


@implementation ICIconv

- (void) dealloc {
	[self close];
	[super dealloc];
}

- (void) openWithFromCode:(NSString *)fromCode {
	[self openWithToCode:@"UTF-8" fromCode:fromCode];
}

- (void) openWithToCode:(NSString *)toCode fromCode:(NSString *)fromCode {
	[self close];
	handle = iconv_open([toCode UTF8String], [fromCode UTF8String]);
	assert(handle != (iconv_t)-1); // TODO:
}

- (void) openWithToCode:(NSString *)toCode fromCode:(NSString *)fromCode translit:(BOOL)translit ignore:(BOOL)ignore {
	[self close];
	NSMutableString *attributedToCode = [toCode copy];
	if (translit) [attributedToCode appendString:@"//TRANSLIT"];
	if (ignore) [attributedToCode appendString:@"//IGNORE"];
	[self openWithToCode:attributedToCode fromCode:fromCode];
}

- (void) freeOutbuf {
	if (outbuf) free(outbuf);
	outbuf = NULL;
}

- (void) close {
	if (handle == NULL) return;
	[self freeOutbuf];
	iconv_close(handle);
	handle = NULL;
}

- (const char *) convertedCStringWithCString:(const char *)cString length:(int)length {
	[self freeOutbuf];
	size_t inbufLength = length;
	size_t outbufLength = 2*length;
	outbuf = malloc(outbufLength*sizeof(char));
	const char* outbufStart = outbuf;
	nonreversibleLength = iconv(handle, (char**)&cString, &inbufLength, &outbuf, &outbufLength);
	*outbuf = '\0';
	return outbufStart;
}

+ (NSString *) convertedStringWithBytes:(const void *)bytes length:(NSUInteger)length fromCode:(NSString *)fromCode {
	ICIconv *iconv = [[ICIconv alloc] initWithFromCode:fromCode];
	NSString *result = [NSString stringWithUTF8String:[iconv convertedCStringWithCString:(char *)bytes length:strlen((char *)bytes)]];
    [iconv release];
    return result;
}

@end


@implementation ICIconv (Creations)

- (id)initWithFromCode:(NSString *)aFromCode {
	return [self initWithToCode:@"UTF-8" fromCode:aFromCode];
}

- (id) initWithToCode:(NSString *)aToCode fromCode:(NSString *)aFromCode {
	if ((self = [super init]) != nil) {
		[self openWithToCode:aToCode fromCode:aFromCode];
	}
	return self;
}

- (id)initWithToCode:(NSString *)aToCode fromCode:(NSString *)aFromCode translit:(BOOL)translit ignore:(BOOL)ignore {
	if ((self = [super init]) != nil) {
		[self openWithToCode:aToCode fromCode:aFromCode translit:translit ignore:ignore];
	}
	return self;
}

@end
