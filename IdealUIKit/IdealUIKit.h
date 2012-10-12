//
//  IdealUIKit.h
//  IdealCocoa
//
//  Created by youknowone on 10. 3. 6..
//  Copyright 2010 3rddev.org. All rights reserved.
//
//	This program is free software: you can redistribute it and/or modify
//	it under the terms of the GNU Lesser General Public License as published by
//	the Free Software Foundation, either version 3 of the License, or
//	(at your option) any later version.
//	
//	This program is distributed in the hope that it will be useful,
//	but WITHOUT ANY WARRANTY; without even the implied warranty of
//	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//	GNU Lesser General Public License for more details.
//	
//	You should have received a copy of the GNU Lesser General Public License
//	along with this program.  If not, see <http://www.gnu.org/licenses/>.
//

#import <UIKit/UIKit.h>
#import <IdealAdditions/IdealAdditions.h>
#import <IdealCocoa/IdealCocoa.h>
#import <IdealUIAdditions/IdealUIAdditions.h>
#import <IdealUIKit/UIEventScrollView.h>
#import <IdealUIKit/ICImageCachedControls.h>
#import <IdealUIKit/ICTableViewCellCopyable.h>

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
