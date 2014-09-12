//
//  DESettingsAccount.m
//  whatsgoinon
//
//  Created by adeiji on 8/19/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import "DESettingsAccount.h"
#import "Constants.h"

@implementation DESettingsAccount

- (id)init
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"ViewSettingsAccount" owner:self options:nil] firstObject];
        
        [[_btnTakePicture layer] setCornerRadius:_btnTakePicture.frame.size.height / 2.0f];
        [[_btnTakePicture layer] setBorderWidth:2.0f];
        [[_btnTakePicture layer] setBorderColor:[UIColor whiteColor].CGColor];
        [[_btnSendFeedback layer] setCornerRadius:BUTTON_CORNER_RADIUS];
        [[_btnSignOut layer] setCornerRadius:BUTTON_CORNER_RADIUS];
        
        [self setUpTextFields];
    }
    return self;
}

- (void) setUpTextFields
{
    NSArray *array = [NSArray arrayWithObjects:_txtEmail, _txtPassword, _txtUsername, nil];
    [DEScreenManager setUpTextFields:array];
}

- (void) hideView : (UIView *) myView
{
    for (UIView *view in [myView subviews]) {
        view.hidden = YES;
    }
    self.hidden = NO;
    [[self superview] setHidden:NO];
    _viewToHide = myView;
}

- (IBAction)takePicture:(id)sender {
}

- (IBAction)sendFeedback:(id)sender {
}

- (IBAction)signOut:(id)sender {
}

- (IBAction)goBack:(id)sender {
    for (UIView *view in [_viewToHide subviews]) {
        view.hidden = NO;
    }
    [[self superview] removeFromSuperview];
    
}
@end
