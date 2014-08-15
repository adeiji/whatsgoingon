//
//  DESharingView.h
//  whatsgoinon
//
//  Created by adeiji on 8/14/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DEPost.h"

@interface DESharingView : UIView

#pragma mark - Outlets

@property (weak, nonatomic) IBOutlet UISwitch *switchPostOnFacebook;
@property (weak, nonatomic) IBOutlet UISwitch *switchPostOnInstagram;
@property (weak, nonatomic) IBOutlet UISwitch *switchPostOnTwitter;
@property (weak, nonatomic) IBOutlet UIButton *btnShare;
@property (strong, nonatomic) DEPost *post;

#pragma mark - Button Action Methods

- (IBAction)sharePost:(id)sender;

#pragma mark - Instance Methods
- (BOOL) postToTwitter;
- (BOOL) postToFacebook;
- (BOOL) postToInstagram;

@end
