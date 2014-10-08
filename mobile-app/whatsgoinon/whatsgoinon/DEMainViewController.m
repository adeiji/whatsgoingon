//
//  DEMainViewController.m
//  whatsgoinon
//
//  Created by adeiji on 8/5/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import "DEMainViewController.h"
#import "DECreatePostViewController.h"
#import "Constants.h"

@interface DEMainViewController ()

@end

@implementation DEMainViewController


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
    
    UIImageView *imageView = [UIImageView new];
    [imageView setImage:[UIImage imageNamed:@"main-vc-background.png"]];
    [[imageView layer] setZPosition:-2];
    [imageView setFrame:[[[UIApplication sharedApplication] delegate] window].frame];
    [self.view addSubview:imageView];
    
}

- (void) viewWillDisappear:(BOOL)animated
{
    [self.view setHidden:YES];
    [super viewWillDisappear:animated];
}

- (void) viewWillAppear:(BOOL)animated
{
    [self.view setHidden:NO];
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)viewWhatsGoingOnLater:(id)sender {
    if ([self isLoggedIn : NO])
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

    [DESyncManager getAllValuesForNow:NO];
    [[DEScreenManager sharedManager] setIsLater:YES];

}

- (IBAction)viewWhatsGoingOnNow:(id)sender {
    if ([self isLoggedIn : NO])
    {
        // Do any additional setup after loading the view.
        UIStoryboard *viewPosts = [UIStoryboard storyboardWithName:@"ViewPosts" bundle:nil];
        DEViewEventsViewController *viewEventsViewController = [viewPosts instantiateInitialViewController];
    
        [self.navigationController pushViewController:viewEventsViewController animated:YES];
        [[DEScreenManager sharedManager] startActivitySpinner];
    }
    else {
        UIStoryboard *viewPosts = [UIStoryboard storyboardWithName:@"ViewPosts" bundle:nil];
        DEViewEventsViewController *viewEventsViewController = [viewPosts instantiateInitialViewController];
        
        [self setNextScreenWithViewController:viewEventsViewController];
    }
    
    [DESyncManager getAllValuesForNow:YES];
    [[DEScreenManager sharedManager] setIsLater:NO];
}

- (void) setNextScreenWithViewController : (UIViewController *) viewController {
    DEScreenManager *screenManager = [DEScreenManager sharedManager];
    screenManager.nextScreen = viewController;
}


- (IBAction)showCreatePostView:(id)sender {
    if ([self isLoggedIn : YES])
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
    
    [[DEPostManager sharedManager] setCurrentPost:[DEPost new]];
    
}

- (BOOL) isLoggedIn : (BOOL) posting {
    DEUserManager *userManager = [DEUserManager sharedManager];
    
    if (![userManager isLoggedIn])
    {
        DELoginViewController *loginViewController = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:PROMPT_LOGIN_VIEW_CONTROLLER];
        
        [[self navigationController] pushViewController:loginViewController animated:YES];
        [[loginViewController navigationController] setNavigationBarHidden:YES animated:YES];
        
        // If the user pressed post it then we don't want them to be able to skip this section
        loginViewController.posting = posting;
        
        return NO;
    }  //  Link Twitter and Facebook accounts
    else {
        DEUserManager *userManager = [DEUserManager sharedManager];
//        [userManager linkWithTwitter];
//        [userManager loginWithFacebook];
    }
    
    return YES;
}

@end
