//
//  UIEventScrollView.h
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

#import <IdealUIKit/UIControlAdditions.h>

#define UIEventViewVariables		\
	BOOL implementedZoomEnabled;	\
	CGFloat distance, oldscale;		\
	NSTimeInterval latestTimestamp;	\
	struct {						\
		unsigned int moved:1;		\
	} eventViewFlags

@interface UIEventView : UIView<UIControlTouchEvents> { 
	IBOutlet UIControl *eventHandler;
	UIEventViewVariables;
}

@property(nonatomic, retain) IBOutlet UIControl *eventHandler;

@end

@interface UIEventScrollView : UIScrollView<UIControlTouchEvents> {
	IBOutlet UIControl *eventHandler;
	UIEventViewVariables;
}

@property(nonatomic, retain) IBOutlet UIControl *eventHandler;
@property(nonatomic, assign) BOOL implementedZoomEnabled;

@end

@interface UIEventTextView : UITextView<UIControlTouchEvents> {
	IBOutlet UIControl *eventHandler; 
	UIEventViewVariables;
}

@property(nonatomic, retain) IBOutlet UIControl *eventHandler;
@property(nonatomic, assign) BOOL implementedZoomEnabled;

@end
