//
//  DESharingView.h
//  whatsgoinon
//
//  Created by adeiji on 8/14/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DEPost.h"
#import "DEUserManager.h"

@class DEPost;

@interface DESharingView : UIView <MFMessageComposeViewControllerDelegate>

@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) DEPost *post;

#pragma mark - Outlets
@property (weak, nonatomic) IBOutlet UIButton *btnShareFacebook;
@property (weak, nonatomic) IBOutlet UIButton *btnShareInstagram;
@property (weak, nonatomic) IBOutlet UIButton *btnShareTwitter;
@property (weak, nonatomic) IBOutlet UIButton *btnShareText;

#pragma mark - Button Action Methods

- (IBAction)shareFacebook:(id)sender;
- (IBAction)shareInstagram:(id)sender;
- (IBAction)shareTwitter:(id)sender;
- (IBAction)shareText:(id)sender;

#pragma mark - Instance Methods
- (void) getAddress;

@end
