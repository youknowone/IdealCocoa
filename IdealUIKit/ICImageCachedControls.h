//
//  UIImageCachedControls.h
//  IdealCocoa
//
//  Created by youknowone on 10. 10. 5..
//  Copyright 2010 3rddev.org. All rights reserved.
//
//	This program is free software: you can redistribute it and/or modify
//	it under the terms of the GNU General Public License as published by
//	the Free Software Foundation, either version 3 of the License, or
//	(at your option) any later version.
//	
//	This program is distributed in the hope that it will be useful,
//	but WITHOUT ANY WARRANTY; without even the implied warranty of
//	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//	GNU General Public License for more details.
//	
//	You should have received a copy of the GNU General Public License
//	along with this program.  If not, see <http://www.gnu.org/licenses/>.
//

#import <UIKit/UIKit.h>

@class ICCachedControlProvider;

#define ICCachedControlData		ICCachedControlProvider *cacheProvider;
#define ICCachedControlMethod	\
	@property(nonatomic,retain) NSString *imagePath;		\
	@property(readonly) ICCachedControlLoadState loadState;	\
	- (void)startLoading; - (void)stopLoading; - (void)unload;
#define ICCachedControlInterface	{ ICCachedControlData } ICCachedControlMethod

typedef enum {
	ICCachedControlLoadStateUnload = 0,
	ICCachedControlLoadStateLoading= 1,
	ICCachedControlLoadStateLoaded = 2,
}	ICCachedControlLoadState;

@interface ICCachedButton : UIButton
ICCachedControlInterface
@end

@interface ICCachedImageView : UIImageView
ICCachedControlInterface
@end

@interface ICCachedTableViewCell : UITableViewCell
ICCachedControlInterface
@end
 
