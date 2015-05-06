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
#import "DESettingsAccount.h"
#import "DEMaybeCheckmarkView.h"
#import "DEViewImagesViewController.h"
#import "DEViewImageViewController.h"
#import "DEFinishedPostingView.h"
   


@class DEPost, DEViewEventsView, DEEventView;

@interface DEEventViewController : UIViewController <UIActionSheetDelegate>
{
    BOOL userIsAmbassador;
    PFUser *user;
    int goingButtonBottomSpaceConstraintConstant;
    UIView *deletionPromptView;
}

@property BOOL isPreview;
@property (weak, nonatomic) DEPost *post;
@property (strong, nonatomic) PFObject *postObject;
@property (weak, nonatomic) DEViewEventsView *viewEventView;
@property (weak, nonatomic) IBOutlet DEEventView *eventView;
@property (weak, nonatomic) IBOutlet UIButton *btnPost;
@property (weak, nonatomic) IBOutlet DEEventView *mapView;
@property (weak, nonatomic) IBOutlet DEMaybeCheckmarkView *maybeCheckmarkView;
@property (weak, nonatomic) IBOutlet UILabel *lblEventTitle;
@property (strong, nonatomic) DEEventDetailsViewController *eventDetailsViewController;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goingButtonTopSpaceConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goingButtonBottomSpaceConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goingButtonBottomSpaceConstraintMapView;
@property BOOL isEditDeleteMode;
@property BOOL isGoing;
@property BOOL isMaybeGoing;
@property BOOL isUpdateMode;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintMapViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintMainImageHeight;

#pragma mark - Button Action Methods

- (IBAction)showEventDetails:(id)sender;
- (IBAction)showEventComments:(id)sender;
- (IBAction)shareEvent:(id)sender;
- (IBAction)viewMoreForEvent:(id)sender;
- (IBAction)goBack:(id)sender;
- (IBAction)savePost:(id)sender;
- (IBAction)setEventAsGoing:(id)sender;
- (IBAction)showImages:(id)sender;

#pragma mark - Private Methods

- (void) updateViewToGoing;

@end
