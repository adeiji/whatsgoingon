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
    BOOL isEditMode;
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
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UIView *secondPageMainView;

@property (weak, nonatomic) IBOutlet UIButton *btnPreview;
@property (strong, nonatomic) NSString *longAddress;

#pragma mark - UIPickerView Properties

@property (strong, nonatomic) NSArray *categories;
@property (strong, nonatomic) UIPickerView *categoriesPicker;


#pragma mark - Constraint Outlets First Page Of Posting

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintUseCurrentLocationToEventLocationVerticalSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintAddressToCurrentLocationVerticalSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintPostRangeToAddressVerticalSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintScrollViewToHeaderSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintEventDetailsToTopOfScrollView;

#pragma mark - Constraints Outlets Second Page of Posting

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintScrollViewToLetsBuildIt;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintCameraToTitleVerticalSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintPriceToCameraBottomVerticalSpace;


#pragma mark - Button Actions

- (IBAction)enableOrDisableAddressBox:(id)sender;
- (void) setUpTextFieldAvailability : (BOOL) isUpdateMode;

- (void) displayCurrentLocation;
- (void) setupView;
/*
 
 Check to see if the text fields on the first page were entered correctly
 
 */
- (BOOL) validateTextFields;
/*
 
Check to see if the text fields on the second page were entered correctly
 
*/
- (BOOL) page2ValidateTextFields;
@end
