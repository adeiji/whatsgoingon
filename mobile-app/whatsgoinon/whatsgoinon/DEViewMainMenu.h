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
#import "DESettingsAccount.h"
#import "DEAnimationManager.h"
#import "DEScreenManager.h"
#import "DEMainViewController.h"

@interface DEViewMainMenu : UIView <UIActionSheetDelegate>

@property (strong, nonatomic) UIView *viewToCutThrough;
@property (weak, nonatomic) IBOutlet UITextField *txtSearch;
@property (strong, nonatomic) IBOutletCollection(id) NSArray *viewCollection;


- (IBAction)goHome:(id)sender;
- (IBAction)gotoPostPage:(id)sender;
- (IBAction)gotoChangeCityPage:(id)sender;
- (IBAction)showFeedbackPage:(id)sender;
- (IBAction)gotoAccountSettingsPage:(id)sender;
- (IBAction)hideMenu:(id)sender;

- (void) setupView;
@end
