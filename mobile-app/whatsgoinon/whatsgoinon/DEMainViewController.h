//
//  DEMainViewController.h
//  whatsgoinon
//
//  Created by adeiji on 8/5/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DEViewEventsViewController.h"
#import "DEUserManager.h"
#import "DELoginViewController.h"

@class DEPromptForEpicEvents;

@interface DEMainViewController : UIViewController

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttons;
@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (strong, nonatomic) DEPromptForEpicEvents *promptEpicEventsView;
@property (strong, nonatomic) UIView *viewToBeRemoved;

- (IBAction)viewWhatsGoingOnNow:(id)sender;

- (IBAction)showCreatePostView:(id)sender;
@end
