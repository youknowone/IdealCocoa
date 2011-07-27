//
//  ICCrypto.h
//  IdealCocoa
//
//  Created by youknowone on 10. 11. 1..
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

@interface NSData (IdealCocoaCrypto)

- (NSData *)digestByMD5;
- (NSData *)digestBySHA1;

- (NSString *)digestStringByMD5;
- (NSString *)digestStringBySHA1;

@end

// string conversion wrapper of NSData (IdealCocoaCrypto)
@interface NSString (IdealCocoaCrypto)

- (NSData *)digestByMD5;
- (NSData *)digestBySHA1;

- (NSString *)digestStringByMD5;
- (NSString *)digestStringBySHA1;

@end
