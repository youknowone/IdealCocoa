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
//  ICSqlite3.h
//  IdealCocoa
//
//  Created by youknowone on 09. 12. 9..
//  Copyright 2010 3rddev.org. All rights reserved.
//
//  This file follow lisence of original sqlite3 (see upper part)
//

//
//	In this file:
//	Query is SQL statement as NSString type
//	SQL is SQL statement as ICSQL type

#import <sqlite3.h>
#import <IdealCocoa/ICSQL.h>

@class ICSqlite3Cursur;
@interface ICSqlite3 : NSObject {
	int resultCode;
	char *errorMessage;
@public
	sqlite3 *database;
}

@property(nonatomic, readonly) int resultCode;
- (NSString *)errorMessage;

- (id)initWithMemory;
- (id)initWithFile:(NSString*)filename;

- (void)openMemory;
- (void)openFile:(NSString *)filename;
- (void)openFile:(NSString *)filename flags:(int)flags vfs:(const char *)zVfsOrNull;
- (void)close;

- (void)executeQuery:(NSString *)sql;
- (void)executeSQL:(ICSQL *)sql;
- (ICSqlite3Cursur*)cursorWithQuery:(NSString *)sql;
- (ICSqlite3Cursur*)cursorWithFormat:(NSString*)format, ... NS_FORMAT_FUNCTION(1,2);
- (ICSqlite3Cursur*)cursorWithSQL:(ICSQL *)sql;

+ (int)versionNumber;
+ (int)libraryVersionNumber;

@end

@interface ICSqlite3Cursur: NSObject {
	int resultCode;
	sqlite3_stmt *statement;
}

@property(nonatomic, readonly) int resultCode;

- (id)initWithSqlite3:(ICSqlite3 *)sqlite3 sql:(NSString *)sql errorMessage:(const char**)bufferOrNull;
+ (ICSqlite3Cursur *)cursorWithSqlite3:(ICSqlite3 *)sqlite3 sql:(NSString *)sql errorMessage:(const char**)bufferOrNull;

- (void)reset;
- (void)next;
- (NSInteger)rowCount;
- (NSInteger)columnCount;
- (BOOL)endOfCursor;
- (NSString *)nameAtColumnIndex:(NSInteger)index;
- (NSString *)stringValueAtColumnIndex:(NSInteger)index;
- (NSUInteger)integerValueAtColumnIndex:(NSInteger)index;

- (NSString *)getColumnName:(NSInteger)column __deprecated;
- (NSString *)getColumnAsString:(NSInteger)column __deprecated;
- (NSUInteger)getColumnAsInteger:(NSInteger)column __deprecated;

@end
