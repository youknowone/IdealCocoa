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

+ (UIImage *) cachedImageWithContentOfAbstractPath:(NSString *)path;
+ (UIImage *) cachedImageWithContentOfURLString:(NSString *)URLString cachePolicy:(ICCachePolicy)policy;
+ (UIImage *) cachedImageWithContentOfURL:(NSURL *)URL cachePolicy:(ICCachePolicy)policy;
+ (UIImage *) cachedThumbnailImageWithContentOfAbstractPath:(NSString *)path asSize:(CGSize)size;

@end

