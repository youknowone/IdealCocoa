//
//  ICCoverFlowView.h
//  IdealCocoa
//
//  Created by youknowone on 10. 10. 16..
//  Copyright 2010 3rddev.org. All rights reserved.
//
//	Rewrite library from:
//

/*	FlowCoverView.h
 *
 *		FlowCover view engine; emulates CoverFlow.
 */

/***
 
 Copyright 2008 William Woody, All Rights Reserved.
 
 Redistribution and use in source and binary forms, with or without 
 modification, are permitted provided that the following conditions are met:
 
 Redistributions of source code must retain the above copyright notice, this 
 list of conditions and the following disclaimer.
 
 Neither the name of Chaos In Motion nor the names of its contributors may be 
 used to endorse or promote products derived from this software without 
 specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
 ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
 LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
 CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
 INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
 CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
 ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF 
 THE POSSIBILITY OF SUCH DAMAGE.
 
 Contact William Woody at woody@alumni.caltech.edu or at 
 woody@chaosinmotion.com. Chaos In Motion is at http://www.chaosinmotion.com
 
 ***/

#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>

#import <UIKitExtension/UIKitExtension.h>

@class DataCache;

@protocol ICCoverFlowViewDelegate;

/*	FlowCoverView
 *
 *	The flow cover view class; this is a drop-in view which calls into
 *	a delegate callback which controls the contents. This emulates the
 *	CoverFlow thingy from Apple.
 */

@interface ICCoverFlowView : UIView<UIControlTouchEvents>
{
	// Current state support
	GLfloat offset;
	
	NSTimer *timer;
	
	// UIControl touch state
	CFTimeInterval startTime;
	CGFloat startOffset;
	CGFloat startPos;
	CGPoint startTouch;
	CFTimeInterval lastTime;
	CGFloat lastPos;
	
	double startSpeed;
	double runDelta;
	
	// Delegate
	IBOutlet id<ICCoverFlowViewDelegate> delegate;
	
	// OpenGL ES support
    GLsizei backingWidth;
    GLsizei backingHeight;
    EAGLContext *context;
    GLuint viewRenderbuffer, viewFramebuffer;
    GLuint depthRenderbuffer;
	
	DataCache *cache;
	struct {
		unsigned int delegateImageForIndex:1;
		unsigned int delegateViewForIndex:1;
		unsigned int delegateDidScroll:1;
		unsigned int delegateWillBeginDragging:1;
		unsigned int delegateDidEndDragging:1;
		unsigned int delegateWillBeginDecelerating:1;
		unsigned int delegateDidEndDecelerating:1;
		unsigned int delegateDidSelectCoverAtIndex:1;
		unsigned int delegateDidEndScrollingAnimation:1;
		unsigned int delegateImageScale:1;
		unsigned int delegateDistanceBetweenCovers:1;
		unsigned int delegateAngleFromCenter:1;
		unsigned int delegateCentralPoint:1;
		unsigned int isTouchingSpot:1;
		unsigned int isCodeDrivenAction:1;
	} coverFlowFlags;
	unsigned int textureSize;
}

@property(nonatomic, assign) id<ICCoverFlowViewDelegate> delegate;
@property(nonatomic, assign) GLfloat offset;
@property(nonatomic, assign) NSUInteger currentIndex;

- (void)redraw;
- (void)setOffset:(CGFloat)offset animated:(BOOL)animated;
- (void)setCurrentIndex:(NSUInteger)index animated:(BOOL)animated;
//- (void)reloadData;

@property(nonatomic, readonly) NSInteger numberOfCovers;
@property(nonatomic, readonly) GLfloat imageScale;
@property(nonatomic, readonly) GLfloat distanceBetweenCovers;
@property(nonatomic, readonly) GLfloat angleFromCenter;
@property(nonatomic, readonly) CGPoint centralPoint;

@end

/*	ICCoverFlowViewDelegate
 *
 *		Provides the interface for the delegate used by my flow cover. This
 *	provides a way for me to get the image, to get the total number of images,
 *	and to send a select message
 *
 *	Change from youknowone <developer@3rddev.org>
 *	UIScrollView-like delegate
 */

@protocol ICCoverFlowViewDelegate<NSObject>
- (NSInteger)numberOfCoversInCoverFlowView:(ICCoverFlowView *)coverFlowView;

@optional
- (UIImage *)coverFlowView:(ICCoverFlowView *)coverFlowView imageForIndex:(NSUInteger)index;
- (UIView *)coverFlowView:(ICCoverFlowView *)coverFlowView viewForIndex:(NSUInteger)index;

- (void)coverFlowViewDidScroll:(ICCoverFlowView *)coverFlowView;				// any offset changes
- (void)coverFlowViewWillBeginDragging:(ICCoverFlowView *)coverFlowView;		// called on start of dragging (may require some time and or distance to move)
- (void)coverFlowViewDidEndDragging:(ICCoverFlowView *)coverFlowView;			// called on finger up if user dragged. decelerate is true if it will continue moving afterwards

- (void)coverFlowViewWillBeginDecelerating:(ICCoverFlowView *)coverFlowView;	// called on finger up as we are moving
- (void)coverFlowViewDidEndDecelerating:(ICCoverFlowView *)coverFlowView;		// called when scroll view grinds to a halt

- (void)coverFlowView:(ICCoverFlowView *)coverFlowView didSelectCoverAtIndex:(NSUInteger)index;

- (void)coverFlowViewDidEndScrollingAnimation:(ICCoverFlowView *)coverFlowView;	// called when setOffset:animated: finishes. not called if not animating

// methods below here affect core behavior of coverflow. be careful when implementing these.
// without implementation, default values are used.

- (GLfloat)imageScaleForCoverFlowView:(ICCoverFlowView *)coverFlowView;
// screen measured from -1.0f to 1.0f
- (GLfloat)distanceBetweenCoversInCoverFlowView:(ICCoverFlowView *)coverFlowView;
// angle measured from 0.0f to 1.0f
- (GLfloat)angleFromCenterOfCoverFlowView:(ICCoverFlowView *)coverFlowView;
// screen measured from -1.0f to 1.0f
- (CGPoint)centralPointOfCoverFlowView:(ICCoverFlowView *)coverFlowView;

- (NSUInteger)textureDepthForCoverFlowView;

@end



//-- temporary backup

/*	DataCache.h
 *
 *		This is a basic aged cache object; this stores up to the capacity
 *	number of objects, and objects which haven't been accessed are dropped
 */

/***
 
 Copyright 2008 William Woody, All Rights Reserved.
 
 Redistribution and use in source and binary forms, with or without 
 modification, are permitted provided that the following conditions are met:
 
 Redistributions of source code must retain the above copyright notice, this 
 list of conditions and the following disclaimer.
 
 Neither the name of Chaos In Motion nor the names of its contributors may be 
 used to endorse or promote products derived from this software without 
 specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
 ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
 LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
 CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
 INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
 CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
 ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF 
 THE POSSIBILITY OF SUCH DAMAGE.
 
 Contact William Woody at woody@alumni.caltech.edu or at 
 woody@chaosinmotion.com. Chaos In Motion is at http://www.chaosinmotion.com
 
 ***/

#import <Foundation/Foundation.h>


@interface DataCache : NSObject 
{
	NSUInteger fCapacity;
	NSMutableDictionary *fDictionary;
	NSMutableArray *fAge;
}

- (id)initWithCapacity:(NSUInteger)cap;

- (id)objectForKey:(id)key;
- (void)setObject:(id)value forKey:(id)key;

@end
