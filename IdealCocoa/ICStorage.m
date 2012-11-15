//
//  ICStorage.m
//  IdealCocoa
//
//  Created by youknowone on 12. 2. 11..
//  Copyright (c) 2012 youknowone.org All rights reserved.
//

#include <sys/stat.h>

#import "ICStorage.h"

@interface ICStorage ()

@property(nonatomic, readonly) NSMutableDictionary *dataMap, *metaMap, *metaReverse;

- (id)initWithDataMap:(NSDictionary *)dictionary metaMap:(NSDictionary *)metaDictionary metaReverse:(NSDictionary *)metaReverseDictionary;
- (void)synchronizeOrMarkDirty;

- (NSMutableDictionary *)_metaDictionaryForKey:(NSString *)key;
- (NSMutableDictionary *)_keyArrayGroupForMetaKey:(NSString *)metaKey;
- (NSMutableArray *)_keyArrayForMetaValue:(id)value forMetaKey:(NSString *)metaKey;

@end

@implementation ICStorage
@synthesize dataMap=_dataMap, metaMap=_metaMap, metaReverse=_metaReverse;
@synthesize isDirty=_isDirty, hasAutosynchronization=_hasAutosynchronization;

- (void)synchronizeOrMarkDirty {
    if (self.hasAutosynchronization) {
        [self synchronize];
    } else {
        self->_isDirty = YES;
    }
}

- (id)init {
    self = [super init];
    if (self != nil) {
        self->_dataMap = [[NSMutableDictionary alloc] init];
        self->_metaMap = [[NSMutableDictionary alloc] init];
        self->_metaReverse = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (id)initWithDataMap:(NSDictionary *)dictionary metaMap:(NSDictionary *)metaDictionary metaReverse:(NSDictionary *)metaReverseDictionary {
    self = [super init];
    if (self != nil) {
        self->_dataMap = [[NSMutableDictionary alloc] initWithDictionary:dictionary];
        self->_metaMap = [[NSMutableDictionary alloc] initWithDictionary:metaDictionary];
        self->_metaReverse = [[NSMutableDictionary alloc] initWithDictionary:metaReverseDictionary];
    }
    return self;
}

- (void)dealloc {
    [self->_dataMap release];
    [super dealloc];
}

- (NSInteger)count {
    return self->_dataMap.count;
}

- (NSArray *)allKeys { 
    return self->_dataMap.allKeys; 
}

- (NSMutableDictionary *)_metaDictionaryForKey:(NSString *)key {
    id metaDictionary = [self.metaMap objectForKey:key];
    if (metaDictionary == nil) {
        metaDictionary = [NSMutableDictionary dictionary];
        [self.metaMap setObject:metaDictionary forKey:key];
    }
    else if (![metaDictionary isMemberOfClass:[NSMutableDictionary class]]) {
        metaDictionary = [NSMutableDictionary dictionaryWithDictionary:metaDictionary];
        [self.metaMap setObject:metaDictionary forKey:key];
    }
    return metaDictionary;
}

- (NSDictionary *)metaDictionaryForKey:(NSString *)key {
    return [self _metaDictionaryForKey:key];
}

- (NSMutableDictionary *)_keyArrayGroupForMetaKey:(NSString *)metaKey {
    id keyArrayGroup = [self.metaReverse objectForKey:metaKey];
    if (keyArrayGroup == nil) {
        keyArrayGroup = [NSMutableDictionary dictionary];
        [self.metaReverse setObject:keyArrayGroup forKey:metaKey];
    }
    else if (![keyArrayGroup isMemberOfClass:[NSMutableDictionary class]]) {
        keyArrayGroup = [NSMutableDictionary dictionaryWithDictionary:keyArrayGroup];
        [self.metaReverse setObject:keyArrayGroup forKey:metaKey];
    }
    return keyArrayGroup;
}

- (NSDictionary *)keyArrayGroupForMetaKey:(NSString *)metaKey {
    return [self _keyArrayGroupForMetaKey:metaKey];
}

- (NSMutableArray *)_keyArrayForMetaValue:(id)value forMetaKey:(NSString *)metaKey {
    NSDictionary *metaGroup = [self keyArrayGroupForMetaKey:metaKey];
    id keyArray = [metaGroup objectForKey:value];
    if (keyArray == nil) {
        keyArray = [NSMutableArray array];
        [metaGroup setValue:keyArray forKey:value];
    }
    else if (![keyArray isMemberOfClass:[NSMutableArray class]]) {
        keyArray = [NSMutableArray arrayWithArray:keyArray];
        [metaGroup setValue:keyArray forKey:value];
    }
    return keyArray;
}

- (NSArray *)keyArrayForMetaValue:(id)value forMetaKey:(NSString *)metaKey {
    return [self _keyArrayForMetaValue:value forMetaKey:metaKey];
}

- (void)setMetaData:(id)value forMetaKey:(NSString *)metaKey forDataKey:(NSString *)key {
    // add to meta map
    [[self _metaDictionaryForKey:key] setObject:value forKey:metaKey];
    
    // add to meta reverse
    NSMutableArray *keyArray = [self _keyArrayForMetaValue:value forMetaKey:metaKey];
    [keyArray addObject:key];
    
}

- (void)removeMetaDataForMetaKey:(NSString *)metaKey forDataKey:(NSString *)key {
    NSMutableDictionary *metaDictionary = [self _metaDictionaryForKey:key];
    id value = [metaDictionary objectForKey:metaKey];
    if (value != nil) {
        NSMutableArray *keyArray = [self _keyArrayForMetaValue:value forMetaKey:metaKey];
        [keyArray removeObject:key];
        [metaDictionary removeObjectForKey:metaKey];
    }
}

- (id)metaDataForMetaKey:(NSString *)metaKey forDataKey:(NSString *)dataKey {
    return [[self metaDictionaryForKey:dataKey] objectForKey:metaKey];
}

- (void)removeMetaDataForKey:(NSString *)key {
    NSArray *metaKeys = [self metaDictionaryForKey:key].allKeys;
    for (NSString *metaKey in metaKeys) {
        [self removeMetaDataForMetaKey:metaKey forDataKey:key];
    }
}

// abstract dummy
- (NSData *)dataForKey:(NSString *)key {
    return nil;
}

- (NSDictionary *)dataDictionaryForKeys:(NSArray *)keys {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithCapacity:keys.count];
    for (NSString *key in keys) {
        [dictionary setObject:[self dataForKey:key] forKey:key];
    }
    return dictionary;
}

- (void)removeDatasetForKeys:(NSArray *)keys {
    for (NSString *key in keys) {
        [self removeDataForKey:key];
    }
}

- (void)setData:(NSData *)data forKey:(NSString *)key {
    
}

- (void)removeDataForKey:(NSString *)key {
    [self removeMetaDataForKey:key];
}

- (void)removeAllData {
    [self->_dataMap removeAllObjects];
    [self->_metaMap removeAllObjects];
    [self->_metaReverse removeAllObjects];
}

- (void)synchronize {
    self->_isDirty = NO;
}

- (void)truncate { 
    [self->_dataMap removeAllObjects];
    [self->_metaMap removeAllObjects];
    [self->_metaReverse removeAllObjects];
}

- (void)shrink { }

@end

@implementation ICMemoryStorage

- (NSData *)dataForKey:(NSString *)key {
    return [self->_dataMap objectForKey:key];
}

- (NSDictionary *)dataDictionaryForKeys:(NSArray *)keys {
    return [self->_dataMap dictionaryWithValuesForKeys:keys];
}

- (void)setData:(NSData *)data forKey:(NSString *)key {
    [self->_dataMap setObject:data forKey:key];
}

- (void)removeDataForKey:(NSString *)key {
    [self->_dataMap removeObjectForKey:key];
    [self removeMetaDataForKey:key];
}

+ (id)storage {
    return [[[self alloc] init] autorelease];
}

@end

@interface ICUserDefaultsStorage ()

@property(nonatomic, readonly) NSUserDefaults *userDefaults;
@property(nonatomic, readonly) NSString *baseKey;
@property(nonatomic, readonly) NSDictionary *baseDictionary;

@end

@implementation ICUserDefaultsStorage
@synthesize userDefaults=_userDefaults, baseKey=_baseKey;

- (NSDictionary *)baseDictionary {
    return [self.userDefaults objectForKey:self.baseKey];
}

- (id)initWithUserDefaults:(NSUserDefaults *)userDefaults baseKey:(NSString *)userDefaultsKey {
    self->_userDefaults = [userDefaults retain];
    self->_baseKey = userDefaultsKey.copy;
    
    NSDictionary *baseDictionary = self.baseDictionary;
    if (baseDictionary == nil) {
        self = [super init];
    } else {
        NSDictionary *dataMap = [baseDictionary objectForKey:@"data"];
        NSDictionary *metaMap = [baseDictionary objectForKey:@"meta"];
        NSDictionary *metaReverse = [baseDictionary objectForKey:@"metar"];
        self = [super initWithDataMap:dataMap metaMap:metaMap metaReverse:metaReverse];
    }

    return self;    
}

+ (id)storageWithUserDefaults:(NSUserDefaults *)userDefaults baseKey:(NSString *)userDefaultsKey {
    return [[[self alloc] initWithUserDefaults:userDefaults baseKey:userDefaultsKey] autorelease];
}

- (void)dealloc {
    [self->_userDefaults release];
    [self->_baseKey release];
    [super dealloc];
}

- (NSData *)dataForKey:(NSString *)key {
    return [self->_dataMap objectForKey:key];
}

- (NSDictionary *)dataDictionaryForKeys:(NSArray *)keys {
    return [self->_dataMap dictionaryWithValuesForKeys:keys];
}

- (void)setData:(NSData *)data forKey:(NSString *)key {
    [self->_dataMap setObject:data forKey:key];
    [self synchronizeOrMarkDirty];
}

- (void)removeDataForKey:(NSString *)key {
    [self->_dataMap removeObjectForKey:key];
    [self synchronizeOrMarkDirty];
}

- (void)removeAllData {
    [super removeAllData];
    [self synchronizeOrMarkDirty];
}

- (void)truncate {
    [self.userDefaults removeObjectForKey:self->_baseKey];
    [super truncate];
    [self synchronizeOrMarkDirty];
}

- (void)synchronize {
    NSDictionary *syncObject = [NSDictionary dictionaryWithObjectsAndKeys:
                                self->_dataMap, @"data",
                                self->_metaMap, @"meta",
                                self->_metaReverse, @"metar",
                                nil];
    [self.userDefaults setObject:syncObject forKey:self.baseKey];
    [self.userDefaults synchronize];
    [super synchronize];
}

@end

@interface ICDiskStorage ()

@property(nonatomic, readonly) NSString *baseDirectory;
@property(nonatomic, readonly) NSString *dataMapFilePath, *metaMapFilePath, *metaReverseFilePath;

- (NSString *)filenameForKey:(NSString *)key;
- (NSString *)filepathForFile:(NSString *)filename;
- (NSString *)filepathForKey:(NSString *)key;

@end

@implementation ICDiskStorage
@synthesize baseDirectory=_baseDirectory;
@synthesize cacheStorage=_cacheStorage;

+ (void)initialize {
    if (self == [ICDiskStorage class]) {
        dlog(TRUE, @"config directory for ICDiskStorage: %@", NSUserConfigurationDirectory());
    }
}

- (NSString *)dataMapFilePath {
    return [self->_baseDirectory stringByAppendingString:@".datamap"];
}

- (NSString *)metaMapFilePath {
    return [self->_baseDirectory stringByAppendingFormat:@".metamap"];
}

- (NSString *)metaReverseFilePath {
    return [self->_baseDirectory stringByAppendingFormat:@".metareverse"];
}

- (NSString *)filenameForKey:(NSString *)key {
    return [[key digestBySHA1UsingEncoding:NSUTF8StringEncoding] hexadecimalString];
}

- (NSString *)filepathForFile:(NSString *)filename {
    return [self.baseDirectory stringByAppendingPathComponent:filename];
}

- (NSString *)filepathForKey:(NSString *)key {
    return [self filepathForFile:[self filenameForKey:key]];
}

- (id)initWithBaseDirectory:(NSString *)path {
    return [self initWithBaseDirectory:path secondaryCacheStorage:nil];
}

- (id)initWithBaseDirectory:(NSString *)path secondaryCacheStorage:(ICStorage *)storage {
    if ([path hasPrefix:@"/"]) {
        self->_baseDirectory = path.copy;
    } else {
        self->_baseDirectory = [[NSUserConfigurationDirectory() stringByAppendingFormat:@"/%@", path] retain];
    }
    
    NSDictionary *dataMap = [NSDictionary dictionaryWithContentsOfFile:self.dataMapFilePath];
    if (dataMap == nil) {
        self = [super init];
        NSFileManager *manager = [NSFileManager defaultManager];
        [manager createDirectoryAtPath:self.baseDirectory withIntermediateDirectories:YES attributes:nil error:NULL];
    } else {
        NSDictionary *metaMap = [NSDictionary dictionaryWithContentsOfFile:self.metaMapFilePath];
        NSDictionary *metaReverse = [NSDictionary dictionaryWithContentsOfFile:self.metaReverseFilePath];
        self = [super initWithDataMap:dataMap metaMap:metaMap metaReverse:metaReverse];
    }
    self.cacheStorage = storage;
    return self;    
}

+ (id)storageWithBaseDirectory:(NSString *)path {
    return [[[self alloc] initWithBaseDirectory:path] autorelease];
}

+ (id)storageWithBaseDirectory:(NSString *)path secondaryCacheStorage:(ICStorage *)storage {
    return [[[self alloc] initWithBaseDirectory:path secondaryCacheStorage:storage] autorelease];
}

- (NSData *)dataForKey:(NSString *)key {
    NSData *data = [self.cacheStorage dataForKey:key];
    if (data == nil) {
        NSString *path = [self filepathForKey:key];
        data = [NSData dataWithContentsOfFile:path];
        [self.cacheStorage setData:data forKey:key];
    }
    return data;
}

- (void)setData:(NSData *)data forKey:(NSString *)key {
    NSString *hash = [self filenameForKey:key];
    NSString *path = [self filepathForFile:hash];
    [data writeToFile:path atomically:YES];
    [self.dataMap setObject:hash forKey:key];
    [self synchronizeOrMarkDirty];
}

- (void)removeDataForKey:(NSString *)key {
    NSString *path = [self filepathForKey:key];

    NSFileManager *manager = [NSFileManager defaultManager];
    [manager removeItemAtPath:path error:NULL];
    
    [self.dataMap removeObjectForKey:key];
    [super removeDataForKey:key];
}

- (void)removeAllData {
    NSFileManager *manager = [NSFileManager defaultManager];
    [manager removeItemAtPath:self.baseDirectory error:NULL];
    [manager createDirectoryAtPath:self.baseDirectory withIntermediateDirectories:NO attributes:nil error:NULL];

    [super removeAllData];
    [self synchronizeOrMarkDirty];
}

- (void)truncate { 
    NSFileManager *manager = [NSFileManager defaultManager];
    [manager removeItemAtPath:self.baseDirectory error:NULL];
    [manager removeItemAtPath:self.dataMapFilePath error:NULL];
    
    [super truncate];
    [self synchronizeOrMarkDirty];
}

- (void)synchronize { 
    [self.dataMap writeToFile:self.dataMapFilePath atomically:YES];
    [self.metaMap writeToFile:self.metaMapFilePath atomically:YES];
    [self.metaReverse writeToFile:self.metaReverseFilePath atomically:YES];
}

- (void)shrink {
    [self.cacheStorage removeAllData];
}

@end
