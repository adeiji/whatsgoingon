//
//  DECreateAccountView.h
//  whatsgoinon
//
//  Created by adeiji on 8/8/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DEUserManager.h"
#import "DEAddProfileImageViewController.h"
#import "TextFieldValidator.h"

@interface DECreateAccountView : UIView <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet TextFieldValidator *txtUsername;
@property (weak, nonatomic) IBOutlet TextFieldValidator *txtEmail;
@property (weak, nonatomic) IBOutlet TextFieldValidator *txtPassword;
@property (weak, nonatomic) IBOutlet TextFieldValidator *txtConfirmPassword;
@property (weak, nonatomic) IBOutlet UILabel *lblUsernameError;

- (void) setUpView;
- (IBAction)signUp:(id)sender;

@end
