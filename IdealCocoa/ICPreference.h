//
//  ICPreference.h
//  IdealCocoa
//
//  Created by youknowone on 10. 3. 10..
//  Copyright 2010 3rddev.org. All rights reserved.
//

@interface ICPreference : NSObject {
	NSMutableDictionary *attributes;
	NSString *path;
}

@property(nonatomic, retain) NSMutableDictionary *attributes;

+ (void)finalize;

- (id)initWithContentsOfFile:(NSString *)path;
- (void)writeToFile;

+ (void)setMainPreference:(ICPreference *)preference;
+ (ICPreference *)mainPreference;
+ (NSMutableDictionary *)mainDictionary;

@end

@interface ICPreferenceModule : NSObject
{
	ICPreference *preference;
}

- (id)initWithPreference:(ICPreference *)preference;
- (id)objectForKey:(NSString *)key;

- (NSMutableDictionary *)defaultPreference;
- (id)defaultObjectForKey:(NSString *)key;

@end
