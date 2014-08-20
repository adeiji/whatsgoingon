//
//  DESettingsAccount.h
//  whatsgoinon
//
//  Created by adeiji on 8/19/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DESettingsAccount : UIView

#pragma mark - View Outlets

@property (weak, nonatomic) IBOutlet UITextField *txtUsername;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UISwitch *switchFacebook;
@property (weak, nonatomic) IBOutlet UISwitch *switchGoogle;

#pragma mark - Button Actions

- (IBAction)takePicture:(id)sender;
- (IBAction)sendFeedback:(id)sender;
- (IBAction)signOut:(id)sender;
- (IBAction)goBack:(id)sender;

@end
