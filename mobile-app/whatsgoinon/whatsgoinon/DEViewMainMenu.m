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
        UIView *bottomBorder = [[UIView alloc] initWithFrame:CGRectMake(0, view.frame.size.height - 1, view.frame.size.width, .1)];
        [bottomBorder setBackgroundColor:[UIColor whiteColor]];
        [view addSubview:bottomBorder];
    }
    // If the person has not logged in, then we don't show the posted by me menu item
    if ([PFUser currentUser] == nil)
    {
        _btnPostedByMe.hidden = YES;
        _viewPostedByMe.hidden = YES;
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

- (void) showPostPage {
    [[DEPostManager sharedManager] setCurrentPost:[DEPost new]];
    
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

- (IBAction)gotoPostPage:(id)sender {
    DEPromptForEpicEventsViewController *viewController = [[DEPromptForEpicEventsViewController alloc] initWithNibName:@"PromptForViewEpicEventsView" bundle:nil] ;
    [[DEScreenManager getMainNavigationController] pushViewController:viewController animated:YES];
    [self hideMenu:nil];
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
    
    if ([self isLoggedIn:YES])
    {
        DESettingsAccount *settingsAccount = [[DESettingsAccount alloc] initWithUser:[PFUser currentUser] IsPublic:NO];

        UIScrollView *scrollView = [[[NSBundle mainBundle] loadNibNamed:@"ViewSettingsAccount" owner:self options:nil] objectAtIndex:1];
        [scrollView setContentSize:settingsAccount.frame.size];
        [scrollView addSubview:settingsAccount];
        [scrollView setFrame:[[UIScreen mainScreen] bounds]];
        [settingsAccount setFrame:[scrollView frame]];
        
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

- (IBAction)showMyEvents:(id)sender {
    // Send a notification that my events was pressed
    [DESyncManager getAllSavedEvents];
}

- (IBAction)showPastEpicEvents:(id)sender {
    [DESyncManager loadEpicEvents:YES];
}

- (IBAction)showPostedByUserEvents:(id)sender {
    [DESyncManager getEventsPostedByUser:[[PFUser currentUser] username]];
}

- (void) drawRect:(CGRect)rect
{
    

}
@end
