//
//  DELoginViewController.m
//  whatsgoinon
//
//  Created by adeiji on 8/8/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import "DELoginViewController.h"
#import "Constants.h"

@interface DELoginViewController ()

@end

@implementation DELoginViewController

#define CREATE_ACCOUNT_VIEW_CONTROLLER @"createAccountViewController"


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    for (UIView *view in _buttons) {
        [[view layer] setCornerRadius:BUTTON_CORNER_RADIUS];
    }
    
    [DEScreenManager setUpTextFields:_textFields];
    if (_posting)
    {
        [_btnSkip setHidden:YES];
        // Change the text to display that the user needs to login to post and then move the two visible buttons down.
        _lblLoginMessage.text = @"Posting an event to HappSnap is free but an account is required. It also only takes a few seconds and then you can get right to it.";
        _createAccountButtonToBottomConstraint.constant = _skipButtonToBottomConstraint.constant;
    }
    else {
        _lblLoginMessage.text = @"HappSnap is more fun and useful with an account.\n\nSign up in seconds for free!";
    }
    
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    if (screenHeight < 500)
    {
        if ([self.view isKindOfClass:[DELoginView class]] || [self.view isKindOfClass:[DECreateAccountView class]])
        {
            [self.view performSelector:@selector(setUpViewForiPhone4)];
        }
    }
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.view setHidden:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.view setHidden:YES];
}

#pragma mark - Button Press Methods

- (IBAction)createAnAccount:(id)sender {
    
    DELoginViewController *loginViewController = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:CREATE_ACCOUNT_VIEW_CONTROLLER];
    
    [[self navigationController] pushViewController:loginViewController animated:YES];
    
    [(DECreateAccountView *) loginViewController.view setUpView];
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)showNextScreen:(id)sender {
    DEScreenManager *screenManager = [DEScreenManager sharedManager];
    [screenManager gotoNextScreen];
}
- (IBAction)loginWithFacebook:(id)sender {
    [[DEScreenManager sharedManager] startActivitySpinner];
    [[DEUserManager sharedManager] loginWithFacebook];
}
- (IBAction)loginWithTwitter:(id)sender {
    [[DEScreenManager sharedManager] startActivitySpinner];
    [[DEUserManager sharedManager] loginWithTwitter];
}

@end
