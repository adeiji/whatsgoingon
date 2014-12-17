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

@class DECreatePostView;

@interface DECreatePostViewController : UIViewController <UIImagePickerControllerDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIActionSheetDelegate, UINavigationControllerDelegate>
{
    int imageCounter;
    NSArray *postRanges;
    NSString *postRange;
    NSDictionary *dictionary;
    NSString *website;
}
#pragma mark - Action Methods

- (IBAction)displayPreview:(id)sender;
- (IBAction)displayInfo:(id)sender;
- (IBAction)gotoNextScreen:(id)sender;
- (IBAction)takePicture:(id)sender;
- (IBAction)goHome:(id)sender;
- (IBAction)togglePostRangeHelperView:(id)sender;
- (IBAction)goBack:(id)sender;

@property (weak, nonatomic) IBOutlet DECreatePostView *createPostViewOne;
@property (weak, nonatomic) IBOutlet DECreatePostView *createPostViewTwo;
@property (weak, nonatomic) IBOutlet UIView *btnPostRangeHelperView;
@property (strong, nonatomic) UIButton *currentButton;

@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *textFields;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;
@property (weak, nonatomic) IBOutlet UIButton *btnHome;
@property (weak, nonatomic) IBOutlet UIView *infoView;


@property (strong, nonatomic) DEPost *post;
@property (strong, nonatomic) PFGeoPoint *location;



@end
