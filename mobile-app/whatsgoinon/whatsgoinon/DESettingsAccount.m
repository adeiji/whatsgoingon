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

- (id)init
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"ViewSettingsAccount" owner:self options:nil] firstObject];
        
        [[_btnTakePicture layer] setCornerRadius:_btnTakePicture.frame.size.height / 2.0f];
        [[_btnTakePicture layer] setBorderWidth:2.0f];
        [[_btnTakePicture layer] setBorderColor:[UIColor whiteColor].CGColor];
        [_btnTakePicture setClipsToBounds:YES];
        [[_btnSendFeedback layer] setCornerRadius:BUTTON_CORNER_RADIUS];
        [[_btnSignOut layer] setCornerRadius:BUTTON_CORNER_RADIUS];
        
        [self setUpTextFields];
    }
    return self;
}

- (void) setUpTextFields
{
    NSArray *array = [NSArray arrayWithObjects:_txtEmail, _txtPassword, _txtUsername, nil];
    [DEScreenManager setUpTextFields:array];
    
    _txtUsername.text = [[PFUser currentUser] username];
    _txtPassword.text = [[PFUser currentUser] password];
    _txtEmail.text = [[PFUser currentUser] email];
}


- (IBAction)sendFeedback:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Email Feedback", @"Write a Review",nil];
    
    [[DEScreenManager sharedManager] setNextScreen:[[DEScreenManager getMainNavigationController] topViewController]];
    [actionSheet showInView:self];
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [[DEScreenManager sharedManager] showEmail];
    }
    else
    {
        
    }
}
- (IBAction)takePicture:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    // Let the user take a picture and store it
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    UINavigationController *navController = [DEScreenManager getMainNavigationController];
    [navController.topViewController presentViewController:picker animated:YES completion:NULL];

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
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)signOut:(id)sender {
}

- (IBAction)goBack:(id)sender {
    [DEAnimationManager fadeOutRemoveView:[self superview] FromView:[[self superview] superview]];
}
@end
