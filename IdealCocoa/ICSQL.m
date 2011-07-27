//
//  ICSQL.m
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

#import "NSStringAdditions.h"
#import "ICSQL.h"

@implementation ICSQL
@synthesize SQL;

- (id)init {
	if ((self = [super init]) != nil) {
		SQL = [[NSMutableString alloc] init];
	}
	return self;
}

- (id)initWithString:(NSString *)string {
	if ((self = [self init]) != nil) {
		[SQL appendString:string];
	}
	return self;
}

- (id)initWithFormat:(NSString *)format, ... {
	if ((self = [self init]) != nil) {
		va_list args;
		va_start(args, format);
		[SQL appendString:[NSString stringWithFormat:format arguments:args]];
		va_end(args);
	}
	return self;	
}

- (void)dealloc {
	[SQL release];
	[super dealloc];
}

- (NSString *) description {
	return SQL;
}

- (ICSQL *)groupBy:(NSString *)groups {
	[SQL appendString:@" GROUP BY "];
	[SQL appendString:groups];
	return self;
}

- (ICSQL *)groupBy:(NSString *)groups having:(NSString*)groupContidion {
	[self groupBy:groups];
	[SQL appendString:@" HAVING "];
	[SQL appendString:groupContidion];
	return self;
}

- (ICSQL *)orderBy:(NSString *)condition {
	[SQL appendFormat:@" ORDER BY %@", condition];
	return self;
}

- (ICSQL *)limit:(NSUInteger)count {
	[SQL appendFormat:@" LIMIT %d", count];
	return self;
}

- (ICSQL *)limit:(NSUInteger)from count:(NSUInteger)count {
	[SQL appendFormat:@" LIMIT %d,%d", from, count];
	return self;
}

+ (ICSQL *)SQLWithString:(NSString *)string {
	return [[[ICSQL alloc] initWithString:string] autorelease];
}

+ (ICSQL *)SQLWithFormat:(NSString *)format, ... {
	va_list args;
	va_start(args, format);
	self = [[self alloc] initWithString:[NSString stringWithFormat:format arguments:args]];
	va_end(args);
	return [self autorelease];
}

+ (NSString *)alias:(NSString *)SQL as:(NSString *)alias {
	return [NSString stringWithFormat:@"%@ AS `%@`", SQL, alias];
}

+ (NSString *)customListSeparatedBy:(NSString *)separator withStrings:(NSString *)firstSQL, ... {
	va_list args;
	va_start(args, firstSQL);
	NSString *arg = firstSQL;
	NSMutableString *sql = [NSMutableString stringWithFormat:@"`%@`", arg];
	for ( arg = va_arg(args, NSString*); arg != nil; arg = va_arg(args, NSString*) )
	{
		[sql appendFormat:@"%@ %@", separator, arg];
	}
	va_end(args);
	return sql;
}

+ (NSString *)commaListWithStrings:(NSString *)firstSQL, ... {
	va_list args;
	va_start(args, firstSQL);
	NSString *arg = firstSQL;
	NSMutableString *sql = [NSMutableString stringWithFormat:@"`%@`", arg];
	for ( arg = va_arg(args, NSString*); arg != nil; arg = va_arg(args, NSString*) )
	{
		[sql appendFormat:@", `%@`", arg];
	}
	va_end(args);
	return sql;
}

+ (NSString *)rawCommaListWithStrings:(NSString *)firstSQL, ... {
	va_list args;
	va_start(args, firstSQL);
	NSString *arg = firstSQL;
	NSMutableString *sql = [NSMutableString stringWithString:arg];
	for ( arg = va_arg(args, NSString*); arg != nil; arg = va_arg(args, NSString*) )
	{
		[sql appendString:@", "];
		[sql appendString:arg];
	}
	va_end(args);
	return sql;
}

+ (NSString *)andConditionWithStrings:(NSString *)firstSQL, ... {
	va_list args;
	va_start(args, firstSQL);
	NSString *arg = firstSQL;
	NSMutableString *sql = [NSMutableString stringWithString:arg];
	for ( arg = va_arg(args, NSString*); arg != nil; arg = va_arg(args, NSString*) )
	{
		[sql appendString:@" AND "];
		[sql appendString:arg];
	}
	va_end(args);
	return [NSString stringWithFormat:@"(%@)", sql];
}

+ (NSString *)orConditionWithStrings:(NSString *)firstSQL, ... {
	va_list args;
	va_start(args, firstSQL);
	NSString *arg = firstSQL;
	NSMutableString *sql = [NSString stringWithString:arg];
	for ( arg = va_arg(args, NSString*); arg != nil; arg = va_arg(args, NSString*) )
	{
		[sql appendString:@" OR "];
		[sql appendString:arg];
	}
	va_end(args);
	return [NSString stringWithFormat:@"(%@)", sql];
}

+ (NSString *)customListSeparatedBy:(NSString *)separator withArray:(NSArray *)array {
	if ( nil == array || 0 == [array count] ) return nil;
	NSMutableString *sql = [NSMutableString stringWithString:[array objectAtIndex:0]];
	NSUInteger index = 1;
	while ( [array count] > index ) {
		[sql appendFormat:@"%@ %@", separator, [array objectAtIndex:index]];
		index++;
	}
	return sql;
}

+ (NSString *)commaListWithArray:(NSArray *)array {
	if ( nil == array || 0 == [array count] ) return nil;
	NSMutableString *sql = [NSMutableString stringWithString:[array objectAtIndex:0]];
	NSUInteger index = 1;
	while ( [array count] > index ) {
		[sql appendFormat:@", `%@`", [array objectAtIndex:index]];
		index++;
	}
	return sql;
}

+ (NSString *)rawCommaListWithArray:(NSArray *)array {
	return [self customListSeparatedBy:@", " withArray:array];	
}

+ (NSString *)andConditionWithArray:(NSArray *)array {
	return [NSString stringWithFormat:@"( %@ )", [self customListSeparatedBy:@" AND " withArray:array]];
}

+ (NSString *)orConditionWithArray:(NSArray *)array {
	return [NSString stringWithFormat:@"( %@ )", [self customListSeparatedBy:@" OR " withArray:array]];
}


+ (ICSQL *)SQLWithSelect:(NSString *)column from:(NSString *)table where:(NSString *)condition {
	return [ICSQL SQLWithString:[NSString stringWithFormat:@"SELECT %@ FROM %@ WHERE %@", column, table, condition]];
}

+ (ICSQL *)SQLWithDeleteFrom:(NSString *)table where:(NSString*)condition {
	return [[[ICSQL alloc] initWithFormat:@"DELETE FROM %@ WHERE %@", table, condition] autorelease];
}

+ (ICSQL *)SQLWithInsertInto:(NSString *)table values:(NSString*)values {
	return [NSString stringWithFormat:@"INSERT INTO `%@` VALUES (%@)", table, values];
}

+ (ICSQL *)SQLWithInsertInto:(NSString *)table columns:(NSString*)columns values:(NSString*)values {
	return [NSString stringWithFormat:@"INSERT INTO `%@` (%@) VALUES (%@)", table, columns, values];	
}

+ (ICSQL *)SQLWithUpdate:(NSString *)table set:(NSString*)setStatements where:(NSString*)condition {
	return [NSString stringWithFormat:@"UPDATE `%@` SET %@ WHERE %@", table, setStatements, condition];
}

@end
