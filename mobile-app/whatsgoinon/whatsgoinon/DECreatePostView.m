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
    _txtCategory.delegate = self;
    
    UIDatePicker *datePicker = [UIDatePicker new];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(updateDateTextField:)
         forControlEvents:UIControlEventValueChanged];
    
    [_txtStartDate setInputView:datePicker];
    _txtStartDate.delegate = self;
    [_txtEndDate setInputView:datePicker];
    _txtEndDate.delegate = self;
    
    UIDatePicker *timePicker = [UIDatePicker new];
    timePicker.datePickerMode = UIDatePickerModeTime;
    [timePicker addTarget:self action:@selector(updateTimeTextField:) forControlEvents:UIControlEventValueChanged];
    [_txtStartTime setInputView:timePicker];
    _txtStartTime.delegate = self;
    [_txtEndTime setInputView:timePicker];
    _txtEndTime.delegate = self;
    
    _txtAddress.delegate = self;

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
    
    textField.text = [dateFormat stringFromDate:sender.date];
    
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
    [dateFormat setDateFormat:@"EEEE MMMM d, YYYY"];
    textField.text = [dateFormat stringFromDate:sender.date];
    
    NSLog(@"%@", [dateFormat stringFromDate:sender.date]);
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
        [viewPostAddress setUpViewWithType:PLACES_API_DATA_RESULT_TYPE_GEOCODE];

        [activeField resignFirstResponder];
        [self addSubview:viewPostAddress];
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
        _txtAddress.text = ((DEViewChangeCity *) subview).selection;
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
