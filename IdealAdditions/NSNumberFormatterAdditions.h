//
//  NSNumberFormatterAdditions.h
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

@interface NSNumberFormatter (IdealCocoa)

@property(assign) NSNumberFormatterStyle numberStyle;
@property(assign) BOOL generatesDecimalNumbers;
@property(assign) NSLocale *locale;

+ (NSNumberFormatter *)formatter;
- (id)initWithNumberStyle:(NSNumberFormatterStyle)style;
+ (NSNumberFormatter *)formatterWithNumberStyle:(NSNumberFormatterStyle)style;

+ (NSString *)formattedStringByDecimalStyleForNumber:(NSNumber *)number;
+ (NSString *)formattedStringByDecimalStyleForInteger:(NSInteger)integer;

@end
