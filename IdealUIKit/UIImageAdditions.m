//
//  UIImageAdditions.m
//  IdealCocoa
//
//  Created by youknowone on 10. 10. 5..
//  Copyright 2010 3rddev.org. All rights reserved.
//

#import <IdealCocoa/ICCrypto.h>
#import "NSPathUtilitiesAddtions.h"
#import "NSURLAdditions.h"
#import "UIImageAdditions.h"

@implementation UIImage (IdealCocoa) 

- (UIImage *)imageByResizingToSize:(CGSize)size {
	CGRect thumbRect = CGRectZero;
	thumbRect.size = size;
	CGImageRef imageRef = [self CGImage];

	CGContextRef bitmap = CGBitmapContextCreate(
												NULL,
												(size_t)thumbRect.size.width,		// width
												(size_t)thumbRect.size.height,		// height
												CGImageGetBitsPerComponent(imageRef),
												CGImageGetBytesPerRow(imageRef),	// rowbytes
												CGImageGetColorSpace(imageRef),
												CGImageGetBitmapInfo(imageRef)
												);
	
	CGContextDrawImage(bitmap, thumbRect, imageRef);
	
	CGImageRef	ref = CGBitmapContextCreateImage(bitmap);
	UIImage *result = [UIImage imageWithCGImage:ref];
	
	CGContextRelease(bitmap);	// ok if NULL
	CGImageRelease(ref);
	
	return result;
}

@end

@implementation UIImage (IdealCocoaICCache)

+ (UIImage *)cachedImageWithContentOfAbstractPath:(NSString *)path {
	return [self imageWithData:[ICCache cachedDataWithContentOfAbstractPath:path]];
}

+ (UIImage *)cachedImageWithContentOfURL:(NSURL *)URL options:(ICCacheOptions)options {
    return [self imageWithData:[ICCache cachedDataWithContentOfURL:URL options:options]];
}

+ (UIImage *)cachedImageWithContentOfURL:(NSURL *)URL storage:(ICCacheStorage *)storage {
    return [self imageWithData:[ICCache cachedDataWithContentOfURL:URL storage:storage]];
}

+ (UIImage *)cachedThumbnailImageWithContentOfAbstractPath:(NSString *)path asSize:(CGSize)size {
    ICCacheStorage *cacheStorage = [ICCache defaultStorageForOptions:ICCacheOptionPermanent|ICCacheOptionDisk];
    NSString *sizedPath = [path stringByAppendingFormat:@":#thumb%.0fx%.0f", size.width, size.height];
    NSData *thumbnailData = [cacheStorage dataForKey:sizedPath];
    if (thumbnailData == nil) {
        NSData *sourceData = [cacheStorage dataForKey:path];
        if (sourceData == nil) {
            sourceData = [NSData dataWithContentsOfURL:path.abstractURL];
        }
        UIImage *sourceImage = [UIImage imageWithData:sourceData];
		UIImage *image = [sourceImage imageByResizingToSize:size]; 
		NSData *thumbnailData = UIImagePNGRepresentation(image);
        [cacheStorage setData:thumbnailData forKey:sizedPath];
	}
	return [self imageWithData:thumbnailData];
}

@end
