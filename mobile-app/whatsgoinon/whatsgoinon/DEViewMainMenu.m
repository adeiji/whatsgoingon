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
    [[_txtSearch layer] setCornerRadius:5.0f];
    UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [_txtSearch setLeftViewMode:UITextFieldViewModeAlways];
    [_txtSearch setLeftView:spacerView];
    _txtSearch.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_txtSearch.placeholder attributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] }];
    
    for (UIView *view in _viewCollection) {
        UIView *bottomBorder = [[UIView alloc] initWithFrame:CGRectMake(0, view.frame.size.height - 1, view.frame.size.width, 1)];
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

- (void) drawRect:(CGRect)rect
{
    

}
@end
