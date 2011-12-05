//
//  UIImageCachedControls.m
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

#import "NSTimerAdditions.h"
#import "UIImageAdditions.h"
#import "ICImageCachedControls.h"

#define ICCachedControlCheckDelay 0.22

//	virtual protocol to imitate common ICCachedControl
@protocol ICCachedControlCommonInterface
- (UIImage *)currentImageForProvider:(ICCachedControlProvider *)provider;
- (CGPoint)centerPointOfActivityIndicatorInProvider:(ICCachedControlProvider *)provider;
- (void)provider:(ICCachedControlProvider *)provider setImage:(UIImage *)image;
@end

@interface ICCachedControlProvider : UIActivityIndicatorView {
	NSString *imagePath;
	NSTimer *cacheTimer;
}
@property(nonatomic, retain) NSString *imagePath;
@property(nonatomic, readonly) UIControl<ICCachedControlCommonInterface> *cachedControl;

- (void)startLoading; - (void)stopLoading; - (void)unload;

+ (ICCachedControlProvider *) provider;
- (void)resetActivityIndicator;
- (ICCachedControlLoadState) loadState;

@end

@interface ICCachedControlProvider (Private)

- (void)reload;
- (void)checkCache:(NSTimer *)timer;

@end


@implementation ICCachedControlProvider
@synthesize imagePath;

+ (ICCachedControlProvider *) provider {
	return [[[self alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
}

- (UIControl <ICCachedControlCommonInterface>*) cachedControl {
	return (id)self.superview;
}

- (void) dealloc {
	[cacheTimer invalidate];
	[imagePath release];
	[super dealloc];
}

#pragma mark -
#pragma mark delegated method

- (void) resetActivityIndicator {
	CGPoint centerPoint = CGPointMake(self.cachedControl.frame.size.width/2, self.cachedControl.frame.size.height/2);
	if ( [self.cachedControl respondsToSelector:@selector(centerPointOfActivityIndicatorInProvider:)] ) {
		centerPoint = [self.cachedControl centerPointOfActivityIndicatorInProvider:self];
	}
	self.center = centerPoint;
	[self.cachedControl setNeedsLayout];
	[self.cachedControl layoutIfNeeded];
}

- (void)startLoading {
	if ( [self.cachedControl currentImageForProvider:self] != nil || cacheTimer != nil ) return;
	if ( imagePath == nil ) return;
	[self reload];
}

- (void)stopLoading {
	[cacheTimer invalidate];
	cacheTimer = nil;
	[self stopAnimating];
}

- (void)unload {
	[self stopLoading];
	[self.cachedControl provider:self setImage:nil];
}

- (void)setImagePath:(NSString *)path {
	if ( [imagePath isEqualToString:path] ) return;
	
	[imagePath release];
	imagePath = [path retain];	

	if ( cacheTimer == nil && [self.cachedControl currentImageForProvider:self] == nil ) return;	
	
	[self.cachedControl provider:self setImage:nil];
	[self reload];
}

- (ICCachedControlLoadState) loadState {
	if ( cacheTimer != nil ) return ICCachedControlLoadStateLoading;
	return [self.cachedControl currentImageForProvider:self] == nil ? ICCachedControlLoadStateUnload : ICCachedControlLoadStateLoaded;
}

@end

@implementation ICCachedControlProvider (Private)

- (void)checkCache:(NSTimer *)timer {
	if ( [ICCache isExists:imagePath] ) {
		[self.cachedControl provider:self setImage:[UIImage cachedImageWithContentOfAbstractPath:imagePath]];
		[self stopAnimating];
		cacheTimer = nil;
		[self.cachedControl setNeedsLayout];
		[self.cachedControl layoutIfNeeded];		
	} else {
		cacheTimer = [NSTimer delayedTimerWithTimeInterval:ICCachedControlCheckDelay target:self selector:@selector(checkCache:)];
	}
}

- (void) reload {
	[ICCache addPathToAsyncronizedCollector:imagePath];
	[self resetActivityIndicator];
	[self startAnimating];
	cacheTimer = [NSTimer zeroDelayedTimerWithTarget:self selector:@selector(checkCache:)];	
}

@end


#define ICCachedControlProviderMethodSynthesize		@synthesize imagePath, delegate;
#define ICCachedControlProviderMethodInitWithCoder	- (id)initWithCoder:(NSCoder *)aDecoder {	if ((self = [super initWithCoder:aDecoder]) != nil) {	cacheProvider = [ICCachedControlProvider provider];	[self addSubview:cacheProvider];	}	return self;	}
#define ICCachedControlProviderMethodInitWithFrame	- (id)initWithFrame:(CGRect)frame		{	if ((self = [super initWithFrame:frame]) != nil)	{	cacheProvider = [ICCachedControlProvider provider];	[self addSubview:cacheProvider];	}	return self;	}
#define ICCachedControlProviderMethodSetFrame		- (void)setFrame:(CGRect)frame			{	[super setFrame:frame];		[cacheProvider resetActivityIndicator];		}
#define ICCachedControlProviderMethodImagePath		- (NSString *)imagePath					{	return [cacheProvider imagePath];	}
#define ICCachedControlProviderMethodSetImagePath	- (void)setImagePath:(NSString *)path	{	[cacheProvider setImagePath:path];	}
#define ICCachedControlProviderMethodStartLoading	- (void)startLoading					{	[cacheProvider startLoading];		}
#define ICCachedControlProviderMethodStopLoading	- (void)stopLoading						{	[cacheProvider stopLoading];		}
#define ICCachedControlProviderMethodUnload			- (void)unload							{	[cacheProvider unload];				}
#define ICCachedControlProviderMethodLoadState		- (ICCachedControlLoadState) loadState	{	return [cacheProvider loadState];	}

#define ICCachedControlProviderMethodsFrame			ICCachedControlProviderMethodInitWithCoder	ICCachedControlProviderMethodInitWithFrame	ICCachedControlProviderMethodSetFrame
#define ICCachedControlProviderMethodsLoad			ICCachedControlProviderMethodStartLoading	ICCachedControlProviderMethodStopLoading	ICCachedControlProviderMethodUnload		ICCachedControlProviderMethodLoadState	ICCachedControlProviderMethodSetImagePath
#define ICCachedControlProviderMethodsAll			ICCachedControlProviderMethodSynthesize		ICCachedControlProviderMethodsFrame			ICCachedControlProviderMethodsLoad

@implementation ICCachedButton

ICCachedControlProviderMethodsAll

- (UIImage *) currentImageForProvider:(ICCachedControlProvider *)provider {
	return [self imageForState:UIControlStateNormal];
}

- (void) provider:(ICCachedControlProvider *)provider setImage:(UIImage *)image {
	[self setImage:image forState:UIControlStateNormal];
    [delegate cachedControl:self setImage:image];
}

@end

@implementation ICCachedImageView

ICCachedControlProviderMethodsAll

- (UIImage *) currentImageForProvider:(ICCachedControlProvider *)provider {
	return self.image;
}

- (void) provider:(ICCachedControlProvider *)provider setImage:(UIImage *)image {
	self.image = image;
    [delegate cachedControl:self setImage:image];
}

@end

@implementation ICCachedTableViewCell

ICCachedControlProviderMethodsAll

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) != nil) {
		cacheProvider = [ICCachedControlProvider provider];
		[self addSubview:cacheProvider];
	}
	return self;
}

- (UIImage *) currentImageForProvider:(ICCachedControlProvider *)provider {
	return self.imageView.image;
}

- (void) provider:(ICCachedControlProvider *)provider setImage:(UIImage *)image {
	self.imageView.image = image;
    [delegate cachedControl:self setImage:image];
}

- (CGPoint)centerPointOfActivityIndicatorInProvider:(ICCachedControlProvider *)provider {
	CGPoint centerPoint = CGPointMake(self.imageView.frame.size.width/2, self.imageView.frame.size.height/2);
	if ( centerPoint.x == 0.0f )
		centerPoint = CGPointMake(self.frame.size.height/2, self.frame.size.height/2); // rough assumption
	return centerPoint;
}

@end
