//
//  UIEventScrollView.h
//  IdealCocoa
//
//  Created by youknowone on 10. 3. 6..
//  Copyright 2010 3rddev.org. All rights reserved.
//

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
