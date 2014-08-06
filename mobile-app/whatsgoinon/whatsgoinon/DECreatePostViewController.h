//
//  DECreatePostViewController.h
//  whatsgoinon
//
//  Created by adeiji on 8/5/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DECreatePostView.h"
#import "DEPost.h"

@interface DECreatePostViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

#pragma mark - Action Methods

- (IBAction)displayCurrentLocation:(id)sender;
- (IBAction)displayPreview:(id)sender;
- (IBAction)displayInfo:(id)sender;
- (IBAction)gotoNextScreen:(id)sender;
- (IBAction)takePicture:(id)sender;

@property (strong, nonatomic) IBOutlet DECreatePostView *createPostViewOne;
@property (strong, nonatomic) IBOutlet DECreatePostView *createPostViewTwo;

@property (strong, nonatomic) DEPost *post;

@end
