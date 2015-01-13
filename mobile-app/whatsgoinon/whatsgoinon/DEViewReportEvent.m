//
//  DEViewReportEvent.m
//  whatsgoinon
//
//  Created by adeiji on 8/15/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import "DEViewReportEvent.h"
#import "Constants.h"

@implementation DEViewReportEvent


- (IBAction)cancelReport:(id)sender {

    [self removeView];
}

- (void) removeView
{    
    [DEAnimationManager fadeOutRemoveView:[self superview] FromView:[[self superview] superview]];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) registerForKeyboardNotifications
{
    [self.txtNotes setDelegate:self];
    [[self.txtNotes layer] setCornerRadius:BUTTON_CORNER_RADIUS];
    for (UIView *view in _buttons) {
        [[view layer] setCornerRadius:BUTTON_CORNER_RADIUS];
    }
    
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


// Create the report from the inputed data and then push the report to the server
- (IBAction)reportEvent:(id)sender {
    DEReport *report = [self getReport];
    
    [DESyncManager saveReportWithEventId:_eventId WhatsWrong:report.whatsWrong      Other:report.other];
    
    [self removeView];
    [DEAnimationManager savedAnimationWithImage:@"event-reported-indicator-icon.png"];
}

- (DEReport *) getReport {
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:_switchAbusive.on], REPORT_VULGAR_OR_ABUSIVE_LANGUAGE, [NSNumber numberWithBool:_switchCrude.on], REPORT_CRUDE_CONTENT, [NSNumber numberWithBool:_switchInappropriate.on], REPORT_POST_NOT_APPROPRIATE, [NSNumber numberWithBool:_switchNotReal.on], REPORT_POST_NOT_APPROPRIATE, nil];
    NSString *other = _txtNotes.text;
    
    DEReport *report = [DEReport new];
    [report setWhatsWrong:dictionary];
    [report setOther:other];
    
    return report;
}

- (IBAction)enableReportDetailsTextView:(UISwitch *)sender {
    if (sender.on)
    {
        [_txtNotes setUserInteractionEnabled:YES];
        [_txtNotes setBackgroundColor:[UIColor clearColor]];
        [_txtNotes setTextColor:[UIColor whiteColor]];
        [_txtNotes becomeFirstResponder];
    }
    else {
        [_txtNotes setUserInteractionEnabled:NO];
        [_txtNotes setBackgroundColor:[UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:.3f]];
        [_txtNotes setTextColor:[UIColor clearColor]];
    }
}

- (BOOL) textView: (UITextView*) textView shouldChangeTextInRange: (NSRange)range replacementText: (NSString*) text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
@end

@implementation DEReport

@end
