//
//  DESettingsAccount.h
//  whatsgoinon
//
//  Created by adeiji on 8/19/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DEScreenManager.h"
#import "DEAnimationManager.h"
#import "MessageUI/MessageUI.h"
#import "DEUserManager.h"
#import "DEAmbassadorFlag.h"

@interface DESettingsAccount : UIView <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    BOOL isPublic;
    PFUser *user;
}

#pragma mark - View Outlets

@property (weak, nonatomic) IBOutlet UITextField *txtUsername;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UILabel *lblMemberSince;
@property (weak, nonatomic) IBOutlet UILabel *lblNumberOfPosts;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UISwitch *switchFacebook;
@property (weak, nonatomic) IBOutlet UISwitch *switchGoogle;
@property (weak, nonatomic) IBOutlet UISwitch *switchTwitter;
@property (weak, nonatomic) IBOutlet UIButton *btnTakePicture;
@property (weak, nonatomic) IBOutlet UIButton *btnSendFeedback;
@property (weak, nonatomic) IBOutlet UIButton *btnSignOut;
@property (weak, nonatomic) IBOutlet UILabel *lblRank;
@property (weak, nonatomic) IBOutlet DEAmbassadorFlag *ambassadorFlag;
@property (weak, nonatomic) IBOutlet UILabel *lblFacebook;

@property (weak, nonatomic) IBOutlet UILabel *lblConnected;
@property (strong, nonatomic) UIView *viewToHide;
@property (weak, nonatomic) IBOutlet UILabel *lblTwitter;

#pragma mark - Button Actions

- (id) initWithUser : (PFUser *) user
           IsPublic : (BOOL) myIsPublic;
- (IBAction)takePicture:(id)sender;
- (IBAction)sendFeedback:(id)sender;
- (IBAction)signOut:(id)sender;
- (IBAction)goBack:(id)sender;
- (void) setIsPublic:(BOOL)myIsPublic;

@end
