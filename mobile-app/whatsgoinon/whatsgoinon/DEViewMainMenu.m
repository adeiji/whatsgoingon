//
//  DEViewMainMenu.m
//  whatsgoinon
//
//  Created by adeiji on 8/18/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import "DEViewMainMenu.h"
#import "Constants.h"

@implementation DEViewMainMenu

- (void) setupView {
    
    for (UIView *view in _viewCollection) {
        UIView *bottomBorder = [[UIView alloc] initWithFrame:CGRectMake(0, view.frame.size.height - 1, view.frame.size.width, .5)];
        [bottomBorder setBackgroundColor:[UIColor whiteColor]];
        [view addSubview:bottomBorder];
    }
}

- (IBAction)goHome:(id)sender {

    UINavigationController *nc = (UINavigationController *)[[[[UIApplication sharedApplication] delegate] window] rootViewController];
    
    if ([[DEScreenManager sharedManager] mainMenu])
    {
        [[[DEScreenManager sharedManager] mainMenu] removeFromSuperview];
        [[DEScreenManager sharedManager] setMainMenu:nil];
    }
    
    [nc popToRootViewControllerAnimated:YES];
}

- (IBAction)gotoPostPage:(id)sender {
    
    if ([self isLoggedIn:YES])
    {
    
        UINavigationController *nc = (UINavigationController *)[[[[UIApplication sharedApplication] delegate] window] rootViewController];
        
        if ([[DEScreenManager sharedManager] mainMenu])
        {
            [[[DEScreenManager sharedManager] mainMenu] removeFromSuperview];
        }
        
        DECreatePostViewController *createPostViewController = [[UIStoryboard storyboardWithName:@"Posting" bundle:nil] instantiateInitialViewController];
        [nc pushViewController:createPostViewController animated:YES];
    }
    else {
        UIStoryboard *createPost = [UIStoryboard storyboardWithName:@"Posting" bundle:nil];
        DECreatePostViewController *createPostViewController = [createPost instantiateInitialViewController];
        
        [self setNextScreenWithViewController:createPostViewController];
    }
}

- (BOOL) isLoggedIn : (BOOL) posting {
    DEUserManager *userManager = [DEUserManager sharedManager];
    
    if (![userManager isLoggedIn])
    {
        UINavigationController *nc = [DEScreenManager getMainNavigationController];
        DELoginViewController *loginViewController = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:PROMPT_LOGIN_VIEW_CONTROLLER];
        [nc pushViewController:loginViewController animated:YES];
        [[[DEScreenManager sharedManager] mainMenu] removeFromSuperview];
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

- (IBAction)gotoChangeCityPage:(id)sender {

    DEViewChangeCity *changeCity = [[DEViewChangeCity alloc] init];
    
    CGRect frame = self.frame;
    frame.origin.y = 10;

    [changeCity setFrame:frame];
    [DEAnimationManager fadeOutWithView:self ViewToAdd:changeCity];
    [changeCity setUpViewWithType:PLACES_API_DATA_RESULT_TYPE_CITIES];
    [[changeCity searchBar] becomeFirstResponder];
}

- (IBAction)showFeedbackPage:(id)sender {
    
    DEViewEventsViewController *viewController = (DEViewEventsViewController *)[DEScreenManager getMainNavigationController].topViewController;
    [viewController hideMainMenu];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Email Feedback", @"Write a Review",nil];
    
    [[DEScreenManager sharedManager] setNextScreen:[[DEScreenManager getMainNavigationController] topViewController]];
    [actionSheet showInView:self];
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [[DEScreenManager sharedManager] showEmail];
    }
    else
    {
        
    }
}

- (IBAction)gotoAccountSettingsPage:(id)sender {
    
    if ([self isLoggedIn:NO])
    {
        DESettingsAccount *settingsAccount = [[DESettingsAccount alloc] initWithUser:[PFUser currentUser] IsPublic:NO];

        UIScrollView *scrollView = [[[NSBundle mainBundle] loadNibNamed:@"ViewSettingsAccount" owner:self options:nil] lastObject];
        [scrollView setContentSize:settingsAccount.frame.size];
        [scrollView addSubview:settingsAccount];
        [DEAnimationManager fadeOutWithView:[self superview] ViewToAdd:scrollView];
    }
    else {
        DEMainViewController *mainViewController = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateInitialViewController];
        [[DEScreenManager sharedManager] setNextScreen:mainViewController];
    }
}

- (IBAction)hideMenu:(id)sender {
    [self removeFromSuperview];
}

- (void) drawRect:(CGRect)rect
{
    

}
@end
