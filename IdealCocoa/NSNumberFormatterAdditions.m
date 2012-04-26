//
//  NSNumberFormatterAdditions.m
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

#import "NSNumberFormatterAdditions.h"

@implementation NSNumberFormatter (IdealCocoa)
@dynamic numberStyle;
@dynamic generatesDecimalNumbers;
@dynamic locale;

+ (NSNumberFormatter *)formatter {
	return [[self alloc] autorelease];
}

- (id)initWithNumberStyle:(NSNumberFormatterStyle)style {
	self = [self init];
	[self setNumberStyle:style];
	return self;
}

+ (NSNumberFormatter *)formatterWithNumberStyle:(NSNumberFormatterStyle)style {
	return [[[self allocWithZone:NULL] initWithNumberStyle:style] autorelease];
}

+ (NSString *)formattedStringByDecimalStyleForNumber:(NSNumber *)number {
	return [[self formatterWithNumberStyle:NSNumberFormatterDecimalStyle] stringFromNumber:number];
}

+ (NSString *)formattedStringByDecimalStyleForInteger:(NSInteger)integer {
	return [self formattedStringByDecimalStyleForNumber:[NSNumber numberWithInteger:integer]];
}

@end
