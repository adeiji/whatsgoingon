//
//  DEAddProfileImageViewController.h
//  whatsgoinon
//
//  Created by adeiji on 10/8/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DEScreenManager.h"
#import "DECameraButton.h"
#import "DEUserManager.h"

@interface DEAddProfileImageViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>
{
    NSData *profileImageData;
}

@property (weak, nonatomic) IBOutlet DECameraButton *btnProfilePicture;
@property (weak, nonatomic) IBOutlet UIButton *btnContinue;

@end
