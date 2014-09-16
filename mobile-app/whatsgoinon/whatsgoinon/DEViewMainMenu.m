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

- (void) setUpView {
    
    NSArray *array = [NSArray arrayWithObject:_txtSearch];
    [DEScreenManager setUpTextFields:array];
    
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
    
    UINavigationController *nc = (UINavigationController *)[[[[UIApplication sharedApplication] delegate] window] rootViewController];
    
    if ([[DEScreenManager sharedManager] mainMenu])
    {
        [[[DEScreenManager sharedManager] mainMenu] removeFromSuperview];
        [[DEScreenManager sharedManager] setMainMenu:nil];
    }

//    [nc popToRootViewControllerAnimated:NO];
    
    DECreatePostViewController *createPostViewController = [[UIStoryboard storyboardWithName:@"Posting" bundle:nil] instantiateInitialViewController];
    [nc pushViewController:createPostViewController animated:YES];
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
}

- (IBAction)gotoAccountSettingsPage:(id)sender {
    DESettingsAccount *settingsAccount = [[DESettingsAccount alloc] init];

    UIScrollView *scrollView = [[[NSBundle mainBundle] loadNibNamed:@"ViewSettingsAccount" owner:self options:nil] lastObject];
    [scrollView setContentSize:settingsAccount.frame.size];
    [scrollView addSubview:settingsAccount];
    [DEAnimationManager fadeOutWithView:self ViewToAdd:scrollView];
}

- (IBAction)hideMenu:(id)sender {
    [self removeFromSuperview];
}

- (void) drawRect:(CGRect)rect
{
    

}
@end
