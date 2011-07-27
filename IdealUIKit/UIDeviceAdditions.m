//
//  UIDeviceAdditions.m
//  IdealCocoa
//
//  Created by youknowone on 10. 10. 6..
//  Copyright 2010 3rddev.org. All rights reserved.
//

#import "UIDeviceAdditions.h"

@implementation UIDevice (IdealCocoa)

+ (NSString *)uniqueIdentifier {
	return [[UIDevice currentDevice] uniqueIdentifier];	
}

ICDeviceType _deviceType;
+ (ICDeviceType) currentDeviceType {
	return _deviceType;
}

+ (void)initialize {
	if ( self == [UIDevice class] ) {
		// FIXME: use device constant to define these
		UIDevice *currentDevice = [UIDevice currentDevice];
		if ( [[currentDevice model] isEqualToString:@"iPhone"] ) {
			_deviceType = ICDeviceTypePhone;
		} else if ( [[currentDevice model] isEqualToString:@"iPod touch"] ) {
			_deviceType = ICDeviceTypePod;
		} else if ( [[currentDevice model] isEqualToString:@"iPad"] ) {
			_deviceType = ICDeviceTypePad;
		} else {
			_deviceType = ICDeviceTypeUnknown;
			NSLog(@"failed to detect device!!");
			// try again
			CGFloat screenWidth = [UIScreen mainScreen].applicationFrame.size.width;
			ICLog(TRUE, @"check device resolution: %.0f", screenWidth);
			if ( screenWidth == 320.0f ) {
				_deviceType = ICDeviceTypePhone;
			} else if ( screenWidth == 768.0f ) {
				_deviceType = ICDeviceTypePad;
			} else {
				_deviceType = ICDeviceTypeUnknown;
				ICAssert(NO);
			}
		}
	}
}

@end
