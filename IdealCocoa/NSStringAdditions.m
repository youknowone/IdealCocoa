//
//  NSStringAdditions.m
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

#import "NSStringAdditions.h"

@implementation NSString (IdealCocoa)

+ (NSString *)stringWithFormat:(NSString *)format arguments:(va_list)argList {
	return [[[self allocWithZone:NULL] initWithFormat:format arguments:argList] autorelease];
}

+ (NSString *)stringWithData:(NSData *)data encoding:(NSStringEncoding)encoding {
	return [[[self allocWithZone:NULL] initWithData:data encoding:encoding] autorelease];
}
			
+ (NSString *)stringWithUTF8Data:(NSData *)data {
	return [[[self allocWithZone:NULL] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
}
	 
- (NSString *) stringByAddingPercentEscapesUsingUTF8Encoding {
	return [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *) stringByReplacingPercentEscapesUsingUTF8Encoding {
	return [self stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSData *) dataUsingUTF8Encoding {
	return [self dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSInteger)integerValueBase:(NSInteger)radix {
	NSUInteger result = 0;
	for ( NSUInteger i=0; i < [self length]; i++ ) {
		result *= radix;
		unichar digit = [self characterAtIndex:i];
		if ( '0' <= digit && digit <= '9' )
			digit -= '0';
		else if ( 'a' <= digit && digit < 'a'-10+radix )
			digit -= 'a'-10;
		else if ( 'A' <= digit && digit < 'A'-10+radix )
			digit -= 'A'-10;
		else {
			break;
		}
		result += digit;
	}
	return result;	
}

- (NSInteger)hexadecimalValue {
	return [self integerValueBase:16];
}

- (NSString *) substringFromIndex:(NSUInteger)from length:(NSUInteger)length {
	return [[self substringFromIndex:from] substringToIndex:length];
}

- (NSString *)substringFromIndex:(NSUInteger)from toIndex:(NSUInteger)to {
	return [[self substringToIndex:to] substringFromIndex:from];
}

@end
