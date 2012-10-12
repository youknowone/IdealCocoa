//
//  UIImageAdditions.h
//  IdealCocoa
//
//  Created by youknowone on 10. 10. 5..
//  Copyright 2010 3rddev.org. All rights reserved.
//

#import <IdealCocoa/ICCache.h>

@interface UIImage (IdealCocoa)

- (UIImage *) imageByResizingToSize:(CGSize)size;

@end

@interface UIImage (IphacyCocoaICCache)

+ (UIImage *) cachedImageWithContentOfAbstractPath:(NSString *)path __deprecated;
+ (UIImage *) cachedImageWithContentOfURL:(NSURL *)URL options:(ICCacheOptions)options;
+ (UIImage *) cachedImageWithContentOfURL:(NSURL *)URL storage:(ICCacheStorage *)storage;
+ (UIImage *) cachedThumbnailImageWithContentOfAbstractPath:(NSString *)path asSize:(CGSize)size __deprecated;

@end

