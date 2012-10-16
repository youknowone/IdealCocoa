//
//  ICPreference.m
//  IdealCocoa
//
//  Created by youknowone on 10. 3. 10..
//  Copyright 2010 3rddev.org. All rights reserved.
//

#define PREF_DEBUG FALSE

#import "ICPreference.h"

@implementation ICPreference
@synthesize attributes;

- (id)initWithContentsOfFile:(NSString *)aPath {
	if ((self = [self init]) != nil ) {
		path = [aPath copy];
		attributes = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
		if ( nil == attributes ) {
			attributes = [[NSMutableDictionary alloc] init];
		}
		ICLog(PREF_DEBUG, @"preference data: %@", attributes);
		if ( nil == attributes ) return nil;
	}
	return self;
}

- (void)dealloc {
	[path release];
	[attributes release];
	[super dealloc];
}

- (void)writeToFile {
	[attributes writeToFile:path atomically:NO];
}

/// global
ICPreference *mainPreference;

+ (void)initialize {
	if ( self == [ICPreference class] ) {
        ICPreference *preference = [[ICPreference alloc] initWithContentsOfFile:NSPathForUserConfigurationFile(@"ICMainPreference.plist")];
		[self setMainPreference:preference];
        [preference release];
	}
}

+ (void)finalize {
	[self setMainPreference:nil];
}

+ (void)setMainPreference:(ICPreference *)preference {
	[mainPreference writeToFile];
	[mainPreference release];
	mainPreference = [preference retain];
}

+ (ICPreference *)mainPreference {
	return mainPreference;
}

+ (NSMutableDictionary *)mainDictionary {
	return [self mainPreference].attributes;
}

@end

@implementation ICPreferenceModule

- (id)initWithPreference:(ICPreference *)aPreference {
	if ((self = [self init]) != nil) {
		preference = [aPreference retain];
	}
	return self;
}

- (void)dealloc {
	[preference release];
	[super dealloc];
}

#pragma mark -

- (id)objectForKey:(NSString *)key {
	id object = [[self defaultPreference] objectForKey:key];
	if ( nil == object ) {
		[[self defaultPreference] setObject:[self defaultObjectForKey:key] forKey:key];
		object = [self objectForKey:key];
	}
	return object;
}

- (NSMutableDictionary *)defaultPreference {
	return preference.attributes;
}

- (id)defaultObjectForKey:(NSString *)key {
	return nil;
}

@end
