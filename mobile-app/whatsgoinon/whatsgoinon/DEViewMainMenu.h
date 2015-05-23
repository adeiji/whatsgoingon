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
#import "DEPromptForEpicEventsViewController.h"

@class DEPromptForEpicEvents;

@interface DEViewMainMenu : UIView <UIActionSheetDelegate>

@property (strong, nonatomic) UIView *viewToCutThrough;
@property (weak, nonatomic) IBOutlet UITextField *txtSearch;
@property (strong, nonatomic) IBOutletCollection(id) NSArray *viewCollection;
@property (strong, nonatomic) UIView *superView;
@property (weak, nonatomic) IBOutlet UIButton *btnPostedByMe;
@property (weak, nonatomic) IBOutlet UIView *viewPostedByMe;

- (IBAction)goHome:(id)sender;
- (IBAction)gotoPostPage:(id)sender;
- (IBAction)gotoChangeCityPage:(id)sender;
- (IBAction)showFeedbackPage:(id)sender;
- (IBAction)gotoAccountSettingsPage:(id)sender;
- (IBAction)hideMenu:(id)sender;
- (IBAction)showMyEvents:(id)sender;
- (IBAction)showPastEpicEvents:(id)sender;
- (IBAction)showPostedByUserEvents:(id)sender;
- (IBAction)viewWhatsGoingOnLater:(id)sender;


- (void) setupView;
@end
