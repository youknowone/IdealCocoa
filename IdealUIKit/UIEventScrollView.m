//
//  UIEventScrollView.m
//  IdealCocoa
//
//  Created by youknowone on 10. 3. 6..
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

#import "UIEventScrollView.h"

#define ICSCROLL_DEBUG FALSE

@implementation UIEventView
@synthesize eventHandler;

- (void)dealloc {
	self.eventHandler = nil;
	[super dealloc];
}

#pragma mark -
#pragma mark control interface

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	if ( implementedZoomEnabled )
		assert(NO);
	
	ICLog(ICSCROLL_DEBUG, @"touches begin");
	eventViewFlags.moved = NO;
	[eventHandler sendActionsForControlEvents:UIControlEventTouchDown withEvent:event];
	[super touchesEnded: touches withEvent: event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	if ( implementedZoomEnabled && [[event allTouches] count] == 2 ) {
		assert(NO);
	}	
	ICLog(ICSCROLL_DEBUG, @"touches move");
	eventViewFlags.moved = YES;
	[eventHandler sendActionsForControlEvents:UIControlEventTouchDragEnter withEvent:event];
	[super touchesEnded:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	distance = 0.0f;
	ICLog(ICSCROLL_DEBUG, @"touches end");
	if ( eventViewFlags.moved ) {
		[eventHandler sendActionsForControlEvents:UIControlEventTouchDragExit withEvent:event];
		[eventHandler sendActionsForControlEvents:UIControlEventTouchDragInside withEvent:event];
	}
	else {
		[eventHandler sendActionsForControlEvents:UIControlEventTouchUpInside withEvent:event];
	}
	if (event.timestamp - latestTimestamp < 0.4) {
		[eventHandler sendActionsForControlEvents:UIControlEventTouchDownRepeat withEvent:event];
	}
	latestTimestamp = event.timestamp;
	[super touchesEnded: touches withEvent: event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	ICLog(ICSCROLL_DEBUG, @"touches cancel");
	if ( eventViewFlags.moved ) {
		[eventHandler sendActionsForControlEvents:UIControlEventTouchDragExit];
	}
	[eventHandler sendActionsForControlEvents:UIControlEventTouchCancel withEvent:event];
	[super touchesEnded: touches withEvent: event];
}

@end

@implementation UIEventScrollView
@synthesize eventHandler, implementedZoomEnabled;

- (void)dealloc {
	self.eventHandler = nil;
	[super dealloc];
}

#pragma mark -
#pragma mark control interface

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	if ( implementedZoomEnabled )
	if ( [[event allTouches] count] == 2 ) {
		NSArray *allTouches = [[event allTouches] allObjects];
		UITouch *t1 = [allTouches objectAtIndex:0];
		UITouch *t2 = [allTouches objectAtIndex:1];
		distance = (CGFloat)sqrt(pow([t1 locationInView:self].x, 2.0) + pow([t2 locationInView:self].y, 2.0));
		oldscale = self.zoomScale;
	}

	ICLog(ICSCROLL_DEBUG, @"touches begin");
	eventViewFlags.moved = NO;
	[eventHandler sendActionsForControlEvents:UIControlEventTouchDown withEvent:event];
	[super touchesEnded: touches withEvent: event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	if ( implementedZoomEnabled && [[event allTouches] count] == 2 ) {
		if ( distance == 0.0f ) {
			[self touchesBegan:touches withEvent:event];
			return;
		}
		NSArray *allTouches = [[event allTouches] allObjects];
		UITouch *t1 = [allTouches objectAtIndex:0];
		UITouch *t2 = [allTouches objectAtIndex:1];
		CGFloat newdistance = (CGFloat)sqrt(pow([t1 locationInView:self].x, 2.0) + pow([t2 locationInView:self].y, 2.0));
		float newScale = oldscale*(newdistance/distance);
		ICLog(ICSCROLL_DEBUG, @"oldscale, newscale, dist, newdist, newscale: %f, %f, %f, %f, %f", oldscale, newScale, distance, newdistance, newScale);
		[self setZoomScale:newScale animated:NO];
	}	
	ICLog(ICSCROLL_DEBUG, @"touches move");
	eventViewFlags.moved = YES;
	[eventHandler sendActionsForControlEvents:UIControlEventTouchDragEnter withEvent:event];
	[super touchesEnded:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	distance = 0.0f;
	ICLog(ICSCROLL_DEBUG, @"touches end");
	if ( eventViewFlags.moved ) {
		[eventHandler sendActionsForControlEvents:UIControlEventTouchDragExit withEvent:event];
		[eventHandler sendActionsForControlEvents:UIControlEventTouchDragInside withEvent:event];
	}
	else {
		[eventHandler sendActionsForControlEvents:UIControlEventTouchUpInside withEvent:event];
	}
	if (event.timestamp - latestTimestamp < 0.4) {
		[eventHandler sendActionsForControlEvents:UIControlEventTouchDownRepeat withEvent:event];
	}
	latestTimestamp = event.timestamp;
	[super touchesEnded: touches withEvent: event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	ICLog(ICSCROLL_DEBUG, @"touches cancel");
	if ( eventViewFlags.moved ) {
		[eventHandler sendActionsForControlEvents:UIControlEventTouchDragExit];
	}
	[eventHandler sendActionsForControlEvents:UIControlEventTouchCancel withEvent:event];
	[super touchesEnded: touches withEvent: event];
}

@end

@implementation UIEventTextView
@synthesize eventHandler, implementedZoomEnabled;

- (void)dealloc {
	self.eventHandler = nil;
	[super dealloc];
}

#pragma mark -
#pragma mark control interface

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	if ( implementedZoomEnabled )
		if ( [[event allTouches] count] == 2 ) {
			NSArray *allTouches = [[event allTouches] allObjects];
			UITouch *t1 = [allTouches objectAtIndex:0];
			UITouch *t2 = [allTouches objectAtIndex:1];
			distance = (CGFloat)sqrt(pow([t1 locationInView:self].x, 2.0) + pow([t2 locationInView:self].y, 2.0));
			oldscale = self.zoomScale;
		}
	
	ICLog(ICSCROLL_DEBUG, @"touches begin");
	eventViewFlags.moved = NO;
	[eventHandler sendActionsForControlEvents:UIControlEventTouchDown withEvent:event];
	[super touchesEnded: touches withEvent: event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	if ( implementedZoomEnabled && [[event allTouches] count] == 2 ) {
		if ( distance == 0.0f ) {
			[self touchesBegan:touches withEvent:event];
			return;
		}
		NSArray *allTouches = [[event allTouches] allObjects];
		UITouch *t1 = [allTouches objectAtIndex:0];
		UITouch *t2 = [allTouches objectAtIndex:1];
		CGFloat newdistance = (CGFloat)sqrt(pow([t1 locationInView:self].x, 2.0) + pow([t2 locationInView:self].y, 2.0));
		float newScale = oldscale*(newdistance/distance);
		ICLog(ICSCROLL_DEBUG, @"oldscale, newscale, dist, newdist, newscale: %f, %f, %f, %f, %f", oldscale, newScale, distance, newdistance, newScale);
		[self setZoomScale:newScale animated:NO];
	}	
	ICLog(ICSCROLL_DEBUG, @"touches move");
	eventViewFlags.moved = YES;
	[eventHandler sendActionsForControlEvents:UIControlEventTouchDragEnter withEvent:event];
	[super touchesEnded: touches withEvent: event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	distance = 0.0f;
	ICLog(ICSCROLL_DEBUG, @"touches end");
	if ( eventViewFlags.moved ) {
		[eventHandler sendActionsForControlEvents:UIControlEventTouchDragExit withEvent:event];
		[eventHandler sendActionsForControlEvents:UIControlEventTouchDragInside withEvent:event];
	}
	else {
		[eventHandler sendActionsForControlEvents:UIControlEventTouchUpInside withEvent:event];
	}
	if (event.timestamp - latestTimestamp < 0.4) {
		[eventHandler sendActionsForControlEvents:UIControlEventTouchDownRepeat withEvent:event];
	}
	latestTimestamp = event.timestamp;
	[super touchesEnded: touches withEvent: event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	ICLog(ICSCROLL_DEBUG, @"touches cancel");
	if ( eventViewFlags.moved ) {
		[eventHandler sendActionsForControlEvents:UIControlEventTouchDragExit];
	}
	[eventHandler sendActionsForControlEvents:UIControlEventTouchCancel withEvent:event];
	[super touchesEnded: touches withEvent: event];
}

@end
