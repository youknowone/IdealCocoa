//
//  ICCoverFlowView.m
//  IdealCocoa
//
//  Created by youknowone on 10. 10. 16..
//  Copyright 2010 3rddev.org. All rights reserved.
//
//	Rewrite library from:
//

#define COVERFLOW_DEBUG FALSE

/*	FlowCoverView.m
 *
 *	FlowCover view engine; emulates CoverFlow.
 *
 *	Copyright 2008 William Woody, all rights reserved.
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

#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/ES1/glext.h>

#import "ICCoverFlowView.h"

/************************************************************************/
/*																		*/
/*	Internal Layout Constants											*/
/*																		*/
/************************************************************************/

#define TEXTURE_DEPTH	8		// texture depth, 8 max
#define textureSize		256 // FIXME:
#define MAXTILES		48		// maximum allocated 256x256 tiles in cache

/*
 *	Parameters to tweak layout and animation behaviors
 */

#define ICCoverFlowViewScrollSpeedFactor	6.0f
#define ICCoverFlowViewMaxScrollSpeed		3.0
#define ICCoverFlowViewScrollFriction		9.0

#define MOVEPOSTHRESHOLD	3.0f	// move lesser than this pixels are ignored
#define MOVINGTIMETHRESHOLD 0.16	// after this second, start point is reset

#define DECELERATETIMETHRESHOLD 0.1		// lesser than this move does not drive decelerating
#define DECELERATEMOVETHRESHOLD 0.4f	// lesser than this move does not drive decelerating

/************************************************************************/
/*																		*/
/*	Internal FlowCover Object											*/
/*																		*/
/************************************************************************/

@interface ICCoverFlowTexture : NSObject
{
	GLuint	texture;
}

@property GLuint texture;

- (id)initWithTexture:(GLuint)texture;

@end

@implementation ICCoverFlowTexture
@synthesize texture;

- (id)initWithTexture:(GLuint)aTexture
{
	if ((self = [super init]) != nil) {
		texture = aTexture;
	}
	return self;
}

- (void)dealloc
{
	glDeleteTextures(1, &texture);
	[super dealloc];
}

@end

@interface ICCoverFlowView (Private)

- (BOOL)setOffsetFitInBounds;

@end

@interface ICCoverFlowView (PrivateOpenGLES)

// OpenGL ES Support
- (BOOL)createFrameBuffer;
- (void)destroyFrameBuffer;

// draw
- (void)draw;	// top-level. Draw the CoverFlow view with current state
- (void)drawTile:(NSUInteger)index relativeOffset:(CGFloat)relativeOffset;
- (ICCoverFlowTexture *)textureAtIndex:(NSUInteger)index;
- (GLuint)glTextureFromImage:(UIImage *)image;
- (GLuint)glTextureFromView:(UIView *)view;

@end

@interface ICCoverFlowView (PrivateAnimation)

- (void)startAnimationToOffset:(GLfloat)newOffset asCodeDriven:(BOOL)flag;
- (void)driveAnimation;
- (void)updateAnimationAtTime:(CFTimeInterval)elapsed;
- (void)endAnimation;

@end

@implementation ICCoverFlowView

@synthesize delegate;
@synthesize offset;

+ (Class)layerClass
{
	return [CAEAGLLayer class];
}

- (void)layoutSubviews
{
    [EAGLContext setCurrentContext:context];
    [self destroyFrameBuffer];
    [self createFrameBuffer];
	[self draw];
}

#pragma mark -
#pragma mark life cycle

static int ICCoverFlowViewCount = 0;
//DataCache *cache;

/*	internalInit
 *
 *	Handles the common initialization tasks from the initWithFrame
 *	and initWithCoder routines
 */

- (id)initAsICCoverFlowView
{
	CAEAGLLayer *eaglLayer;
	
	eaglLayer = (CAEAGLLayer *)self.layer;
	eaglLayer.opaque = YES;
	
	context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
	if (!context || ![EAGLContext setCurrentContext:context] || ![self createFrameBuffer]) {
		// failed to initilize
		[self release];
		return nil;
	}
	offset = 0.0f;
	
    cache = [[DataCache alloc] initWithCapacity:MAXTILES];
	
	ICCoverFlowViewCount += 1;
	//textureSize = 256; // FIXME: temp value
	
	return self;
}

- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
	self = [self initAsICCoverFlowView];
    return self;
}

- (id)initWithCoder:(NSCoder *)coder 
{
    if ((self = [super initWithCoder:coder]) != nil) {
		self.backgroundColor = [UIColor clearColor];
		self = [self initAsICCoverFlowView];
	}
    return self;
}

- (void)dealloc 
{
	ICCoverFlowViewCount -= 1;
	
    [EAGLContext setCurrentContext:context];
	
	[self destroyFrameBuffer];
	[cache release];
	
	[EAGLContext setCurrentContext:nil];
    
	[context release];
	[super dealloc];
}

- (void)redraw {
    [self draw];
}

#pragma mark -
#pragma mark UIControl events

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	CGPoint where = [[touches anyObject] locationInView:self];
	startPos = where.x / self.bounds.size.width;
	startOffset = offset;
	
	coverFlowFlags.isTouchingSpot = YES;
	
	startTouch = where;
	startTime = lastTime = CACurrentMediaTime();
	lastPos = startPos;
	
	[self endAnimation];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	CGPoint where = [[touches anyObject] locationInView:self];
	CGFloat pos = where.x / self.bounds.size.width;
	
	if (coverFlowFlags.isTouchingSpot) {
		// determine if the user is dragging or not
		CGFloat dx = fabsf(where.x - startTouch.x);
		CGFloat dy = fabsf(where.y - startTouch.y);
		if ( (dx < MOVEPOSTHRESHOLD) && (dy < MOVEPOSTHRESHOLD) ) return;
		coverFlowFlags.isTouchingSpot = NO;
		if ( coverFlowFlags.delegateWillBeginDragging )
			[delegate coverFlowViewWillBeginDragging:self];
	}
	
	offset = startOffset + (startPos - pos) * ICCoverFlowViewScrollSpeedFactor;
	[self setOffsetFitInBounds];
	[self draw];
	if ( coverFlowFlags.delegateDidScroll ) {
		[delegate coverFlowViewDidScroll:self];
	}
	
	CFTimeInterval time = CACurrentMediaTime();
	if (time - lastTime > MOVINGTIMETHRESHOLD) {
		lastTime = time;
		lastPos = pos;
	} else if ( time - lastTime > MOVINGTIMETHRESHOLD*2 ) {
		startTime = time;
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	CGRect r = self.bounds;
	CGPoint where = [[touches anyObject] locationInView:self];
	CGFloat pos = where.x / r.size.width;
	
	if (coverFlowFlags.isTouchingSpot == YES) {
		coverFlowFlags.isTouchingSpot = NO;
		// Touched location; only accept on touching inner 256x256 area
		r.origin.x += (r.size.width - 256.0f)/2;
		r.origin.y += (r.size.height - 256.0f)/2;
		r.size.width = 256.0f;
		r.size.height = 256.0f;
		
		if (CGRectContainsPoint(r, where)) {
			if ( coverFlowFlags.delegateDidSelectCoverAtIndex ) {
				[delegate coverFlowView:self didSelectCoverAtIndex:self.currentIndex];
			}
		} else {
			/*
			 *	Change from youknowone <developer@3rddev.org>
			 *	add right/left side touch event
			 */
			r.size.width += r.origin.x;
			if (CGRectContainsPoint(r, where)) {
				{
					[self startAnimationToOffset:offset+1.0f asCodeDriven:NO];
				}
			} else {
				r.origin.x = 0.0f;
				if ( CGRectContainsPoint(r, where) ) {
					[self startAnimationToOffset:offset-1.0f asCodeDriven:NO];
				}
			}
		}
	} else {
		// Start animation to nearest
		offset = startOffset += (startPos - pos) * ICCoverFlowViewScrollSpeedFactor;
		[self setOffsetFitInBounds];
		CFTimeInterval ctime = CACurrentMediaTime();
		double maxSpeed = ICCoverFlowViewMaxScrollSpeed;
		double speed = (lastPos - pos)/(ctime - lastTime);
		if (speed > maxSpeed) speed = maxSpeed;
		if (speed <-maxSpeed) speed =-maxSpeed;
		/*
		 *	Change from youknowone <developer@3rddev.org>
		 *	
		 *	scroll to boundary should be returned to main
		 *	short move should not drive decelerating animation
		 */
		if ( speed >= 0.25 && fabs(startPos-pos) < DECELERATEMOVETHRESHOLD && ctime-startTime < DECELERATETIMETHRESHOLD ) {
			dlog(COVERFLOW_DEBUG, @"short move so speed is zero. start: %.2f current: %.2f threshold m/t: %.2f/%.2f", startPos, pos, DECELERATEMOVETHRESHOLD, DECELERATETIMETHRESHOLD);
			speed = speed>=0.0 ? 0.25 : -0.25;
		}
		/* end of change */
		speed *= ICCoverFlowViewScrollSpeedFactor * 0.7f;
		dlog(COVERFLOW_DEBUG, @"speed: %lf", speed);
		GLfloat delta = (GLfloat)(speed * speed / (ICCoverFlowViewScrollFriction * 2));
		if (speed < 0) delta = -delta;
		GLfloat newOffset = floorf(startOffset + delta + 0.5f);
		
		[self startAnimationToOffset:newOffset asCodeDriven:NO];
		
		if ( coverFlowFlags.delegateDidEndDragging )
			[delegate coverFlowViewDidEndDragging:self];
	}
}

#pragma mark -
#pragma mark info

- (NSInteger) numberOfCovers {
	return [delegate numberOfCoversInCoverFlowView:self];
}

- (GLfloat) imageScale {
	return coverFlowFlags.delegateImageScale ? [delegate imageScaleForCoverFlowView:self] : 0.45f;
}

- (GLfloat) distanceBetweenCovers {
	return coverFlowFlags.delegateDistanceBetweenCovers ? [delegate distanceBetweenCoversInCoverFlowView:self] : 0.12f;
}

- (GLfloat) angleFromCenter {
	return coverFlowFlags.delegateAngleFromCenter ? [delegate angleFromCenterOfCoverFlowView:self] : 0.35f;
}

- (CGPoint) centralPoint {
	return coverFlowFlags.delegateCentralPoint ? [delegate centralPointOfCoverFlowView:self] : CGPointMake(0.0f, 0.0f);
}

#pragma mark -
#pragma mark property interface

- (void) setDelegate:(id <ICCoverFlowViewDelegate>)newDelegate {
    if (delegate == newDelegate) return;
	delegate = newDelegate;
    coverFlowFlags.delegateImageForIndex = [delegate respondsToSelector:@selector(coverFlowView:imageForIndex:)];
	coverFlowFlags.delegateViewForIndex = [delegate respondsToSelector:@selector(coverFlowView:viewForIndex:)];
	coverFlowFlags.delegateDidScroll = [delegate respondsToSelector:@selector(coverFlowViewDidScroll:)];
	coverFlowFlags.delegateWillBeginDragging = [delegate respondsToSelector:@selector(coverFlowViewWillBeginDragging:)];
	coverFlowFlags.delegateDidEndDragging = [delegate respondsToSelector:@selector(coverFlowViewDidEndDragging:)];
	coverFlowFlags.delegateWillBeginDecelerating = [delegate respondsToSelector:@selector(coverFlowViewWillBeginDecelerating:)];
	coverFlowFlags.delegateDidEndDecelerating = [delegate respondsToSelector:@selector(coverFlowViewDidEndDecelerating:)];
	coverFlowFlags.delegateDidSelectCoverAtIndex = [delegate respondsToSelector:@selector(coverFlowView:didSelectCoverAtIndex:)];
	coverFlowFlags.delegateDidEndScrollingAnimation = [delegate respondsToSelector:@selector(coverFlowViewDidEndScrollingAnimation:)];
	coverFlowFlags.delegateImageScale = [delegate respondsToSelector:@selector(imageScaleForCoverFlowView:)];
	coverFlowFlags.delegateDistanceBetweenCovers = [delegate respondsToSelector:@selector(distanceBetweenCoversInCoverFlowView:)];
	coverFlowFlags.delegateAngleFromCenter = [delegate respondsToSelector:@selector(angleFromCenterOfCoverFlowView:)];
	coverFlowFlags.delegateCentralPoint = [delegate respondsToSelector:@selector(centralPointOfCoverFlowView:)];
	//BOOL isDepthSet = [delegate respondsToSelector:@selector(textureDepthForCoverFlowView)];
	//textureSize = 256;// isDepthSet ? 1 << [delegate textureDepthForCoverFlowView] : TEXTURE_DEPTH;
}

- (void) setOffset:(CGFloat)newOffset animated:(BOOL)animated {
	if ( animated ) {
		startOffset = offset;
		[self startAnimationToOffset:newOffset asCodeDriven:YES];
	} else {
		offset = newOffset;
		[self setOffsetFitInBounds];
		[self draw];
	}
}

- (void) setOffset:(CGFloat)newOffset {
	[self setOffset:newOffset animated:YES];
}

- (void)setCurrentIndex:(NSUInteger)index animated:(BOOL)animated {
	[self setOffset:index animated:animated];
}

- (void)setCurrentIndex:(NSUInteger)index {
	[self setOffset:index];
}

- (NSUInteger)currentIndex {
	return (NSUInteger)(offset+0.5);
}

@end

@implementation ICCoverFlowView (Private)

- (BOOL)setOffsetFitInBounds {
	if (offset < -0.49f) {
		offset = -0.49f;
		return YES;
	}
	CGFloat maxOffset = [delegate numberOfCoversInCoverFlowView:self] - 0.51f;
	if (offset > maxOffset) {
		offset = maxOffset;
		return YES;
	}
	return NO;
}

@end

@implementation ICCoverFlowView (PrivateOpenGLES)

- (BOOL) createFrameBuffer
{
	// Create an abstract frame buffer
    glGenFramebuffersOES(1, &viewFramebuffer);
    glGenRenderbuffersOES(1, &viewRenderbuffer);
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
	
	// Create a render buffer with color, attach to view and attach to frame buffer
    [context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:(id<EAGLDrawable>)self.layer];
    glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, viewRenderbuffer);
    
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &backingWidth);
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &backingHeight);
	
    if (glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES) {
		dlog(COVERFLOW_DEBUG, @"failed to make complete framebuffer object %x", glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
        return NO;
    }
    
    return YES;
}

- (void)destroyFrameBuffer
{
    glDeleteFramebuffersOES(1, &viewFramebuffer);
    viewFramebuffer = 0;
    glDeleteRenderbuffersOES(1, &viewRenderbuffer);
    viewRenderbuffer = 0;
    
    if(depthRenderbuffer) {
        glDeleteRenderbuffersOES(1, &depthRenderbuffer);
        depthRenderbuffer = 0;
    }
}

#pragma mark -
#pragma mark draw

/************************************************************************/
/*																		*/
/*	Model Constants														*/
/*																		*/
/************************************************************************/

const GLfloat GVertices[] = {
	-1.0f, -1.0f, 0.0f,
	+1.0f, -1.0f, 0.0f,
	-1.0f, +1.0f, 0.0f,
	+1.0f, +1.0f, 0.0f,
};

const GLshort GTextures[] = {
	0, 0,
	1, 0,
	0, 1,
	1, 1,
};

- (void)draw
{
	/*
	 *	Get the current aspect ratio and initialize the viewport
	 */
	
	GLfloat aspect = ((GLfloat)backingWidth)/backingHeight;
	
	glViewport(0,0,backingWidth,backingHeight);
	glDisable(GL_DEPTH_TEST);				// using painters algorithm
	
	glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
	glVertexPointer(3,GL_FLOAT,0,GVertices);
	glEnableClientState(GL_VERTEX_ARRAY);
	glTexCoordPointer(2, GL_SHORT, 0, GTextures);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	
	glEnable(GL_TEXTURE_2D);
	glBlendFunc(GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);
	glEnable(GL_BLEND);
	
	/*
	 *	Setup for clear
	 */
	
	[EAGLContext setCurrentContext:context];
	
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
    glClear(GL_COLOR_BUFFER_BIT);
	
	/*
	 *	Set up the basic coordinate system
	 */
	
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	glScalef(1.0f, aspect, 1.0f);
    glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
	
	/*
	 *	Change from Alesandro Tagliati <alessandro.tagliati@gmail.com>:
	 *	We don't need to draw all the tiles, just the visible ones. We guess
	 *	there are 6 tiles visible; that can be adjusted by altering the 
	 *	constant
	 */
	NSUInteger numberOfVisibleCovers = 1.0f / [self distanceBetweenCovers] +1;		// # tiles left and right of center tile visible on screen
	
	NSUInteger numberOfCovers = [delegate numberOfCoversInCoverFlowView:self];
	NSInteger middleIndex = self.currentIndex;
	NSInteger startIndex = middleIndex - numberOfVisibleCovers;
	if ( startIndex < 0 ) startIndex = 0;
	for (NSInteger i = startIndex ; i < middleIndex; ++i) {
		[self drawTile:i relativeOffset:i-offset];
	}
	
	NSUInteger endIndex = middleIndex + numberOfVisibleCovers;
	if (endIndex >= numberOfCovers) {
		endIndex = numberOfCovers-1;
	}
	for (NSInteger i = endIndex; i >= middleIndex; --i) {
		[self drawTile:i relativeOffset:i-offset];
	}
	
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
	[context presentRenderbuffer:GL_RENDERBUFFER_OES];
}

- (void)drawTile:(NSUInteger)index relativeOffset:(CGFloat)relativeOffset
{
	GLfloat m[16];
	memset(m,0,sizeof(m));
	m[10] = 1;
	m[15] = 1;
	m[0] = 1;
	m[5] = 1;
	GLfloat trans = relativeOffset * [self distanceBetweenCovers];
	
	GLfloat maxAngle = [self angleFromCenter];
	GLfloat f = relativeOffset * maxAngle;
	if (f < -maxAngle) {
		f = -maxAngle;
	} else if (f > maxAngle) {
		f = maxAngle;
	}
	m[3] = -f;
	m[0] = 1.0f-fabsf(f);
	GLfloat sc = [self imageScale] * (1.0f - fabsf(f));
	trans += f * 1;
	
	CGPoint centralPoint = [self centralPoint];
	
	glPushMatrix();
	glBindTexture(GL_TEXTURE_2D, [self textureAtIndex:index].texture);
	glTranslatef(trans+centralPoint.x, centralPoint.y, 0.0f);
	glScalef(sc, sc, 1.0f);
	glMultMatrixf(m);
	glDrawArrays(GL_TRIANGLE_STRIP,0,4);
	
	// reflect
	glTranslatef(0.0f, -2.0f, 0.0f);
	glScalef(1.0f, -1.0f, 1.0f);
	glColor4f(0.5f, 0.5f, 0.5f, 0.5f);
	glDrawArrays(GL_TRIANGLE_STRIP,0,4);
	glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
	
	glPopMatrix();
}

- (GLuint)glTextureForIndex:(NSInteger)index {
    if (coverFlowFlags.delegateImageForIndex) {
		return [self glTextureFromImage:[delegate coverFlowView:self imageForIndex:index]];
	}
	else if (coverFlowFlags.delegateViewForIndex) {
		return [self glTextureFromView:[delegate coverFlowView:self viewForIndex:index]];
	}
	else assert(NO);
}

- (ICCoverFlowTexture *)textureAtIndex:(NSUInteger)index
{
	NSNumber *number = [NSNumber numberWithLongLong:index];
	ICCoverFlowTexture *coverFlowTexture = [cache objectForKey:number];
	if (coverFlowTexture == nil) {
		/*
		 *	Object at index doesn't exist. Create a new texture
		 */
		
		GLuint texture = [self glTextureForIndex:index];
		coverFlowTexture = [[[ICCoverFlowTexture alloc] initWithTexture:texture] autorelease];
		[cache setObject:coverFlowTexture forKey:number];
	}
	
	return coverFlowTexture;
}

- (GLuint)glTextureFromView:(UIView *)view {
	GLubyte *pixelBuffer = (GLubyte *)malloc(4 * view.frame.size.width * view.frame.size.height);
	
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef gcontext = CGBitmapContextCreate(pixelBuffer,
												  view.bounds.size.width, view.bounds.size.height, 
												  8, 4 * view.bounds.size.width,
												  colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
	CGColorSpaceRelease(colorSpace);
	
	// draw the view to the buffer
	[view.layer renderInContext:gcontext];
	
	GLuint texture = 0;
	glGenTextures(1,&texture);
	[EAGLContext setCurrentContext:context];
	glBindTexture(GL_TEXTURE_2D,texture);
    // upload to opengl
	glTexImage2D(GL_TEXTURE_2D, 0,
				 GL_RGBA,
				 view.bounds.size.width, view.bounds.size.height, 0,
				 GL_RGBA, GL_UNSIGNED_BYTE, pixelBuffer);
	
	glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR);
	
    // clean up
	CGContextRelease(gcontext);
    
	free(pixelBuffer);
    
	return texture;
}

- (GLuint)glTextureFromImage:(UIImage *)image
{
	/*
	 *	Set up off screen drawing
	 */
	void *pixelBuffer = malloc(4 * textureSize * textureSize);
	//	void *data = malloc(TEXTURESIZE * TEXTURESIZE * 4);
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef gcontext = CGBitmapContextCreate(pixelBuffer,
												  textureSize, textureSize,
												  8, 4 * textureSize,
												  colorSpace, kCGImageAlphaPremultipliedLast);
	CGColorSpaceRelease(colorSpace);
	UIGraphicsPushContext(gcontext);
	
	/*
	 *	Set to transparent
	 */
	
	[[UIColor clearColor] setFill];
	CGRect rect = CGRectMake(0.0f, 0.0f, textureSize, textureSize);
	UIRectFill(rect);
	
	/*
	 *	Draw the image scaled to fit in the texture.
	 */
	
	CGSize size = image.size;
	
	if (size.width > size.height) {
		size.height= textureSize * (size.height / size.width);
		size.width = textureSize;
	} else {
		size.width = textureSize * (size.width / size.height);
		size.height= textureSize;
	}
	
	rect.origin.x = (textureSize - size.width)/2;
	rect.origin.y = (textureSize - size.height)/2;
	rect.size = size;
	[image drawInRect:rect];
	
	/*
	 *	Create the texture
	 */
	
	UIGraphicsPopContext();
	CGContextRelease(gcontext);
	
	GLuint texture = 0;
	glGenTextures(1,&texture);
	[EAGLContext setCurrentContext:context];
	glBindTexture(GL_TEXTURE_2D,texture);
	glTexImage2D(GL_TEXTURE_2D,0,GL_RGBA,textureSize,textureSize,0,GL_RGBA,GL_UNSIGNED_BYTE, pixelBuffer);
	glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR);
	
	free(pixelBuffer);
	
	return texture;
}

@end

@implementation ICCoverFlowView (PrivateAnimation)

- (void)updateAnimationAtTime:(CFTimeInterval)elapsed
{	
	if (elapsed > runDelta) elapsed = runDelta;
	CGFloat delta = (CGFloat)(fabs(startSpeed) * elapsed - ICCoverFlowViewScrollFriction * elapsed * elapsed / 2);
	if (startSpeed < 0) delta = -delta;
	offset = startOffset + delta;
	if ( [self setOffsetFitInBounds] ) {
		startOffset = offset;
		[self endAnimation];
		dlog(COVERFLOW_DEBUG, @"animation meet boundary and reserve from: %lf", startOffset);
		[self startAnimationToOffset:floorf(offset) asCodeDriven:coverFlowFlags.isCodeDrivenAction];
		return;
	}
	[self draw];
	
	if ( coverFlowFlags.delegateDidScroll )
		[delegate coverFlowViewDidScroll:self];
}

- (void)endAnimation
{
	if ( timer != nil ) {
		[timer invalidate];
		timer = nil;
		offset = floorf(offset + 0.5f);
	}
}

- (void)driveAnimation
{
	CFTimeInterval elapsed = CACurrentMediaTime() - lastTime;
	if (elapsed >= runDelta) {
		[self endAnimation];
		if ( coverFlowFlags.isCodeDrivenAction ) {
			if ( coverFlowFlags.delegateDidEndScrollingAnimation ) {
				[delegate coverFlowViewDidEndScrollingAnimation:self];
			}
			coverFlowFlags.isCodeDrivenAction = NO;
		} else {
			if ( coverFlowFlags.delegateDidEndDecelerating ) {
				[delegate coverFlowViewDidEndDecelerating:self];
			}
		}
		[self draw];
	} else {
		[self updateAnimationAtTime:elapsed];
	}
}

- (void)startAnimationToOffset:(GLfloat)newOffset asCodeDriven:(BOOL)flag{
	if ( timer != nil ) [self endAnimation];
	
	coverFlowFlags.isCodeDrivenAction = flag;
	
	/*
	 *	Adjust Speed to make this land on an even location
	 */
	
	if ( !coverFlowFlags.isCodeDrivenAction && coverFlowFlags.delegateWillBeginDecelerating )
		[delegate coverFlowViewWillBeginDecelerating:self];
	
	dlog(COVERFLOW_DEBUG, @"nearest: %lf", newOffset);
	startSpeed = sqrt(fabs(newOffset - startOffset) * ICCoverFlowViewScrollFriction * 2);
	if (newOffset < startOffset) startSpeed = -startSpeed;
	
	runDelta = fabs(startSpeed / ICCoverFlowViewScrollFriction);
	lastTime = CACurrentMediaTime();
	
	dlog(COVERFLOW_DEBUG, @"startSpeed: %lf",startSpeed);
	dlog(COVERFLOW_DEBUG, @"runDelta: %lf",runDelta);
	timer = [NSTimer scheduledTimerWithTimeInterval:0.03
											 target:self
										   selector:@selector(driveAnimation)
										   userInfo:nil
											repeats:YES];	
}

@end


//-- temporary backup


/*	DataCache.m
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

@implementation DataCache

#pragma mark -
#pragma mark life cycle

- (id)initWithCapacity:(NSUInteger)cap
{
	if (nil != (self = [super init])) {
		fCapacity = cap;
		fDictionary = [[NSMutableDictionary alloc] initWithCapacity:cap];
		fAge = [[NSMutableArray alloc] initWithCapacity:cap];
	}
	return self;
}

- (void)dealloc
{
	[fDictionary release];
	[fAge release];
	[super dealloc];
}

#pragma mark -
#pragma mark interface

- (id)objectForKey:(id)key
{
	// Pull key out of age array and move to front, indicates recently used
	NSUInteger index = [fAge indexOfObject:key];
	if (index == NSNotFound) return nil;
	if (index != 0) {
		[fAge removeObjectAtIndex:index];
		[fAge insertObject:key atIndex:0];
	}
	
	return [fDictionary objectForKey:key];
}

- (void)setObject:(id)value forKey:(id)key
{
	// Update the age of the inserted object and delete the oldest if needed
	NSUInteger index = [fAge indexOfObject:key];
	if (index != 0) {
		if (index != NSNotFound) {
			[fAge removeObjectAtIndex:index];
		}
		[fAge insertObject:key atIndex:0];
		
		if ([fAge count] > fCapacity) {
			id delKey = [fAge lastObject];
			[fDictionary removeObjectForKey:delKey];
			[fAge removeLastObject];
		}
	}
	
	[fDictionary setObject:value forKey:key];
}

@end
