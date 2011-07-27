//
//  UIScrollViewAdditions.m
//  IdealCocoa
//
//  Created by youknowone on 11. 6. 15..
//  Copyright 2011 3rddev.org. All rights reserved.
//

#import "UIScrollViewAdditions.h"


@implementation UIScrollView (IdealCocoa)

- (CGRect) contentFrame {
	CGRect f;
	f.origin = self.frame.origin;
	f.size = self.contentSize;
	return f;
}

- (CGRect) contentBounds {
	CGRect f;
	f.origin = CGPointZero;
	f.size = self.contentSize;
	return f;
}

@end
