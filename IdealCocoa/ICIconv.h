//
//  ICIconv.h
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

#include <iconv.h>

@interface ICIconv : NSObject {
	iconv_t handle;
	size_t nonreversibleLength;
  @private
	char *outbuf;
}

- (void)openWithFromCode:(NSString *)fromCode;
- (void)openWithToCode:(NSString *)toCode fromCode:(NSString *)fromCode;
- (void)openWithToCode:(NSString *)toCode fromCode:(NSString *)fromCode translit:(BOOL)translit ignore:(BOOL)ignore;
- (void)close;
- (const char *)convertedCStringWithCString:(const char *)cString length:(NSInteger)length;
+ (NSString *)convertedStringWithBytes:(const void *)bytes length:(NSUInteger)length fromCode:(NSString *)fromCode;

@end

@interface ICIconv (Creations)

- (id)initWithFromCode:(NSString *)fromCode;
- (id)initWithToCode:(NSString *)toCode fromCode:(NSString *)fromCode;
- (id)initWithToCode:(NSString *)toCode fromCode:(NSString *)fromCode translit:(BOOL)translit ignore:(BOOL)ignore;

@end
