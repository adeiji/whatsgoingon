//
//  DEViewMainMenu.m
//  whatsgoinon
//
//  Created by adeiji on 8/18/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import "DEViewMainMenu.h"

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

    DEViewChangeCity *changeCity = [[DEViewChangeCity alloc] init];
    
    [self addSubview:changeCity];
}

- (IBAction)showFeedbackPage:(id)sender {
}

- (IBAction)gotoAccountSettingsPage:(id)sender {
}

- (IBAction)hideMenu:(id)sender {
    [self removeFromSuperview];
}
@end
