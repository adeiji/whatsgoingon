//
//  DEMainViewController.m
//  whatsgoinon
//
//  Created by adeiji on 8/5/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import "DEMainViewController.h"
#import "DECreatePostViewController.h"

@interface DEMainViewController ()

@end

@implementation DEMainViewController

#define PROMPT_LOGIN_VIEW_CONTROLLER @"promptLogin"

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setTranslucent:YES];
    
    for (UIView *button in self.buttons) {
        [button.layer setCornerRadius:6.0f];
    }    
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view setAlpha:0];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.view setAlpha:1.0f];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)viewWhatsGoingOnNow:(id)sender {
    if ([self isLoggedIn])
    {
        // Do any additional setup after loading the view.
        UIStoryboard *viewPosts = [UIStoryboard storyboardWithName:@"ViewPosts" bundle:nil];
        DEViewEventsViewController *viewEventsViewController = [viewPosts instantiateInitialViewController];
    
        [self.navigationController pushViewController:viewEventsViewController animated:YES];
    }
    else {
        UIStoryboard *viewPosts = [UIStoryboard storyboardWithName:@"ViewPosts" bundle:nil];
        DEViewEventsViewController *viewEventsViewController = [viewPosts instantiateInitialViewController];
        
        [self setNextScreenWithViewController:viewEventsViewController];
    }
}

- (void) setNextScreenWithViewController : (UIViewController *) viewController {
    DEScreenManager *screenManager = [DEScreenManager sharedManager];
    screenManager.nextScreen = viewController;
}


- (IBAction)showCreatePostView:(id)sender {
    if ([self isLoggedIn])
    {
        UIStoryboard *createPost = [UIStoryboard storyboardWithName:@"Posting" bundle:nil];
        DECreatePostViewController *createPostViewController = [createPost instantiateInitialViewController];
    
        [self.navigationController pushViewController:createPostViewController animated:YES];
    }
    else {
        UIStoryboard *createPost = [UIStoryboard storyboardWithName:@"Posting" bundle:nil];
        DECreatePostViewController *createPostViewController = [createPost instantiateInitialViewController];
        
        [self setNextScreenWithViewController:createPostViewController];
    }
    
}

- (BOOL) isLoggedIn {
    DEUserManager *userManager = [DEUserManager sharedManager];

    
    if (![userManager isLoggedIn])
    {
        DELoginViewController *loginViewController = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:PROMPT_LOGIN_VIEW_CONTROLLER];
        
        [[self navigationController] pushViewController:loginViewController animated:YES];
        [[loginViewController navigationController] setNavigationBarHidden:YES animated:YES];
        
        return NO;
    }
    else {
        DEUserManager *userManager = [DEUserManager sharedManager];
        [userManager linkWithTwitter];
        [userManager loginWithFacebook];
    }
    
    return YES;
}

@end
