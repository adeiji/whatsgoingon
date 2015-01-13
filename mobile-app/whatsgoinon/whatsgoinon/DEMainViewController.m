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
    
    [DEScreenManager setBackgroundWithImageURL:@"main-vc-background.png"];
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
    if ([self isLoggedIn : NO])
    {
        // Do any additional setup after loading the view.
        UIStoryboard *viewPosts = [UIStoryboard storyboardWithName:@"ViewPosts" bundle:nil];
        DEViewEventsViewController *viewEventsViewController = [viewPosts instantiateInitialViewController];
        [self.navigationController pushViewController:viewEventsViewController animated:YES];
        viewEventsViewController.now = YES;
        [[DEScreenManager sharedManager] startActivitySpinner];
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

    DEPromptForEpicEventsViewController *viewController = [[DEPromptForEpicEventsViewController alloc] initWithNibName:@"PromptForViewEpicEventsView" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
    
    [self.navigationController setNavigationBarHidden:YES];
    
}

// (BOOL) posting - Let's us know whether the user is trying to post an event or not

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
    }
    
    return YES;
}

@end
