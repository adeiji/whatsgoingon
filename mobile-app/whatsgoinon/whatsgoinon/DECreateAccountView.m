//
//  DECreateAccountView.m
//  whatsgoinon
//
//  Created by adeiji on 8/8/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import "DECreateAccountView.h"
#import "Constants.h"

@implementation DECreateAccountView

#define ERROR_CODE_EMAIL_TAKEN @203

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) setUpView {
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UITextField class]])
        {
            UITextField *textField = (UITextField *) view;
            textField.delegate = self;
        }
    }
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UITextField class]])
        {
            [view resignFirstResponder];
        }
    }
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

- (void) setUpValidators {
    [_txtEmail addRegx:@"[A-Z0-9a-z._%+-]{3,}+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}" withMsg:@"Must enter a valid email"];
    [_txtPassword addRegx:@"^(?!\\s*$).+" withMsg:@"Must enter a password"];
    [_txtUsername addRegx:@"[A-Za-z0-9]{3,10}" withMsg:@"Only alpha numeric characters are allowed."];
    [_txtConfirmPassword addConfirmValidationTo:_txtPassword withMsg:@"Passwords do not match"];
    
    [_txtEmail setPresentInView:self];
    [_txtPassword setPresentInView:self];
    [_txtUsername setPresentInView:self];
    [_txtConfirmPassword setPresentInView:self];
}

- (BOOL) validateTextFields
{
    if ([_txtEmail validate] &
        [_txtPassword validate] &
        [_txtUsername validate] &
        [_txtConfirmPassword validate])
    {
        // Success
        return YES;
    }
    
    return NO;
}

#pragma mark - Button Methods

- (IBAction)signUp:(id)sender {
    [self setUpValidators];
    
    if ([self validateTextFields])
    {
        DEAddProfileImageViewController *profileImageViewController = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:LOGIN_ADD_PROFILE_IMAGE_VIEW_CONTROLLER];
        
        [[DEUserManager sharedManager] createUserWithUserName:_txtUsername.text
                                                     Password:_txtPassword.text
                                                        Email:_txtEmail.text
                                               ViewController:profileImageViewController
                                                   ErrorLabel:_lblUsernameError];
    }
}


@end
