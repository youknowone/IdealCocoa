/*
 ** 2001 September 15
 **
 ** The author disclaims copyright to original source code.  In place of
 ** a legal notice, here is a blessing:
 **
 **    May you do good and not evil.
 **    May you find forgiveness for yourself and forgive others.
 **    May you share freely, never taking more than you give.
 **
 */ 
//
//  ICSqlite3.m
//  IdealCocoa
//
//  Created by youknowone on 09. 12. 9..
//  Copyright 2010 3rddev.org. All rights reserved.
//	
//  This file follow lisence of original sqlite3 (see upper part)
//

#import "ICUtility.h"
#import "NSStringAdditions.h"

#define SQLITE3_DEBUG FALSE
#import "ICSqlite3.h"

@implementation ICSqlite3Cursur

@synthesize resultCode;

- (id) initWithSqlite3:(ICSqlite3 *)sqlite3 sql:(NSString *)sql errorMessage:(const char **)bufferOrNull {
	if ((self = [self init]) != nil) {
		resultCode = sqlite3_prepare_v2(sqlite3->database, [sql UTF8String], -1, &statement, bufferOrNull);
		[self next];
	}
	return self;
}

+ (ICSqlite3Cursur *)cursorWithSqlite3:(ICSqlite3 *)sqlite3 sql:(NSString *)sql errorMessage:(const char**)bufferOrNull {
	return [[[self alloc] initWithSqlite3:sqlite3 sql:sql errorMessage:bufferOrNull] autorelease];
}

- (void)dealloc {
	if ( nil != statement ) {
		resultCode = sqlite3_finalize(statement);	
	}
	[super dealloc];
}

- (void)reset {
	resultCode = sqlite3_reset(statement);
	[self next];
}

- (void)next {
	resultCode = sqlite3_step(statement);
}

- (NSInteger)rowCount {
	return (NSInteger)sqlite3_data_count(statement);
}

- (NSInteger)columnCount {
	return (NSInteger)sqlite3_column_count(statement);
}

- (NSString *)nameAtColumnIndex:(NSInteger)index {
	return [NSString stringWithUTF8String:sqlite3_column_name(statement, (int)index)];
}

- (NSString *)stringValueAtColumnIndex:(NSInteger)index {
    const char *text = (const char*)sqlite3_column_text(statement, (int)index);
    if (text == NULL) return nil;
	return [NSString stringWithUTF8String:text];
}

- (NSUInteger)integerValueAtColumnIndex:(NSInteger)index {
	return sqlite3_column_int(statement, (int)index);
}

- (BOOL) isEndOfCursor {
	return resultCode == SQLITE_DONE;
}

/* deprecated set */
- (NSString*) getColumnName:(NSInteger)column {
	return [NSString stringWithUTF8String:sqlite3_column_name(statement, (int)column)];
}

- (NSString*) getColumnAsString:(NSInteger)column {
	return [NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, (int)column)];
}

- (NSUInteger)getColumnAsInteger:(NSInteger)column {
	return sqlite3_column_int(statement, (int)column);
}

@end


@implementation ICSqlite3

@synthesize resultCode;

- (id)init {
	if ((self = [super init]) != nil ) {
		database = nil;
		resultCode = 0;
		errorMessage = nil;
	}
	return self;
}

- (id)initWithMemory {
	self = [self init];
	[self openMemory];
	return self;
}

- (id)initWithFile:(NSString*)filename {
	self = [self init];
	[self openFile:filename];
	return self;
}

- (void)dealloc {
	if ( nil != database )
		[self close];
	[super dealloc];
}

- (NSString *)errorMessage {
	if ( nil == errorMessage ) {
		return @"";
	}
	NSString *msg = [[NSString alloc] initWithCString:errorMessage encoding:NSASCIIStringEncoding];
	sqlite3_free(errorMessage);
	errorMessage = nil;
	return [msg autorelease];
}

#pragma mark -
#pragma mark sqlite3 wrapping

- (void)openMemory {
	resultCode = sqlite3_open_v2(":memory:", &database, SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE, NULL);
}

// UTF-8
- (void)openFile:(NSString *)filename {
	ICLog(SQLITE3_DEBUG, @"dbfile: %@", filename);
	resultCode = sqlite3_open([filename UTF8String], &database);
}
// UTF-8
- (void)openFile:(NSString *)filename flags:(int)flags vfs:(const char *)zVfs {
	resultCode = sqlite3_open_v2([filename UTF8String], &database, flags, zVfs);
}

- (void)close {
	sqlite3_close(database);
	database = nil;
}

- (void)executeQuery:(NSString*)sql {
	resultCode = sqlite3_exec(database, [sql UTF8String], NULL, NULL, &errorMessage);
}

- (ICSqlite3Cursur*)cursorByQuery:(NSString*)sql {
	ICLog(SQLITE3_DEBUG, @"sql: %@", sql);
	if ( errorMessage ) {
		//sqlite3_free(errorMessage);
		errorMessage = nil;
	}
	ICSqlite3Cursur* cursor = [[ICSqlite3Cursur alloc] initWithSqlite3:self sql:sql errorMessage:(const char**)&errorMessage];
	resultCode = cursor.resultCode;
	return [cursor autorelease];
}

- (ICSqlite3Cursur *)cursorByFormat:(NSString *)format, ... {
	va_list args;
	va_start(args, format);
	ICSqlite3Cursur *cursor = [self cursorByQuery:[NSString stringWithFormat:format arguments:args]];
	va_end(args);
	return cursor;
}

#pragma mark -
#pragma mark sqlite3 constants

+ (int)versionNumber {
	return SQLITE_VERSION_NUMBER;
}

+ (int)libraryVersionNumber {
	return sqlite3_libversion_number();
}

@end



@implementation ICSQLInsertBuilder
@synthesize table=_table, data=_data;

- (id)initWithTable:(NSString *)table {
    self = [super init];
    if (self != nil) {
        self.table = table;
        _data = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (id)initWithTable:(NSString *)table data:(NSDictionary *)data {
    self = [super init];
    if (self != nil) {
        self.table = table;
        _data = [[NSMutableDictionary alloc] initWithDictionary:data];
    }
    return self;
}

- (void)dealloc {
    self.table = nil;
    [_data release];
    [super dealloc];
}

- (void)setData:(id)data forKey:(id)key {
    [self.data setObject:data forKey:key];
}

#pragma mark -

- (NSString *)query {
    if (self.data.count == 0) return nil;
    
    // NOTE: fix to get key/value pair for faster iteration
    NSArray *allKeys = self.data.allKeys;
    NSMutableArray *allObjects = [NSMutableArray array];
    for (id key in allKeys) {
        [allObjects addObject:[self.data objectForKey:key]];
    }
    
    NSMutableString *keyString = [NSMutableString stringWithString:@"`"];
    [keyString appendString:[allKeys componentsJoinedByString:@"`,`"]];
    [keyString appendString:@"`"];
    
    NSMutableString *valueString = [NSMutableString string];
    BOOL firstObject = YES;
    for (id value in allObjects) {
        if (firstObject) {
            firstObject = NO;
        } else {
            [valueString appendString:@","];
        }
        if ([value isKindOfClass:[NSNumber class]]) {
            [valueString appendString:[value stringValue]];
        } else {
            [valueString appendFormat:@"'%@'", [value stringByReplacingOccurrencesOfString:@"'" withString:@"''"]];
        }
    }
    
    return [NSString stringWithFormat:@"INSERT INTO `%@` (%@) VALUES (%@)",
            self.table,
            keyString,
            valueString];
}

- (NSString *)description {
    return self.query;
}

@end


