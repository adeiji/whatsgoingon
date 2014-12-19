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
#import "DELargeCameraButton.h"
#import "UIView+DEScrollOnShowKeyboard.h"

@interface DESettingsAccount : UIView <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate>
{
    BOOL isPublic;
    PFUser *user;
    UIView *promptView;
    UITextField *activeField;
}

#pragma mark - View Outlets

@property (weak, nonatomic) IBOutlet UITextField *txtUsername;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtConfirmPassword;
@property (weak, nonatomic) IBOutlet UILabel *lblMemberSince;
@property (weak, nonatomic) IBOutlet UILabel *lblNumberOfPosts;
@property (weak, nonatomic) IBOutlet UISwitch *switchFacebook;
@property (weak, nonatomic) IBOutlet UISwitch *switchGoogle;
@property (weak, nonatomic) IBOutlet UISwitch *switchTwitter;
@property (weak, nonatomic) IBOutlet DELargeCameraButton *btnTakePicture;
@property (weak, nonatomic) IBOutlet UIButton *btnSendFeedback;
@property (weak, nonatomic) IBOutlet UIButton *btnSignOut;
@property (weak, nonatomic) IBOutlet UIButton *btnChangePassword;
@property (weak, nonatomic) IBOutlet UILabel *lblRank;
@property (weak, nonatomic) IBOutlet DEAmbassadorFlag *ambassadorFlag;
@property (weak, nonatomic) IBOutlet UILabel *lblFacebook;

@property (weak, nonatomic) IBOutlet UILabel *lblConnected;
@property (strong, nonatomic) UIView *viewToHide;
@property (weak, nonatomic) IBOutlet UILabel *lblTwitter;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIView *bottomHalfView;
@property (weak, nonatomic) IBOutlet UILabel *lblPasswordError;

#pragma mark - Button Actions

- (id) initWithUser : (PFUser *) user
           IsPublic : (BOOL) myIsPublic;
- (IBAction)takePicture:(id)sender;
- (IBAction)sendFeedback:(id)sender;
- (IBAction)signOut:(id)sender;
- (IBAction)goBack:(id)sender;
- (void) setIsPublic:(BOOL)myIsPublic;
- (IBAction)signOutUser:(id)sender;
- (IBAction)goBackToAccountScreen:(id)sender;
- (IBAction)changePasswordPressed:(id)sender;


@end
