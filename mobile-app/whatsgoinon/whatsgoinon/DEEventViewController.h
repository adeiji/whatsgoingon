//
//  DEEventViewController.h
//  whatsgoinon
//
//  Created by adeiji on 8/11/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DEPost.h"
#import "DEEventView.h"
#import "DEEventDetailsViewController.h"
#import "DEEventDetailsView.h"
#import "DESyncManager.h"
#import "DEScreenManager.h"
#import "DEEventDetailsMoreView.h"

@interface DEEventViewController : UIViewController

@property BOOL isPreview;
@property (strong, nonatomic) DEPost *post;
@property (strong, nonatomic) IBOutlet DEEventView *eventView;
@property (strong, nonatomic) DEEventDetailsViewController *eventDetailsViewController;

#pragma mark - Button Action Methods

- (IBAction)showEventDetails:(id)sender;
- (IBAction)showEventComments:(id)sender;
- (IBAction)shareEvent:(id)sender;
- (IBAction)viewMoreForEvent:(id)sender;

@end
