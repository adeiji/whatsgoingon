//
//  DELoginView.m
//  whatsgoinon
//
//  Created by adeiji on 8/8/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import "DELoginView.h"

@implementation DELoginView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (IBAction)signIn:(id)sender {
    DEUserManager *userManager = [DEUserManager sharedManager];
    DEScreenManager *screenManager = [DEScreenManager sharedManager];

    [userManager loginWithUsername:_txtUsernameOrEmail.text Password:_txtPassword.text ViewController:[screenManager nextScreen] ErrorLabel:_errorLabel];
}

@end
