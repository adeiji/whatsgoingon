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
    [[self superview] removeFromSuperview];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



- (void) registerForKeyboardNotifications
{
    [self.txtNotes setDelegate:self];
    
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
    
    [[self superview] removeFromSuperview];
    
#warning Make sure that we display to the user that he saved the report
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
        [_txtNotes setBackgroundColor:[UIColor whiteColor]];
        [_txtNotes setUserInteractionEnabled:YES];
        [_txtNotes setTextColor:[UIColor blackColor]];
    }
    else {
        [_txtNotes setBackgroundColor:[UIColor blueColor]];
        [_txtNotes setUserInteractionEnabled:NO];
        [_txtNotes setTextColor:[UIColor blueColor]];
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
