//
//  ICStorage.h
//  IdealCocoa
//
//  Created by 윤원 정 on 12. 2. 11..
//  Copyright (c) 2012년 youknowone.org. All rights reserved.
//

//  ICStorage provides common storage interface for simple key-value store.
//  Additionally, it also provides meta data dictionary to tagging values and
//  metadata-based searching.


@interface ICStorage: NSObject {
@protected
    NSMutableDictionary *_dataMap, *_metaMap, *_metaReverse;
    BOOL _isDirty, _hasAutosynchronization;
}
@property(nonatomic, assign) BOOL isDirty, hasAutosynchronization;

//  metadata implementation
- (void)setMetaData:(id)value forMetaKey:(NSString *)metaKey forDataKey:(NSString *)key;
- (void)removeMetaDataForMetaKey:(NSString *)metaKey forDataKey:(NSString *)key;
- (void)removeMetaDataForKey:(NSString *)key;
- (id)metaDataForMetaKey:(NSString *)metaKey forDataKey:(NSString *)dataKey;
- (NSArray *)keyArrayForMetaValue:(id)value forMetaKey:(NSString *)metaKey;
- (NSDictionary *)keyArrayGroupForMetaKey:(NSString *)metaKey;
- (NSDictionary *)metaDictionaryForKey:(NSString *)key;

//  Abstract storage interface
- (NSInteger)count;
- (NSArray *)allKeys;

- (NSData *)dataForKey:(NSString *)key;
- (NSDictionary *)dataDictionaryForKeys:(NSArray *)keys;

- (void)setData:(NSData *)data forKey:(NSString *)key;

- (void)removeDataForKey:(NSString *)key;
- (void)removeDatasetForKeys:(NSArray *)keys;
- (void)removeAllData;

- (void)synchronize;
- (void)truncate;
- (void)shrink;

@end

@interface ICMemoryStorage: ICStorage

+ (id)storage;

@end

@interface ICUserDefaultsStorage: ICStorage {
    NSUserDefaults *_userDefaults;
    NSString *_baseKey;
}

- (id)initWithUserDefaults:(NSUserDefaults *)userDefaults baseKey:(NSString *)userDefaultsKey;
+ (id)storageWithUserDefaults:(NSUserDefaults *)userDefaults baseKey:(NSString *)userDefaultsKey;

@end

@interface ICDiskStorage: ICStorage {
    NSString *_baseDirectory;
    ICStorage *_cacheStorage;
}
@property(nonatomic, retain) ICStorage *cacheStorage;

- (id)initWithBaseDirectory:(NSString *)path;
- (id)initWithBaseDirectory:(NSString *)path secondaryCacheStorage:(ICStorage *)storage;
+ (id)storageWithBaseDirectory:(NSString *)path;
+ (id)storageWithBaseDirectory:(NSString *)path secondaryCacheStorage:(ICStorage *)storage;

@end
