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
#import <Google/Analytics.h>

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

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    static BOOL firstAppearance = YES;
    
    
    if (firstAppearance)
    {
        if (screenHeight < 500)
        {
            _logoTopViewConstraint.constant = _logoTopViewConstraint.constant - 50;
            [self.view layoutIfNeeded];
            firstAppearance = NO;
        }
    }
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
    
    [self transitionFromSplashScreen];
}

// Display the splash image and then fade into the first screen of the application

- (void) transitionFromSplashScreen {
    UIImageView *imageView = [UIImageView new];
    UIImage *launchImage = [UIImage imageNamed:@"splashimage.png"];
    
    [imageView setFrame:self.view.frame];
    [imageView setImage:launchImage];
    
    [UIView animateWithDuration:1.2f animations:^{
        [imageView setAlpha:0.0f];
    } completion:^(BOOL finished) {
        [imageView setImage:nil];
        [imageView removeFromSuperview];
    }];
     
    [self.view addSubview:imageView];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [self.view setHidden:YES];
    [super viewWillDisappear:animated];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.view setHidden:NO];
    
    [DEScreenManager setBackgroundWithImageURL:@"newyorkbackground.png"];
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"HomeScreen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL) promptLoginHasBeenDisplayed {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if (![userDefaults objectForKey:kUSER_DEFAULTS_PROMPTED_FOR_LOGIN]) {
        [userDefaults setObject:@YES forKey:kUSER_DEFAULTS_PROMPTED_FOR_LOGIN];
        return NO;
    }
    
    return YES;
}

- (IBAction)viewWhatsGoingOnLater:(id)sender {
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Trending"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];

    
    [[[DELocationManager sharedManager] locationManager] startUpdatingLocation];
    
    tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Home"
                                                          action:@"ButtonClick"
                                                           label:@"What's Happening Later"
                                                           value:nil] build]];

     if ([self isLoggedIn : NO])
    {
        // Do any additional setup after loading the view.
        UIStoryboard *viewPosts = [UIStoryboard storyboardWithName:@"ViewPosts" bundle:nil];
        DEViewEventsViewController *viewEventsViewController = [viewPosts instantiateInitialViewController];
        [self.navigationController pushViewController:viewEventsViewController animated:NO];
        viewEventsViewController.now = NO;
    }
    else {
        UIStoryboard *viewPosts = [UIStoryboard storyboardWithName:@"ViewPosts" bundle:nil];
        DEViewEventsViewController *viewEventsViewController = [viewPosts instantiateInitialViewController];
        
        [self setNextScreenWithViewController:viewEventsViewController];
    }

    DEScreenManager *manager = [DEScreenManager sharedManager];
    manager.isLater = YES;

}

- (IBAction)viewWhatsGoingOnNow:(id)sender {
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Trending"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];

    [[[DELocationManager sharedManager] locationManager] startUpdatingLocation];
    
    tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Home"
                                                          action:@"ButtonClick"
                                                           label:@"What's Happening Now"
                                                           value:nil] build]];

    
    if ([self isLoggedIn : NO])
    {
        // Do any additional setup after loading the view.
        UIStoryboard *viewPosts = [UIStoryboard storyboardWithName:@"ViewPosts" bundle:nil];
        DEViewEventsViewController *viewEventsViewController = [viewPosts instantiateInitialViewController];
        [self.navigationController pushViewController:viewEventsViewController animated:NO];
        viewEventsViewController.now = YES;
    }
    else {
        UIStoryboard *viewPosts = [UIStoryboard storyboardWithName:@"ViewPosts" bundle:nil];
        DEViewEventsViewController *viewEventsViewController = [viewPosts instantiateInitialViewController];
        viewEventsViewController.now = YES;
        [self setNextScreenWithViewController:viewEventsViewController];
    }
    
    DEScreenManager *manager = [DEScreenManager sharedManager];
    manager.isLater = NO;
}

- (void) setNextScreenWithViewController : (UIViewController *) viewController {
    DEScreenManager *screenManager = [DEScreenManager sharedManager];
    screenManager.nextScreen = viewController;
}


- (IBAction)showCreatePostView:(id)sender {

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults objectForKey:EPIC_EVENTS_SCREEN_PROMPTED])
    {
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
    else {
        [defaults setObject:@YES forKey:EPIC_EVENTS_SCREEN_PROMPTED];
        [defaults synchronize];
        DEPromptForEpicEventsViewController *viewController = [[DEPromptForEpicEventsViewController alloc] initWithNibName:@"PromptForViewEpicEventsView" bundle:nil];
        [self.navigationController pushViewController:viewController animated:YES];
        [self.navigationController setNavigationBarHidden:YES];
    }
    
}

// (BOOL) posting - Let's us know whether the user is trying to post an event or not

- (BOOL) isLoggedIn : (BOOL) posting {
    DEUserManager *userManager = [DEUserManager sharedManager];
    
    if (![userManager isLoggedIn] && ![self promptLoginHasBeenDisplayed])
    {
        DELoginViewController *loginViewController = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:PROMPT_LOGIN_VIEW_CONTROLLER];
        [[self navigationController] pushViewController:loginViewController animated:YES];
        [[loginViewController navigationController] setNavigationBarHidden:YES animated:YES];
        
        // If the user pressed post it then we don't want them to be able to skip this section
        loginViewController.posting = posting;
        
        return NO;
    }
    
    return YES;
}

@end
