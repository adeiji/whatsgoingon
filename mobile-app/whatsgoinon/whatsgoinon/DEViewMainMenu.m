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


- (IBAction)goHome:(id)sender {

    UINavigationController *nc = (UINavigationController *)[[[[UIApplication sharedApplication] delegate] window] rootViewController];
    
    [nc popToRootViewControllerAnimated:YES];
}

- (IBAction)gotoPostPage:(id)sender {
    
    UINavigationController *nc = (UINavigationController *)[[[[UIApplication sharedApplication] delegate] window] rootViewController];
    
    [nc popToRootViewControllerAnimated:NO];
    
    DECreatePostViewController *createPostViewController = [[UIStoryboard storyboardWithName:@"Posting" bundle:nil] instantiateInitialViewController];
    [nc pushViewController:createPostViewController animated:YES];
}

- (IBAction)gotoChangeCityPage:(id)sender {

    DEViewChangeCity *changeCity = [[DEViewChangeCity alloc] initWithFrame:CGRectMake(0, 0, 223, 568)];
    [changeCity setUpViewWithType:PLACES_API_DATA_RESULT_TYPE_CITIES];
    
    [self addSubview:changeCity];
}

- (IBAction)showFeedbackPage:(id)sender {
}

- (IBAction)gotoAccountSettingsPage:(id)sender {
    DESettingsAccount *settingsAccount = [[DESettingsAccount alloc] init];

    UIScrollView *scrollView = [[[NSBundle mainBundle] loadNibNamed:@"ViewSettingsAccount" owner:self options:nil] lastObject];
    [scrollView setContentSize:settingsAccount.frame.size];
    [scrollView addSubview:settingsAccount];
    [self addSubview:scrollView];
}

- (IBAction)hideMenu:(id)sender {
    [self removeFromSuperview];
}
@end
