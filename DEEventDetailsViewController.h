//
//  DEEventDetailsViewController.h
//  whatsgoinon
//
//  Created by adeiji on 8/11/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DESharingView;

@interface DEEventDetailsViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIView *viewMore;
@property (strong, nonatomic) IBOutlet DESharingView* viewShare;
@property (strong, nonatomic) IBOutlet UIView *viewNoComments;
@property (strong, nonatomic) IBOutlet UIView *viewComments;
@property (strong, nonatomic) IBOutlet UIView *viewSocialNetworkShare;
@property (strong, nonatomic) IBOutlet UIView *viewInfo;

- (IBAction)shareFacebookButtonPressed:(id)sender;

@end
