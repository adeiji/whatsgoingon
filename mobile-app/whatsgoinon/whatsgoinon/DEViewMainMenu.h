//
//  DEViewMainMenu.h
//  whatsgoinon
//
//  Created by adeiji on 8/18/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DECreatePostViewController.h"
#import "DEViewChangeCity.h"

@interface DEViewMainMenu : UIView

- (IBAction)goHome:(id)sender;
- (IBAction)gotoPostPage:(id)sender;
- (IBAction)gotoChangeCityPage:(id)sender;
- (IBAction)showFeedbackPage:(id)sender;
- (IBAction)gotoAccountSettingsPage:(id)sender;
- (IBAction)hideMenu:(id)sender;


@end
