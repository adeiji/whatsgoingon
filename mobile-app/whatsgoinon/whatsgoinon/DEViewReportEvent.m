//
//  DEViewReportEvent.m
//  whatsgoinon
//
//  Created by adeiji on 8/15/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import "DEViewReportEvent.h"

@implementation DEViewReportEvent


- (IBAction)cancelReport:(id)sender {
    [[self superview] removeFromSuperview];
}

- (void) willMoveToSuperview:(UIView *)newSuperview {
    [self registerForKeyboardNotifications];
    [self.txtNotes setDelegate:self];
}

- (void) registerForKeyboardNotifications
{
    //Make sure when writing the selector, you add the semicolon to the end, for ex, keyboardWasShown: not keyboardWasShown
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void) keyboardWasShown : (NSNotification *) aNotification {
    [self scrollViewToTopOfKeyboard:(UIScrollView *)[self superview] Notification:aNotification View:self TextFieldOrView:activeField];
}

- (void) keyboardWillBeHidden : (NSNotification *) aNotification {
    [self scrollViewToBottom:(UIScrollView *)[self superview] Notification:aNotification];
}

#pragma mark - Text Field Methods

- (void) textViewDidBeginEditing:(UITextView *)textView {
    activeField = textView;
}

- (void) textViewDidEndEditing:(UITextView *)textView
{
    activeField = nil;
    [textView resignFirstResponder];
}

// Push the event up to the server as reported, and store the reason for the report as well
- (IBAction)reportEvent:(id)sender {
    
    
    
}
- (IBAction)showReportDetailsTextView:(id)sender {
    

    
}
- (IBAction)enableReportDetailsTextView:(id)sender {
}
@end
