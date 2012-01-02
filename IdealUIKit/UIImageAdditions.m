//
//  UIImageAdditions.m
//  IdealCocoa
//
//  Created by youknowone on 10. 10. 5..
//  Copyright 2010 3rddev.org. All rights reserved.
//

#import <IdealCocoa/ICCrypto.h>
#import "NSPathUtilitiesAddtions.h"
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
	return [UIImage imageWithData:[ICCache cachedDataWithContentOfAbstractPath:path]];
}

+ (UIImage *)cachedImageWithContentOfURLString:(NSString *)URLString cachePolicy:(ICCachePolicy)policy {
	return [UIImage imageWithData:[ICCache cachedDataWithContentOfURLString:URLString cachePolicy:policy]];
}

+ (UIImage *)cachedImageWithContentOfURL:(NSURL *)URL cachePolicy:(ICCachePolicy)policy {
    return [UIImage imageWithData:[ICCache cachedDataWithContentOfURL:URL cachePolicy:policy]];
}

+ (UIImage *)cachedThumbnailImageWithContentOfAbstractPath:(NSString *)path asSize:(CGSize)size {
	NSString *hashKey = [[path digestStringByMD5] stringByAppendingFormat:@"_%.0fx%.0f", size.width, size.height];
	NSString *hashPath = NSPathForUserConfigurationFile([hashKey stringByAppendingFormat:@"_%.0fx%.0f.cache", size.width, size.height]);
	NSString *cachedPath = [[ICCache hashDictionary] objectForKey:hashKey];
	if ( nil == cachedPath || ![cachedPath isEqualToString:path] ) {
		UIImage *sourceImage = [UIImage cachedImageWithContentOfAbstractPath:path];
		UIImage *image = [sourceImage imageByResizingToSize:size]; 
		NSData *resizedImageData = UIImagePNGRepresentation(image);
		[resizedImageData writeToFile:hashPath atomically:YES];
		[[ICCache hashDictionary] setObject:path forKey:hashKey];
		//[[ICCache hashPreference] writeToFile];
		ICLog(TRUE, @"image at %@ cached", path);
	}
	return [UIImage imageWithContentsOfFile:hashPath];
}

@end
