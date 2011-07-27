//
//  UITableViewCellCopyable.m
//  IdealCocoa
//
//  Created by youknowone on 11. 6. 21..
//  Copyright 2011 3rddev.org. All rights reserved.
//

#import "ICTableViewCellCopyable.h"

static const CFTimeInterval kLongPressMinimumDurationSeconds = 0.3;

@interface ICTableViewCellCopyable ()

- (void) initAsICTableViewCellCopyable;
- (void) menuWillHide:(NSNotification *)notification;
- (void) menuWillShow:(NSNotification *)notification;
- (void) handleLongPress:(UILongPressGestureRecognizer *)longPressRecognizer;

@end

@implementation ICTableViewCellCopyable
@synthesize delegate;

- (void)initAsICTableViewCellCopyable {
    UILongPressGestureRecognizer *recognizer =
    [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    [recognizer setMinimumPressDuration:kLongPressMinimumDurationSeconds];
    [self addGestureRecognizer:recognizer];
    [recognizer release];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initAsICTableViewCellCopyable];
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

#pragma mark -
#pragma mark Copy Menu related methods

- (BOOL) canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(copy:)) {
        return YES;
    }
    return [super canPerformAction:action withSender:sender];
}

- (void) copy:(id)sender
{
    if ((self.delegate != nil) && [self.delegate respondsToSelector:@selector(dataForCell:)]) {
        NSString *dataText = [self.delegate dataForCell:self];
        [[UIPasteboard generalPasteboard] setString:dataText];
    }
    else {
        [[UIPasteboard generalPasteboard] setString:self.textLabel.text];
    }
    
    [self resignFirstResponder];
}

- (BOOL) canBecomeFirstResponder
{
    return YES;
}

- (BOOL) becomeFirstResponder
{
    return [super becomeFirstResponder];
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self isFirstResponder] == NO) {
        return;
    }
    
    UIMenuController *menu = [UIMenuController sharedMenuController];
    [menu setMenuVisible:NO animated:YES];
    [menu update];
    [self resignFirstResponder];
}

- (void) menuWillHide:(NSNotification *)notification
{
    if ((self.delegate != nil) && [self.delegate respondsToSelector:@selector(deselectCell:)]) {
        [self.delegate deselectCell:self];
    }
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIMenuControllerWillHideMenuNotification object:nil];
}

- (void) menuWillShow:(NSNotification *)notification
{
    self.selectionStyle = UITableViewCellSelectionStyleBlue;
    if ((self.delegate != nil) && [self.delegate respondsToSelector:@selector(selectCell:)]) {
        [self.delegate selectCell:self];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIMenuControllerWillShowMenuNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(menuWillHide:)
                                                 name:UIMenuControllerWillHideMenuNotification
                                               object:nil];
}


#pragma mark -
#pragma mark UILongPressGestureRecognizer Handler Methods

- (void) handleLongPress:(UILongPressGestureRecognizer *)longPressRecognizer
{
    if (longPressRecognizer.state != UIGestureRecognizerStateBegan) {
        return;
    }
    
    if ([self becomeFirstResponder] == NO) {
        return;
    }
    
    UIMenuController *menu = [UIMenuController sharedMenuController];
    [menu setTargetRect:self.bounds inView:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(menuWillShow:)
                                                 name:UIMenuControllerWillShowMenuNotification
                                               object:nil];
    [menu setMenuVisible:YES animated:YES];
}

@end
