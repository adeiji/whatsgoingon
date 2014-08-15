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

@interface DESharingView : UIView

@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) DEPost *post;

#pragma mark - Outlets
@property (weak, nonatomic) IBOutlet UIButton *btnShareFacebook;
@property (weak, nonatomic) IBOutlet UIButton *btnShareInstagram;
@property (weak, nonatomic) IBOutlet UIButton *btnShareTwitter;

#pragma mark - Button Action Methods

- (IBAction)shareFacebook:(id)sender;
- (IBAction)shareInstagram:(id)sender;
- (IBAction)shareTwitter:(id)sender;

#pragma mark - Instance Methods
- (BOOL) postToTwitter;
- (BOOL) postToFacebook;
- (BOOL) postToInstagram;
- (void) getAddress;

@end
