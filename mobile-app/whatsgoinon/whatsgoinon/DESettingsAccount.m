//
//  DESettingsAccount.m
//  whatsgoinon
//
//  Created by adeiji on 8/19/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import "DESettingsAccount.h"
#import "Constants.h"

@implementation DESettingsAccount

const int FEEDBACK_ACTION_SHEET = 1;
const int PICTURE_ACTION_SHEET = 2;

- (id)initWithUser : (PFUser *) myUser
          IsPublic : (BOOL) myIsPublic
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"ViewSettingsAccount" owner:self options:nil] firstObject];
        user = myUser;
        isPublic = myIsPublic;
        [self setUpButtons];
        [self addObservers];
        [self registerForKeyboardNotifications];
        if ([PFUser currentUser])
        {
            [DEUserManager getUserRank : [myUser username]];
            [DESyncManager getNumberOfPostByUser : myUser.username];
        }
        else {

        }
        self.lblRank.text = @"";
        self.ambassadorFlag.hidden = YES;
        [self displayMemberSince];
        [self setUpTextFields];
        [self setUpSocialNetworkingIcons];
        [self displayProfilePicture];
    }
    return self;    
}

- (void) setIsPublic:(BOOL)myIsPublic
{
    if (myIsPublic)
    {
        _txtPassword.hidden = YES;
        _btnSendFeedback.hidden = YES;
        _btnSignOut.hidden = YES;
        _lblConnected.hidden = YES;
        _lblTwitter.hidden = YES;
        _lblFacebook.hidden = YES;
        _switchFacebook.hidden = YES;
        _switchTwitter.hidden = YES;
        _btnTakePicture.userInteractionEnabled = NO;
        _txtUsername.enabled = NO;
        _btnChangePassword.hidden = YES;
    }
    
    isPublic = myIsPublic;
}

- (void) setUpSocialNetworkingIcons {
    if (![[DEUserManager sharedManager] isLoggedIn])
    {
        [_btnSignOut setTitle:@"Sign Up" forState:UIControlStateNormal];
    }
    
    if ([[DEUserManager sharedManager] isLinkedWithFacebook])
    {
        _switchFacebook.on = YES;
    }
    else
    {
        _switchFacebook.on = NO;
    }
    
    if ([[DEUserManager sharedManager] isLinkedWithTwitter])
    {
        _switchTwitter.on = YES;
    }
    else {
        _switchTwitter.on = NO;
    }
}

# pragma mark - Keyboard Notifications

- (void) registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void) keyboardWillShow : (NSNotification *) aNotification {
    [self scrollViewToTopOfKeyboard:(UIScrollView *) [self superview] Notification:aNotification View:self TextFieldOrView:activeField];
}

- (void) keyboardWillBeHidden : (NSNotification *) aNotification {
    [self scrollViewToBottom:(UIScrollView *) [self superview] Notification:aNotification];
}

# pragma mark - Text Field Delegate
- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    activeField = textField;
}

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([_txtPassword.text isEqualToString:_txtConfirmPassword.text])
    {
        [_btnChangePassword setTitle:@"Save New Password" forState:UIControlStateNormal];
        [_btnChangePassword addTarget:self action:@selector(savePassword) forControlEvents:UIControlEventTouchUpInside];
        [_btnChangePassword removeTarget:self action:@selector(changePasswordPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    else {
        [_btnChangePassword setTitle:@"Cancel" forState:UIControlStateNormal];
        [_btnChangePassword removeTarget:self action:@selector(savePassword) forControlEvents:UIControlEventTouchUpInside];
        [_btnChangePassword addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    }
    return YES;
}

- (void) setUpButtons {
    [[_btnTakePicture layer] setCornerRadius:_btnTakePicture.frame.size.height / 2.0f];
    [[_btnTakePicture layer] setBorderWidth:2.0f];
    [[_btnTakePicture layer] setBorderColor:[UIColor whiteColor].CGColor];
    [_btnTakePicture setClipsToBounds:YES];
    [[_btnSendFeedback layer] setCornerRadius:BUTTON_CORNER_RADIUS];
    [[_btnSignOut layer] setCornerRadius:BUTTON_CORNER_RADIUS];
    
    [[_btnChangePassword layer] setCornerRadius:BUTTON_CORNER_RADIUS];
}

- (void) addObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayNumberOfPostForUser:) name:NOTIFICATION_CENTER_POST_FROM_USER_RETRIEVED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayUserRank:) name:NOTIFICATION_CENTER_USER_RANK_RETRIEVED object:nil];
}

- (void) displayUserRank : (NSNotification *) notification {
    NSString *userRank = notification.userInfo[kNOTIFICATION_CENTER_USER_RANK_OBJECT_INFO];
    if ([userRank isEqualToString:USER_RANK_AMBASSADOR])
    {
        self.ambassadorFlag.hidden = NO;
        _progressBarForLevel.hidden = NO;
        _lblProgressToNextLevel.hidden = NO;
    }
    self.lblRank.text = [notification.userInfo[kNOTIFICATION_CENTER_USER_RANK_OBJECT_INFO] capitalizedString];
}


- (void) displayMemberSince {
    NSDate *date = [user createdAt];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yyyy"];
    self.lblMemberSince.text = [formatter stringFromDate:date];
}

- (void) displayNumberOfPostForUser:(NSNotification *) notification
{
    NSNumber *numberOfPost = [notification.userInfo objectForKey:kNOTIFICATION_CENTER_USER_INFO_USER_EVENTS_COUNT];
    self.lblNumberOfPosts.text = [numberOfPost stringValue];
    
    DELevelHandler *levelHandler = [[DELevelHandler alloc] init];
    
    __block NSInteger level = 0;

    __block NSNumber *postSinceLastLevel = [NSNumber new];
    // This post variable is called postNecessaryToReachAde, because this is the amount of post it will take to reach the next level, where Ade resides
    __block NSNumber *postNecessaryToReachAde = [NSNumber new];
    // This is the necessary post required to reach the previous level
    __block NSNumber *postNecessaryForAyosLevel = [NSNumber new];
    
    [[levelHandler levels] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (numberOfPost > (NSNumber *) obj)
        {
            level ++;
            postSinceLastLevel = [NSNumber numberWithLong:(numberOfPost.integerValue - ((NSNumber *) obj).integerValue)];
            postNecessaryForAyosLevel = obj;
        }
        else {
            *stop = YES;
            postNecessaryToReachAde = [NSNumber numberWithLong: ((NSNumber *) obj).integerValue - postNecessaryForAyosLevel.integerValue];
        }
    }];
    
    _lblLevel.text = [NSString stringWithFormat:@"%li", (long)level];
    [_progressBarForLevel setProgress:(postSinceLastLevel.doubleValue / postNecessaryToReachAde.doubleValue) animated:YES];
    _progressBarForLevel.transform = CGAffineTransformMakeScale(1.0f, 2.0f);
}

- (void) displayProfilePicture
{
    if (!isPublic)
    {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSData *imageData = [userDefaults objectForKey:@"profile-picture"];
        UIImage *image = [UIImage imageWithData:imageData];
        
        if (!image)
        {
            [_btnTakePicture setNoProfileImage:YES];
        }
        else
        {
            [_btnTakePicture setBackgroundImage:image forState:UIControlStateNormal];
        }
        
    }
    else {
        // Load the profile image from the server
        PFFile *imageFile = user[PARSE_CLASS_USER_PROFILE_PICTURE];
        
        [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            
            @autoreleasepool {
                NSData *imageData = data;
                UIImage *image = [UIImage imageWithData:imageData];
                
                if (image)
                {
                    [_btnTakePicture setNoProfileImage:NO];
                    [_btnTakePicture setBackgroundImage:image forState:UIControlStateNormal];
                }
                else {
                    [_btnTakePicture setNoProfileImage:YES];
                }
                image = nil;
            }
        }];
    }
}

- (void) setUpTextFields
{
    NSArray *array = [NSArray arrayWithObjects:_txtPassword, _txtUsername, _txtConfirmPassword, nil];
    [DEScreenManager setUpTextFields:array];
    
    _txtUsername.text = user[PARSE_CLASS_USER_USERNAME];
    // Get the password that can actually be viewed on within the app
    _txtPassword.text = user[PARSE_CLASS_USER_VISIBLE_PASSWORD];
    _txtPassword.delegate = self;
    _txtConfirmPassword.delegate = self;
}


- (IBAction)sendFeedback:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Email Feedback", @"Write a Review",nil];
    actionSheet.tag = FEEDBACK_ACTION_SHEET;
    [[DEScreenManager sharedManager] setNextScreen:[[DEScreenManager getMainNavigationController] topViewController]];

    [actionSheet showInView:self];
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == FEEDBACK_ACTION_SHEET)
    {
        if (buttonIndex == 0)
        {
            [[DEScreenManager sharedManager] showEmail];
        }
    }
    else if (actionSheet.tag == PICTURE_ACTION_SHEET)
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        
        // Display the camera
        if (buttonIndex == 1)
        {
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.allowsEditing = YES;
        }
        else if (buttonIndex == 0) {
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        
        // Let the user take a picture and store it
        picker.delegate = self;
        UINavigationController *navController = [DEScreenManager getMainNavigationController];
        [navController.topViewController presentViewController:picker animated:YES completion:NULL];
    }
    

}
- (IBAction)takePicture:(id)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Choose From Photo Library", @"Take a Picture",nil];
    
    [actionSheet showInView:self];
    actionSheet.tag = PICTURE_ACTION_SHEET;

}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //Get the original image
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    //Shrink the size of the image.
    UIGraphicsBeginImageContext( CGSizeMake(70, 56) );
    [image drawInRect:CGRectMake(0,0,70,56)];
    UIGraphicsEndImageContext();
    
    // Set the image at the correct location so that it can be restored later to this same exact location
    [_btnTakePicture setBackgroundImage:image forState:UIControlStateNormal];
    NSData *imageData = UIImageJPEGRepresentation (
                                        image,
                                        .01
                                        );
    [DEUserManager addProfileImage:imageData];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

/*

 Display a prompt asking if the user wants to quit for sure

 */
- (IBAction)signOut:(id)sender {
    
    if ([[DEUserManager sharedManager] isLoggedIn])
    {
        promptView = [[[NSBundle mainBundle] loadNibNamed:@"ViewSettingsAccount" owner:self options:nil] lastObject];
        [DEAnimationManager fadeOutWithView:self ViewToAdd:promptView];
        [promptView setFrame:self.frame];
        
        // Set up the view of the prompt screen
        [self setUpPromptViewButtons];
    }
    else
    {
        DELoginViewController *loginViewController = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:PROMPT_LOGIN_VIEW_CONTROLLER];
        
        loginViewController.btnSkip.hidden = YES;
        [[DEScreenManager getMainNavigationController] pushViewController:loginViewController animated:YES];
    }
}

- (void) setUpPromptViewButtons {
    
    for (UIView *view in [promptView subviews]) {
        if ([view isKindOfClass:[UIButton class]])
        {
            [[view layer] setCornerRadius:BUTTON_CORNER_RADIUS];
        }
    }
    
}

#pragma mark - Button Presses

- (IBAction)goBack:(id)sender {
    [DEAnimationManager fadeOutRemoveView:[self superview] FromView:[[self superview] superview]];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


/*
 
 Signs the user out of the app
 
 */
- (IBAction)signOutUser:(id)sender {
    
    [PFUser logOut];
    [_btnSignOut setTitle:@"Sign Up" forState:UIControlStateNormal];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [promptView removeFromSuperview];
    [[DEScreenManager getMainNavigationController] popToRootViewControllerAnimated:YES];
}

- (IBAction)goBackToAccountScreen:(id)sender {
    [DEAnimationManager fadeOutRemoveView:promptView FromView:self];
}

- (IBAction)changePasswordPressed:(id)sender {
    // Move the view that contains the buttons and the social media prompts down
    [self changePasswordButtonFunction];
}

/*
 
 Checks to see if the user has clicked on Change Password or on Save New Password
 If the user has clicked on change password then we display the password text fields
 Otherwise we slide the bottom half of the screen back up
 
 */
- (void) changePasswordButtonFunction {
    static BOOL changePasswordPressed;
    
    if (!changePasswordPressed)
    {
        [_btnChangePassword setTitle:@"Cancel" forState:UIControlStateNormal];
        // Remove the target first then add the new target otherwise this will not work
        [_btnChangePassword removeTarget:self action:@selector(changePasswordPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_btnChangePassword addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        changePasswordPressed = YES;
        _txtPassword.hidden = NO;
        _txtConfirmPassword.hidden = NO;
    }
    else {
        [_btnChangePassword setTitle:@"Change Password" forState:UIControlStateNormal];
        // Remove the target first then add the new target otherwise this will not work
        [_btnChangePassword removeTarget:self action:@selector(savePassword) forControlEvents:UIControlEventTouchUpInside];
        [_btnChangePassword addTarget:self action:@selector(changePasswordPressed:) forControlEvents:UIControlEventTouchUpInside];
        changePasswordPressed = NO;
        _txtPassword.hidden = YES;
        _txtConfirmPassword.hidden = YES;
    }

}

#pragma mark - Change Password Button Functionality


/*
 
User presses the cancel button and we just want to hide the password text fields
 
 */
- (void) cancel {
    _txtPassword.hidden = YES;
    _txtConfirmPassword.hidden = YES;
    [_btnChangePassword setTitle:@"Change Password" forState:UIControlStateNormal];
    [_btnChangePassword addTarget:self action:@selector(changePasswordPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_btnChangePassword removeTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
}

- (void) savePassword {

    
    if ([_txtPassword.text isEqualToString:_txtConfirmPassword.text])
    {
        // Save the new password to the parse database
        [[DEUserManager sharedManager] changePassword:_txtPassword.text];
        
        _txtConfirmPassword.hidden = YES;
        _txtPassword.hidden = YES;
        [self changePasswordButtonFunction];
        _lblPasswordError.text = @"Password Saved";
        _txtConfirmPassword.text = @"";
        [_lblPasswordError setTextAlignment:NSTextAlignmentCenter];
        
        [UIView animateWithDuration:1.5 animations:^{
            [[_lblPasswordError layer] setOpacity:0.0f];
        }];
        
    }
    else {
        [_lblPasswordError setTextAlignment:NSTextAlignmentLeft];
        _lblPasswordError.text = @"Passwords do not match";
    }
    
}
@end
