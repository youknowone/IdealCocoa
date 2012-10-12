//
//  NSStringAdditions.h
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

@interface NSString (IdealCocoa)

+ (NSString *)stringWithFormat:(NSString *)format arguments:(va_list)argList NS_FORMAT_FUNCTION(1,0);
+ (NSString *)stringWithData:(NSData *)data encoding:(NSStringEncoding)encoding;
+ (NSString *)stringWithUTF8Data:(NSData *)data;

- (NSString *)stringByAddingPercentEscapesUsingUTF8Encoding;
- (NSString *)stringByReplacingPercentEscapesUsingUTF8Encoding;

- (NSData *)dataUsingUTF8Encoding;

- (NSInteger)integerValueBase:(NSInteger)radix;
- (NSInteger)hexadecimalValue;

- (NSString *)substringFromIndex:(NSUInteger)from length:(NSUInteger)length;
- (NSString *)substringFromIndex:(NSUInteger)from toIndex:(NSUInteger)to;

@end
