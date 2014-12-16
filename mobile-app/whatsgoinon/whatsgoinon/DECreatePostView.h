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
#import "UIView+DEScrollOnShowKeyboard.h"
#import "TextFieldValidator.h"

@interface DECreatePostView : UIView <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UINavigationControllerDelegate>
{
    UITextField *activeField;
    NSString *costText;
}


#pragma mark - View Outlets

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet TextFieldValidator *txtCategory;
@property (weak, nonatomic) IBOutlet TextFieldValidator *txtStartDate;
@property (weak, nonatomic) IBOutlet TextFieldValidator *txtStartTime;
@property (weak, nonatomic) IBOutlet TextFieldValidator *txtEndDate;
@property (weak, nonatomic) IBOutlet TextFieldValidator *txtEndTime;
@property (weak, nonatomic) IBOutlet UIButton *btnInfo;
@property (weak, nonatomic) IBOutlet TextFieldValidator *txtPostRange;
@property (weak, nonatomic) IBOutlet TextFieldValidator *txtAddress;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;
@property (weak, nonatomic) IBOutlet UISwitch *switchUseCurrentLocation;
@property (weak, nonatomic) IBOutlet DECameraButton *btnTakePicture;
@property (weak, nonatomic) IBOutlet TextFieldValidator *txtQuickDescription;
@property (weak, nonatomic) IBOutlet TextFieldValidator *txtTitle;
@property (weak, nonatomic) IBOutlet TextFieldValidator *txtCost;
@property (weak, nonatomic) IBOutlet TextFieldValidator *txtDescription;
@property (weak, nonatomic) IBOutlet TextFieldValidator *txtWebsite;
@property (strong, nonatomic) IBOutletCollection(DECameraButton) NSArray *btnSmallPictureButtons;

@property (weak, nonatomic) IBOutlet UIButton *btnPreview;

#pragma mark - UIPickerView Properties

@property (strong, nonatomic) NSArray *categories;
@property (strong, nonatomic) UIPickerView *categoriesPicker;

#pragma mark - Button Actions

- (IBAction)enableOrDisableAddressBox:(id)sender;

- (void) displayCurrentLocation;
- (void) setupView;
- (BOOL) validateTextFields;
@end
