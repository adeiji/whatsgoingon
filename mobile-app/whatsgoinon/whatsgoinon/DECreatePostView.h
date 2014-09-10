//
//  DECreatePostViewOne.h
//  whatsgoinon
//
//  Created by adeiji on 8/5/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DEScreenManager.h"
#import "DEViewChangeCity.h"
#import "DECameraButton.h"

@interface DECreatePostView : UIView <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UINavigationControllerDelegate>
{
    UITextField *activeField;
}


#pragma mark - View Outlets

@property (weak, nonatomic) IBOutlet UITextField *txtCategory;
@property (weak, nonatomic) IBOutlet UITextField *txtStartDate;
@property (weak, nonatomic) IBOutlet UITextField *txtStartTime;
@property (weak, nonatomic) IBOutlet UITextField *txtEndDate;
@property (weak, nonatomic) IBOutlet UITextField *txtEndTime;
@property (weak, nonatomic) IBOutlet UIButton *btnInfo;
@property (weak, nonatomic) IBOutlet UITextField *txtPostRange;
@property (weak, nonatomic) IBOutlet UITextField *txtAddress;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;
@property (weak, nonatomic) IBOutlet UISwitch *switchUseCurrentLocation;
@property (weak, nonatomic) IBOutlet DECameraButton *btnTakePicture;

@property (weak, nonatomic) IBOutlet UITextField *txtTitle;

@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *imageViews;

@property (weak, nonatomic) IBOutlet UITextField *txtCost;
@property (weak, nonatomic) IBOutlet UITextView *txtDescription;
@property (weak, nonatomic) IBOutlet UIButton *btnPreview;

#pragma mark - UIPickerView Properties

@property (strong, nonatomic) NSArray *categories;
@property (strong, nonatomic) UIPickerView *categoriesPicker;

#pragma mark - Button Actions

- (IBAction)enableOrDisableAddressBox:(id)sender;

- (void) displayCurrentLocation;

@end
