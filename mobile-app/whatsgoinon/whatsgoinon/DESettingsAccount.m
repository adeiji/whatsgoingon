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


- (IBAction)sendFeedback:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Email Feedback", @"Write a Review",nil];
    
    [[DEScreenManager sharedManager] setNextScreen:[[DEScreenManager getMainNavigationController] topViewController]];
    [actionSheet showInView:self];
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [[DEScreenManager sharedManager] showEmail];
    }
    else
    {
        
    }
}

- (IBAction)signOut:(id)sender {
}

- (IBAction)goBack:(id)sender {
    [DEAnimationManager fadeOutRemoveView:[self superview] FromView:[[self superview] superview]];
}
@end
