//
//  IdealUIKit.h
//  IdealCocoa
//
//  Created by youknowone on 10. 3. 6..
//  Copyright 2010 3rddev.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FoundationExtension/FoundationExtension.h>
#import <IdealCocoa/IdealCocoa.h>
#import <UIKitExtension/UIKitExtension.h>
#import <IdealUIKit/UIEventScrollView.h>
#import <IdealUIKit/ICImageCachedControls.h>
#import <IdealUIKit/ICTableViewCellCopyable.h>
#import <IdealUIKit/UIImageCacheAdditions.h>

//#import <IdealUIKit/ICCoverFlowView.h> // THIS IS NOT UNDER GPLv3.

#define UIViewAutoresizingFlexibleTopBottomMargin (UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin)
#define UIViewAutoresizingFlexibleLeftRightMargin (UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin)
#define UIViewAutoresizingFlexibleAllMargin       (UIViewAutoresizingFlexibleTopBottomMargin|UIViewAutoresizingFlexibleLeftRightMargin)
#define UIViewAutoresizingFlexibleSize            (UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth)
#define UIViewAutoresizingFlexibleAll             (UIViewAutoresizingFlexibleAllMargin|UIViewAutoresizingFlexibleSize)

#define UIAlertViewCancelButtonIndex 0

@protocol UIModalViewControllerDelegate
- (void)modalViewControllerDidDismissed:(UIViewController *)viewController;
@end
