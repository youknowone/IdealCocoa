//
//  ICSQL.h
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

@interface ICSQL : NSObject {
	NSMutableString *SQL; 
}

@property(readonly) NSString *SQL;

- (ICSQL *)groupBy:(NSString *)groups;
- (ICSQL *)groupBy:(NSString *)groups having:(NSString*)groupContidion;
- (ICSQL *)orderBy:(NSString *)condition;
- (ICSQL *)limit:(NSUInteger)count;
- (ICSQL *)limit:(NSUInteger)from count:(NSUInteger)count;

@end

@interface ICSQL (ICSQLCreation)

- (id)initWithString:(NSString *)string;
+ (id)initWithFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2);
+ (ICSQL *)SQLWithString:(NSString *)string;
+ (ICSQL *)SQLWithFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2);

+ (ICSQL *)SQLWithSelect:(NSString *)column from:(NSString *)table where:(NSString *)condition;
+ (ICSQL *)SQLWithDeleteFrom:(NSString *)table where:(NSString*)condition;
+ (ICSQL *)SQLWithInsertInto:(NSString *)table values:(NSString*)values;
+ (ICSQL *)SQLWithInsertInto:(NSString *)table columns:(NSString*)columns values:(NSString*)values;
+ (ICSQL *)SQLWithUpdate:(NSString *)table set:(NSString*)setStatements where:(NSString*)condition;

@end


@interface ICSQL (ICSQLStringGenerators)

+ (NSString *)alias:(NSString *)SQL as:(NSString *)alias;
+ (NSString *)customListSeparatedBy:(NSString *)separator withStrings:(NSString *)firstObj, ... NS_REQUIRES_NIL_TERMINATION;
+ (NSString *)commaListWithStrings:(NSString *)firstObj, ... NS_REQUIRES_NIL_TERMINATION;
+ (NSString *)rawCommaListWithStrings:(NSString *)firstObj, ... NS_REQUIRES_NIL_TERMINATION;
+ (NSString *)andConditionWithStrings:(NSString *)firstSQL, ... NS_REQUIRES_NIL_TERMINATION;
+ (NSString *)orConditionWithStrings:(NSString *)firstSQL, ... NS_REQUIRES_NIL_TERMINATION;
+ (NSString *)customListSeparatedBy:(NSString *)separator withArray:(NSArray *)array;
+ (NSString *)commaListWithArray:(NSArray *)array;
+ (NSString *)rawCommaListWithArray:(NSArray *)array;
+ (NSString *)andConditionWithArray:(NSArray *)array;
+ (NSString *)orConditionWithArray:(NSArray *)array;

@end

