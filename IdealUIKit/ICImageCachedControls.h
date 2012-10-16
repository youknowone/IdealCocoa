//
//  UIImageCachedControls.h
//  IdealCocoa
//
//  Created by youknowone on 10. 10. 5..
//  Copyright 2010 3rddev.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ICCachedControlDelegate

- (void)cachedControl:(id)control setImage:(UIImage *)image;

@end

@class ICCachedControlProvider;

#define ICCachedControlData		ICCachedControlProvider *cacheProvider; id<ICCachedControlDelegate> delegate;
#define ICCachedControlMethod	\
    @property(nonatomic,assign) id<ICCachedControlDelegate> delegate; \
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
 
