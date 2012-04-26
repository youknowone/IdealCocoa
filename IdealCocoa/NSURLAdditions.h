//
//  NSURLAdditions.h
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

@interface NSURL (IdealCocoa)

- (id)initWithAbstractPath:(NSString *)path;
- (id)initWithAbstractFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2);
- (id)initWithFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2);
- (id)initFileURLWithFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2);

+ (NSURL *)URLWithAbstractPath:(NSString *)path;
+ (NSURL *)URLWithAbstractFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2);
+ (NSURL *)URLWithFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2);
+ (NSURL *)fileURLWithFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2);

@end

@interface NSString (IdealCocoaNSURLAdditions)

- (BOOL)hasURLPrefix;
- (NSString *)pathProtocol;
- (NSURL *)URL;
- (NSURL *)abstractURL;

@end
