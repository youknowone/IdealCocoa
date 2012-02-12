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
//	SQL is SQL statement as ICSQLWrapper type

#import <sqlite3.h>

@class ICSqlite3Cursur;
@interface ICSqlite3 : NSObject {
	int resultCode;
	char *errorMessage;
@public
	sqlite3 *database;
}

@property(nonatomic, readonly) int resultCode;
@property(nonatomic, readonly) NSString *errorMessage;

- (id)initWithMemory;
- (id)initWithFile:(NSString*)filename;

- (void)openMemory;
- (void)openFile:(NSString *)filename;
- (void)openFile:(NSString *)filename flags:(int)flags vfs:(const char *)zVfsOrNull;
- (void)close;

- (void)executeQuery:(NSString *)sql;
- (ICSqlite3Cursur*)cursorByQuery:(NSString *)sql;
- (ICSqlite3Cursur*)cursorByFormat:(NSString*)format, ... NS_FORMAT_FUNCTION(1,2);

+ (int)versionNumber;
+ (int)libraryVersionNumber;

@end

@interface ICSqlite3Cursur: NSObject {
	int resultCode;
	sqlite3_stmt *statement;
}

@property(nonatomic, readonly) int resultCode;
@property(nonatomic, readonly, getter = isEndOfCursor) BOOL endOfCursor;
@property(nonatomic, readonly) NSInteger rowCount, columnCount;

- (id)initWithSqlite3:(ICSqlite3 *)sqlite3 sql:(NSString *)sql errorMessage:(const char**)bufferOrNull;
+ (ICSqlite3Cursur *)cursorWithSqlite3:(ICSqlite3 *)sqlite3 sql:(NSString *)sql errorMessage:(const char**)bufferOrNull;

- (void)reset;
- (void)next;

- (NSString *)nameAtColumnIndex:(NSInteger)index;
- (NSString *)stringValueAtColumnIndex:(NSInteger)index;
- (NSUInteger)integerValueAtColumnIndex:(NSInteger)index;

@end

// temporary paste here for partial implementation

@interface ICSQLInsertBuilder : NSObject {
    NSString *_table;
    NSMutableDictionary *_data;
}

@property(nonatomic, readonly) NSString *query;
@property(nonatomic, copy) NSString *table;
@property(nonatomic, readonly) NSMutableDictionary *data;

- (id)initWithTable:(NSString *)table;
- (id)initWithTable:(NSString *)table data:(NSDictionary *)data;

- (void)setData:(id)data forKey:(id)key;

@end
