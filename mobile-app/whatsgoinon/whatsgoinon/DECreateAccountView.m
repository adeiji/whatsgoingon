//
//  DECreateAccountView.m
//  whatsgoinon
//
//  Created by adeiji on 8/8/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import "DECreateAccountView.h"

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

#pragma mark - Button Methods

- (IBAction)signUp:(id)sender {
    
    _lblUsernameError.hidden = YES;
    DEUserManager *userManager = [DEUserManager sharedManager];
    
    NSError *error = [userManager createUserWithUserName:_txtUsername.text Password:_txtPassword.text Email:_txtEmail.text];
    
    if (error)
    {
        _lblUsernameError.text = error.userInfo[@"error"];
        _lblUsernameError.hidden = NO;
    }
}

@end