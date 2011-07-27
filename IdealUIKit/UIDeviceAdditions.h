//
//  UIDeviceAdditions.h
//  IdealCocoa
//
//  Created by youknowone on 10. 10. 6..
//  Copyright 2010 3rddev.org. All rights reserved.
//

typedef enum {
	ICDeviceTypeUnknown = 0,
	ICDeviceTypePad    = 1,
	ICDeviceTypePhone  = 2,
	ICDeviceTypePod    = 3,
}	ICDeviceType;
#define ICDeviceTypeIsIPhoneOrIPodMask 2
#define ICDeviceTypeIsIPhoneOrIPod(deviceType) ((deviceType&ICDeviceTypeIsIPhoneOrIPodMask)>>1)

@interface UIDevice (IdealCocoa)

+ (NSString *)uniqueIdentifier;
+ (ICDeviceType)currentDeviceType;

@end
