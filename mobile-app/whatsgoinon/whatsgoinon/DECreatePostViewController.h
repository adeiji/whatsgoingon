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
#import "DELocationManager.h"
#import "DEEventViewController.h"
#import "DEAddValueViewController.h"


@interface DECreatePostViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate>
{
    int imageCounter;
}
#pragma mark - Action Methods

- (IBAction)displayCurrentLocation:(id)sender;
- (IBAction)displayPreview:(id)sender;
- (IBAction)displayInfo:(id)sender;
- (IBAction)gotoNextScreen:(id)sender;
- (IBAction)takePicture:(id)sender;

@property (strong, nonatomic) IBOutlet DECreatePostView *createPostViewOne;
@property (strong, nonatomic) IBOutlet DECreatePostView *createPostViewTwo;

@property (strong, nonatomic) DEPost *post;
@property (strong, nonatomic) NSMutableArray *images;
@property (strong, nonatomic) PFGeoPoint *location;

@end
