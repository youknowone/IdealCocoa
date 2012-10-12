//
//  NSACrypto.m
//  IdealCocoa
//
//  Created by youknowone on 10. 11. 1..
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

#import <CommonCrypto/CommonDigest.h>
#import "NSACrypto.h"

@implementation NSData (IdealCocoaCrypto)

- (NSData *)digestByMD5 {
	unsigned char hashedChars[CC_MD5_DIGEST_LENGTH];
	CC_MD5([self bytes], (CC_LONG)[self length], hashedChars);
	return [NSData dataWithBytes:hashedChars length:CC_MD5_DIGEST_LENGTH];	
}

- (NSData *)digestBySHA1 {
	unsigned char hashedChars[CC_SHA1_DIGEST_LENGTH];
	CC_SHA1([self bytes], (CC_LONG)[self length], hashedChars);
	return [NSData dataWithBytes:hashedChars length:CC_SHA1_DIGEST_LENGTH];
}

- (NSString *)digestStringByMD5 {
	unsigned char hashedChars[CC_MD5_DIGEST_LENGTH];
	CC_MD5([self bytes], (CC_LONG)[self length], hashedChars);
	NSMutableString *result = [[NSMutableString alloc] init];
	for ( int i = 0; i<CC_MD5_DIGEST_LENGTH; i++ )
		[result appendFormat:@"%02x", *(hashedChars+i)];
	return [result autorelease];
}

- (NSString *)digestStringBySHA1 {
	unsigned char hashedChars[CC_SHA1_DIGEST_LENGTH];
	CC_SHA1([self bytes], (CC_LONG)[self length], hashedChars);
	NSMutableString *result = [[NSMutableString alloc] init];
	for ( int i = 0; i<CC_SHA1_DIGEST_LENGTH; i++ ) {
		[result appendFormat:@"%02x", *(hashedChars+i)];
	}
	return [result autorelease];
}

@end

@implementation NSString (IdealCocoaCrypto)

- (NSData *)digestByMD5 {
	return [[self dataUsingEncoding:NSUTF8StringEncoding] digestByMD5];
}

- (NSData *)digestBySHA1 {
	return [[self dataUsingEncoding:NSUTF8StringEncoding] digestBySHA1];	
}

- (NSString *)digestStringByMD5 {
	return [[self dataUsingEncoding:NSUTF8StringEncoding] digestStringByMD5];
}

- (NSString *)digestStringBySHA1 {
	return [[self dataUsingEncoding:NSUTF8StringEncoding] digestStringBySHA1];	
}

@end
