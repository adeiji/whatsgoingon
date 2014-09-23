//
//  DECreatePostViewOne.m
//  whatsgoinon
//
//  Created by adeiji on 8/5/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import "DECreatePostView.h"
#import "Constants.h"

@implementation DECreatePostView

- (void) willMoveToSuperview:(UIView *)newSuperview {
    _categoriesPicker = [UIPickerView new];
    _categoriesPicker.dataSource = self;
    _categoriesPicker.delegate = self;
    _categories = @[@"Under 21", @"Indie", @"Classy", @"Nerdy", @"Party", @"Family Friendly", @"Everything"];
    _txtCategory.inputView = _categoriesPicker;
    
    UIDatePicker *datePicker = [UIDatePicker new];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(updateDateTextField:)
         forControlEvents:UIControlEventValueChanged];

    [_txtStartDate setInputView:datePicker];
    [_txtEndDate setInputView:datePicker];
    UIDatePicker *timePicker = [UIDatePicker new];
    timePicker.datePickerMode = UIDatePickerModeTime;
    [timePicker addTarget:self action:@selector(updateTimeTextField:) forControlEvents:UIControlEventValueChanged];
    [timePicker setMinuteInterval:30];
    [_txtStartTime setInputView:timePicker];
    [_txtEndTime setInputView:timePicker];
    
    _txtStartTime.delegate = self;
    _txtEndTime.delegate = self;
    _txtAddress.delegate = self;
    _txtPostRange.delegate = self;
    _txtEndDate.delegate = self;
    _txtStartDate.delegate = self;
    _txtCategory.delegate = self;
    _txtTitle.delegate = self;
    _txtCost.delegate = self;
    
    [[_btnTakePicture layer] setBorderWidth:2.0f];
    [[_btnTakePicture layer] setBorderColor:[UIColor whiteColor].CGColor];
    [[_btnTakePicture layer] setCornerRadius:20.0f];
    
    for (UIView *view in _btnSmallPictureButtons) {
        [[view layer] setCornerRadius:5.0f];
    }
    
    [[_btnPreview layer] setCornerRadius:5.0f];

    [[_btnInfo layer] setCornerRadius:_btnInfo.frame.size.height / 2.0f];
    [[_btnInfo layer] setBorderWidth:1.0f];
    [[_btnInfo layer] setBorderColor:[UIColor whiteColor].CGColor];
    
    [self registerForKeyboardNotifications];
    [self displayCurrentLocation];
}

- (void) removeFromSuperview
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [super removeFromSuperview];
}

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
    [self scrollViewToTopOfKeyboard:_scrollView Notification:aNotification View:self TextFieldOrView:activeField];
}

- (void) keyboardWillBeHidden : (NSNotification *) aNotification {
    [self scrollViewToBottom:_scrollView Notification:aNotification];
}


- (void) hideKeyboard
{
    [activeField resignFirstResponder];
}

- (void) updateTimeTextField : (UIDatePicker *) sender {
    UITextField *textField;
    
    for (UIView *view in self.subviews) {
        if ([view isFirstResponder])
        {
            textField = (UITextField *) view;
        }
    }
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setTimeStyle:NSDateFormatterShortStyle];
    
    activeField.text = [dateFormat stringFromDate:sender.date];
    
    // If the current field is the start time, then automatically set the end time to three hours from now
    if ([activeField isEqual:_txtStartTime])
    {
       
        NSTimeInterval threeHours = (3 * 60 * 60) - 1;
        NSDate *endTime = [sender.date dateByAddingTimeInterval:threeHours];
        _txtEndTime.text = [dateFormat stringFromDate:endTime];
        
    }
    
    NSLog(@"%@", [dateFormat stringFromDate:sender.date]);
}

- (void) updateDateTextField : (UIDatePicker *) sender {
    
    UITextField *textField;
    
    for (UIView *view in self.subviews) {
        if ([view isFirstResponder])
        {
            textField = (UITextField *) view;
        }
    }
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/dd/YY"];
    activeField.text = [dateFormat stringFromDate:sender.date];
    
    // If the current field is the start date, then automatically set the end date to the same day
    if ([activeField isEqual:_txtStartDate])
    {
        _txtEndDate.text = activeField.text;
    }
    
    NSLog(@"%@", [dateFormat stringFromDate:sender.date]);
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [activeField resignFirstResponder];
}


#pragma mark - UITextField Delegate Methods
- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    activeField = textField;
    
    [_categoriesPicker reloadAllComponents];
    [_categoriesPicker selectRow:1 inComponent:0 animated:YES];
    
    if ([textField isEqual:_txtCategory]) {
        _txtCategory.text = [_categories objectAtIndex: [_categoriesPicker selectedRowInComponent:0]];
    }
    else if ([textField isEqual:_txtStartDate] || [textField isEqual:_txtEndDate]) {
        [self updateDateTextField:(UIDatePicker *)textField.inputView];
    }
    else if ([textField isEqual:_txtStartTime] || [textField isEqual:_txtEndTime]) {
        [self updateTimeTextField:(UIDatePicker *)textField.inputView];
    }
    else if ([textField isEqual:_txtAddress])
    {
        DEViewChangeCity *viewPostAddress = [[DEViewChangeCity alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
        [DEAnimationManager fadeOutWithView:self ViewToAdd:viewPostAddress];
        [viewPostAddress setUpViewWithType:PLACES_API_DATA_RESULT_TYPE_GEOCODE];

        [activeField resignFirstResponder];
        [viewPostAddress.searchBar becomeFirstResponder];
    }
}

#pragma mark -
#pragma mark PickerView DataSource

- (NSInteger)numberOfComponentsInPickerView:
(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    return _categories.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    return _categories[row];
}

#pragma mark -
#pragma mark PickerView Delegate
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
    self.txtCategory.text = [_categories objectAtIndex:row];
}

- (void) willRemoveSubview:(UIView *)subview {
    if ([subview isKindOfClass:[DEViewChangeCity class]])
    {
        NSString *fullAddress = ((DEViewChangeCity *) subview).selection;
        NSString *shortAddress = [fullAddress substringToIndex:[fullAddress rangeOfString:@","].location];
        _txtAddress.text = shortAddress;
    }
}


- (IBAction)enableOrDisableAddressBox:(UISwitch *)sender {
    
    [_txtAddress setEnabled:!sender.on];
    
    if (sender.on)
    {
        [self displayCurrentLocation];
    }
    else
    {
        _txtAddress.text = @"";
    }
}

- (void) displayCurrentLocation
{
    DELocationManager *locationManager = [DELocationManager sharedManager];
    [DELocationManager getAddressFromLatLongValue:[locationManager geoPoint] CompletionBlock:^(NSString *value) {
        _txtAddress.text = value;
    }];
}
@end
