//
//  DEPromptForEpicEventsViewController.m
//  whatsgoinon
//
//  Created by adeiji on 1/7/15.
//  Copyright (c) 2015 adeiji. All rights reserved.
//

#import "DEPromptForEpicEventsViewController.h"

@interface DEPromptForEpicEventsViewController ()

@end

@implementation DEPromptForEpicEventsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"NeedInspire"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    [_promptEpicEventsView editButtons];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillDisappear:(BOOL)animated {
    [self.view setHidden:YES];
}

// Take the user straight to the Create Post View Controller
- (IBAction)noThanksPressed:(id)sender {
    
    [self showCreatePostView];
    [self removeSelfFromView];
}

- (void) removeSelfFromView {
    for (UIViewController *viewController in [self.navigationController viewControllers]) {
        if ([viewController isKindOfClass:[self class]])
        {
            NSMutableArray *array = [[self.navigationController viewControllers] mutableCopy];
            [array removeObject:viewController];
            [self.navigationController setViewControllers:array];
        }
    }
}

- (void) showCreatePostView {
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
    }
    
    return YES;
}

- (void) setNextScreenWithViewController : (UIViewController *) viewController {
    DEScreenManager *screenManager = [DEScreenManager sharedManager];
    screenManager.nextScreen = viewController;
}

- (BOOL) checkIfViewEventsViewControllerIsInTheNavigationStack {
    
    for (UIViewController *viewController in [self.navigationController viewControllers]) {
        
        // Check to see if the View Events View Controller is in the navigation view controller stack, if not then push it to the screen, otherwise just show the past epic events
        if ([viewController isKindOfClass:[DEViewEventsViewController class]])
        {
            return YES;
        }
    }
    
    return NO;
}

- (IBAction)showEpicEvents:(id)sender {
    
    if ([self checkIfViewEventsViewControllerIsInTheNavigationStack])
    {
        [self.navigationController popViewControllerAnimated:YES];
        [DESyncManager loadEpicEvents:YES];
    }
    else {
        DEViewEventsViewController *veViewController = [[UIStoryboard storyboardWithName:@"ViewPosts" bundle:nil] instantiateInitialViewController];
        veViewController.shouldNotDisplayPosts = YES;
        [self.navigationController pushViewController:veViewController animated:YES];
        [DESyncManager loadEpicEvents:YES];
    }
    
    [self removeSelfFromView];
    
}

@end
