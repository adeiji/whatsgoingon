//
//  DELoginViewController.m
//  whatsgoinon
//
//  Created by adeiji on 8/8/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import "DELoginViewController.h"

@interface DELoginViewController ()

@end

@implementation DELoginViewController

#define CREATE_ACCOUNT_VIEW_CONTROLLER @"createAccountViewController"


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if ([self.view isKindOfClass:[DECreateAccountView class]])
    {
        [[self navigationController] setNavigationBarHidden:YES animated:YES];
    }
}

#pragma mark - Button Press Methods

- (IBAction)createAnAccount:(id)sender {
    
    DELoginViewController *loginViewController = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:CREATE_ACCOUNT_VIEW_CONTROLLER];
    
    [[self navigationController] pushViewController:loginViewController animated:YES];
    [[loginViewController navigationController] setNavigationBarHidden:NO];
    
    [(DECreateAccountView *) loginViewController.view setUpView];
    
}
@end
