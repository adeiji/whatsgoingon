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
    // Instantiate the Location Manager and set the user location to the current location
    DELocationManager *sharedManager = [DELocationManager sharedManager];
    [sharedManager setUserLocation:[sharedManager currentLocation]];
}

// Display the splash image and then fade into the first screen of the application

- (void) transitionFromSplashScreen {
    UIImageView *imageView = [UIImageView new];
    UIImage *launchImage = [UIImage imageNamed:@"splashimage.png"];
    
    [imageView setFrame:CGRectMake(0, 0, 320, 568)];
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


- (void) showCreatePostView:(id)sender {
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

// Take the user straight to the Create Post View Controller
- (IBAction)noThanksPressed:(id)sender {
    
    [self showCreatePostView:nil];
    [DEAnimationManager fadeOutRemoveView:(UIView *) _promptEpicEventsView FromView:self.view];
}

- (IBAction)postingButtonPressed:(id)sender {
    
    UINavigationController *navController = self.navigationController;
    BOOL viewEventsViewControllerInNavigationStack = NO;
    for (UIViewController *viewController in [navController viewControllers]) {
        
        // Check to see if the View Events View Controller is in the navigation view controller stack, if not then push it to the screen, otherwise just show the past epic events
        if ([viewController isKindOfClass:[DEViewEventsViewController class]])
        {
            viewEventsViewControllerInNavigationStack = YES;
        }
    }
    
    if (viewEventsViewControllerInNavigationStack)
    {
        [DESyncManager loadEpicEvents:YES];
    }
    else {
        DEViewEventsViewController *veViewController = [[UIStoryboard storyboardWithName:@"ViewPosts" bundle:nil] instantiateInitialViewController];
        veViewController.shouldNotDisplayPosts = YES;
        [navController pushViewController:veViewController animated:YES];
        [DESyncManager loadEpicEvents:YES];
    }
    
    [DEAnimationManager fadeOutRemoveView:(UIView *) _promptEpicEventsView FromView:self.view];
}
- (IBAction)showPromptForEpicEventsView:(id)sender {
    _promptEpicEventsView = [[[NSBundle mainBundle] loadNibNamed:@"PromptForViewEpicEventsView" owner:self options:nil] firstObject];
    [DEAnimationManager fadeOutWithView:self.view ViewToAdd:(UIView *) _promptEpicEventsView];
}

@end
