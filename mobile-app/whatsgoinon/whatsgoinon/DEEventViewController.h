//
//  DEEventViewController.h
//  whatsgoinon
//
//  Created by adeiji on 8/11/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DEEventDetailsViewController.h"
#import "DEEventDetailsView.h"
#import "DESyncManager.h"
#import "DEScreenManager.h"
#import "DEEventDetailsMoreView.h"
#import "DESharingView.h"
#import "DEViewEventsView.h"
#import "DEEventView.h"
#import "DEViewComments.h"

@class DEPost, DEViewEventsView, DEEventView;

@interface DEEventViewController : UIViewController <UIActionSheetDelegate>

@property BOOL isPreview;
@property (strong, nonatomic) DEPost *post;
@property (strong, nonatomic) DEViewEventsView *viewEventView;
@property (strong, nonatomic) IBOutlet DEEventView *eventView;
@property (strong, nonatomic) DEEventDetailsViewController *eventDetailsViewController;
@property (weak, nonatomic) IBOutlet UIButton *btnPost;
@property (weak, nonatomic) IBOutlet DEEventView *mapView;
@property BOOL isGoing;

#pragma mark - Button Action Methods

- (IBAction)showEventDetails:(id)sender;
- (IBAction)showEventComments:(id)sender;
- (IBAction)shareEvent:(id)sender;
- (IBAction)viewMoreForEvent:(id)sender;
- (IBAction)goBack:(id)sender;
- (IBAction)savePost:(id)sender;
@end
