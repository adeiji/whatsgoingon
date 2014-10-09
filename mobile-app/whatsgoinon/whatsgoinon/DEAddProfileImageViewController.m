//
//  DEAddProfileImageViewController.m
//  whatsgoinon
//
//  Created by adeiji on 10/8/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import "DEAddProfileImageViewController.h"
#import "Constants.h"

@interface DEAddProfileImageViewController ()

@end

@implementation DEAddProfileImageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[_btnProfilePicture layer] setBorderColor:[UIColor whiteColor].CGColor];
    [[_btnProfilePicture layer] setBorderWidth:2.0f];
    [[_btnProfilePicture layer] setCornerRadius:BUTTON_CORNER_RADIUS * 2];
    
    [[_btnContinue layer] setCornerRadius:BUTTON_CORNER_RADIUS];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)gotoNextScreen:(id)sender {
    [[DEScreenManager sharedManager] gotoNextScreen];
    self.view.hidden = YES;
    
    [DEUserManager addProfileImage:profileImageData];
}
- (IBAction)takeProfileImagePicture:(id)sender {
    
    // Make sure that they have a camera on this device
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Choose From Photo Library", @"Take a Picture",nil];
            
        [actionSheet showInView:self.view];
    }
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    if (buttonIndex == 1)
    {
        // Let the user take a picture and store it
        picker.delegate = self;
        picker.allowsEditing = NO;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:NULL];
    }
    else if (buttonIndex == 0)
    {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.delegate = self;
        [self presentViewController:picker animated:YES completion:NULL];
    }
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    //Shrink the size of the image.
    UIGraphicsBeginImageContext( CGSizeMake(70, 56) );
    [image drawInRect:CGRectMake(0,0,70,56)];
    UIGraphicsEndImageContext();
    
    [_btnProfilePicture setBackgroundImage:image forState:UIControlStateNormal];

    NSData *imageData = UIImageJPEGRepresentation(image, .1);
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:imageData forKey:@"profile-picture"];
    [userDefaults synchronize];
    
    profileImageData = imageData;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
