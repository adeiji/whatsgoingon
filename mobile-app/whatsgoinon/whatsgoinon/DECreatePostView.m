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

const int DISPLAY_INFO_VIEW_HEIGHT = 118;
const int DISPLAY_INFO_VIEW_WIDTH = 183;

- (void) setupView {
    [self setPickers];
    [self setDelegates];
    [self setButtons];
    [self registerForKeyboardNotifications];
    [self addFreeButtonToCostTextField];
    [self setUpValidators];
    _txtStartTime.enabled = NO;
    _txtEndTime.enabled = NO;
    costText = [NSString new];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeFirstResponder)];
    if (_mainView)
    {
        [_mainView addGestureRecognizer:tapGestureRecognizer];
    }
    else
    {
        [_secondPageMainView addGestureRecognizer:tapGestureRecognizer];
    }
}

- (void) setUpTextFieldAvailability : (BOOL) isUpdateMode {
    if (isUpdateMode)
    {
        _txtStartTime.enabled = YES;
        _txtEndTime.enabled = YES;
        [self updateTextFieldDatePickers];
    }
    
    isEditMode = isUpdateMode;
}

- (void) updateTextFieldDatePickers {
    NSDateFormatter *df = [NSDateFormatter new];
    [df setDateFormat:@"MM/dd/yy"];
    // Set the start date and end date date pickers to the correct values
    NSDate *startDate = [df dateFromString:_txtStartDate.text];
    NSDate *endDate = [df dateFromString:_txtEndDate.text];
    UIDatePicker *datePicker = (UIDatePicker *) _txtStartDate.inputView;
    [datePicker setDate:startDate];
    datePicker = (UIDatePicker *) _txtEndDate.inputView;
    [datePicker setDate:endDate];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"hh:mm a";
    
    NSDate *startTime = [formatter dateFromString:_txtStartTime.text];
    NSDate *endTime = [formatter dateFromString:_txtEndTime.text];
    datePicker = (UIDatePicker *) _txtStartTime.inputView;
    [datePicker setDate:startTime];
    datePicker = (UIDatePicker *) _txtEndTime.inputView;
    [datePicker setDate:endTime];
}

- (void) removeFirstResponder {
    
    [activeField resignFirstResponder];
    
    if (!_infoView.hidden)
    {
        [self animateHideInfoView : _btnInfo];
    }
}

#pragma mark - Text Field Validation

- (void) setUpValidators {
    [_txtCategory addRegx:@"^(?!\\s*$).+" withMsg:@"Must select a category"];
    [_txtStartDate addRegx:@"^(?!\\s*$).+" withMsg:@"Must select a start date"];
    [_txtStartTime addRegx:@"^(?!\\s*$).+" withMsg:@"Must select a start time"];
    [_txtEndDate addRegx:@"^(?!\\s*$).+" withMsg:@"Must select an end date"];
    [_txtEndTime addRegx:@"^(?!\\s*$).+" withMsg:@"Must select an end time"];
    [_txtAddress addRegx:@"^(?!\\s*$).+" withMsg:@"Must enter a valid address"];
    [_txtTitle addRegx:@"^(?!\\s*$).+" withMsg:@"Must enter a valid title"];
    [_txtCost addRegx:@"^(?!\\s*$).+" withMsg:@"Must enter a valid price"];
    [_txtDescription addRegx:@"^(?!\\s*$).+" withMsg:@"Must enter a description"];
    [_txtQuickDescription addRegx:@"^(?!\\s*$).+" withMsg:@"Must enter a valid quick description"];
}

- (BOOL) validateTextFields
{
    
    NSDateFormatter *df = [NSDateFormatter new];
    [df setDateFormat:@"MM/dd/yy"];
    // Set the start date and end date date pickers to the correct values
    NSDate *startDate = [df dateFromString:_txtStartDate.text];
    NSDate *endDate = [df dateFromString:_txtEndDate.text];
    
    if ([startDate compare:endDate] == NSOrderedDescending)
    {
        [[_txtEndDate layer] setBorderWidth:2.0f];
        [[_txtEndDate layer] setBorderColor:[UIColor redColor].CGColor];
        
        return NO;
    }
    
    if ([_txtCategory validate] &
        [_txtStartDate validate] &
        [_txtStartTime validate] &
        [_txtEndDate validate] &
        [_txtEndTime validate] &
        [_txtAddress validate])
    {
        // Success
        return YES;
    }
    
    return NO;
}

- (BOOL) page2ValidateTextFields {
    
    if ([_txtTitle validate] &
        [_txtCost validate] &
        [_txtDescription validate] &
        [_txtQuickDescription validate])
    {
        // Success
        return YES;
    }
    
    return NO;
}

- (void) addFreeButtonToCostTextField
{
    UIButton *btnFree = [UIButton buttonWithType:UIButtonTypeSystem];
    [btnFree setFrame:CGRectMake(70, 10, 50.0f, 40.0f)];
    [btnFree setTitle:@"Free" forState:UIControlStateNormal];
    [btnFree setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnFree addTarget:self action:@selector(setCostToFree) forControlEvents:UIControlEventTouchUpInside];

    [_txtCost.inputAccessoryView addSubview:btnFree];
}

- (void) setButtons {
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
}

- (void) setPickers
{
    _categoriesPicker = [UIPickerView new];
    _categoriesPicker.dataSource = self;
    _categoriesPicker.delegate = self;
    
    NSMutableDictionary *plistData = [[NSMutableDictionary alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"categories" ofType:@"plist"]];
    
    // Remove the trending option from the picker
    NSMutableArray *array = [[plistData allKeys] mutableCopy];
    [array removeObject:CATEGORY_TRENDING];
    _categories = array;
    array = nil;
    
    _txtCategory.inputView = _categoriesPicker;
    [self setTextFieldInputViewForTextField:_txtStartDate DatePickerMode:UIDatePickerModeDate Selector:@selector(updateDateTextField:) MinuteInterval:0];
    [((UIDatePicker *) _txtStartDate.inputView) setMinimumDate:[NSDate new]];
    [self setTextFieldInputViewForTextField:_txtEndDate DatePickerMode:UIDatePickerModeDate Selector:@selector(updateDateTextField:) MinuteInterval:0];
    [self setTextFieldInputViewForTextField:_txtStartTime DatePickerMode:UIDatePickerModeTime Selector:@selector(updateTimeTextField:) MinuteInterval:30];
    [self setTextFieldInputViewForTextField:_txtEndTime DatePickerMode:UIDatePickerModeTime Selector:@selector(updateTimeTextField:) MinuteInterval:0];
}


- (void) setTextFieldInputViewForTextField : (TextFieldValidator *) textField
                            DatePickerMode : (UIDatePickerMode) datePickerMode
                                  Selector : (SEL) selector
                            MinuteInterval : (int) minuteInterval
{
    UIDatePicker *datePicker = [UIDatePicker new];
    datePicker.datePickerMode = datePickerMode;
    [datePicker addTarget:self action:selector forControlEvents:UIControlEventValueChanged];
    
    if (minuteInterval != 0)
    {
        [datePicker setMinuteInterval:minuteInterval];
    }
    
    [textField setInputView:datePicker];
    
}

- (void) setDelegates
{
    _txtStartTime.delegate = self;
    _txtEndTime.delegate = self;
    _txtAddress.delegate = self;
    _txtPostRange.delegate = self;
    _txtEndDate.delegate = self;
    _txtStartDate.delegate = self;
    _txtCategory.delegate = self;
    _txtTitle.delegate = self;
    _txtCost.delegate = self;
    _txtWebsite.delegate = self;
}

- (void) setCostToFree
{
    _txtCost.text = @"FREE";
    costText = @"";
    [self hideKeyboard];
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

    if (!isEditMode)
    {
        // If the current field is the start time, then automatically set the end time to three hours from now
        if ([activeField isEqual:_txtStartTime])
        {
            if ([_txtStartDate.text isEqualToString:_txtEndDate.text])
            {
                /* Set the earliest end date to the start time */
                NSTimeInterval threeHours = (3 * 60 * 60) - 1;
                NSDate *endTime = [sender.date dateByAddingTimeInterval:threeHours];
                NSDate *startTime = sender.date;
                // Check to make sure that three hours from now does not go into the next day, and if it does, then we display that on the end date
                [self checkForLaterEndDate:sender.date EndTime:endTime StartTime:startTime];
                _txtEndTime.text = [dateFormat stringFromDate:endTime];
                UIDatePicker *datePicker = (UIDatePicker *) _txtEndTime.inputView;
                [datePicker setMinimumDate:sender.date];
                [_txtEndTime setInputView:datePicker];
                _txtEndTime.enabled = YES;
            }
            
        }
        // If the user is changing the start time than now enable the user to change the end time
        else if ([activeField isEqual:_txtEndTime])
        {
            [dateFormat setDateFormat:@"mm/dd/yy"];
        
        }
        NSLog(@"%@", [dateFormat stringFromDate:sender.date]);
    }
}


-(void) checkForLaterEndDate : (NSDate *) date
                     EndTime : (NSDate *) endTime
                   StartTime : (NSDate *) startTime
{

    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *endTimeComponents = [calendar components:NSUIntegerMax fromDate:endTime];
    NSDateComponents *startTimeComponents = [calendar components:NSUIntegerMax fromDate:startTime];
    
    if ([startTimeComponents day] < [endTimeComponents day])
    {
        [self updateEndDate];
    }
    
}

- (void) updateEndDate {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateFormatter *df = [NSDateFormatter new];
    [df setDateFormat:@"mm/dd/yy"];
    NSDate *endDate = [df dateFromString:_txtEndDate.text];
    NSDateComponents *endDateComponents = [calendar components:NSUIntegerMax fromDate:endDate];
    [endDateComponents setDay:[endDateComponents day] + 1];
    endDate = [endDateComponents date];
    _txtEndDate.text = [df stringFromDate:endDate];
}
/*
 
 Check to see if the given date is today's date
 
 */
- (BOOL) dateIsToday : (NSDate *) date {
    
    NSDate *today = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *todayComponents = [calendar components:NSUIntegerMax fromDate:today];
    NSDateComponents *dateComponents = [calendar components:NSUIntegerMax fromDate:date];
    
    // Check to see if the dates are the same, if they are, that means that the date given is today's date
    if ([todayComponents month] == [dateComponents month] &&
        [todayComponents day] == [dateComponents day] &&
        [todayComponents year] == [dateComponents year])
    {
        return YES;
    }
    
    return NO;
}

- (void) updateDateTextField : (UIDatePicker *) sender {
    // Check to see if the current selected date is today's date
    
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
        [self setMaximumDateForEndDate];
    }
    
    if (!isEditMode)
    {
        NSLog(@"%@", [dateFormat stringFromDate:sender.date]);
        
        /* Check to see if the date selected is today's date, and if so don't
        allow the user to select a date a time that is earlier than right now */
        
        // Validation Group
        {
            if ([self dateIsToday:sender.date])  // 1 Check to see if the date of whatever textfield is today's date
            {
                UIDatePicker *startTimeDatePicker = (UIDatePicker *) [_txtStartTime inputView];
                if ([activeField isEqual:_txtStartDate]) // YES -   1A.  Check to see if the selected textfield is the start date
                {
                    [self setMinimumDateForTimePicker : _txtStartTime];  // YES -   a.  Set the minimum time that can be selected for the start time to the current time

                    if ([self dateIsToday:((UIDatePicker *) [_txtEndTime inputView]).date] )// b.  Check to see if the end date is also set to today
                    {
                        [((UIDatePicker *) [_txtEndTime inputView]) setMinimumDate:startTimeDatePicker.date];  // YES -   aa. - Set the minimum date for the end time to whatever the start time is
                    }
                }
                else if ([activeField isEqual:_txtEndDate])  // NO -    c.  The selected textfield is the end date, therefore we set the earliest time that can be selected to the start time
                {
                    NSDate *startTime = ((UIDatePicker *) _txtStartTime.inputView).date;
                    NSDate *endTime = ((UIDatePicker *) _txtEndTime.inputView).date;
                    
                    // If the start time is less than the end time
                    if ([startTime compare:endTime] == NSOrderedDescending)  // Check to see if the start time is greater than the end time, and if so then we set the end time to the start time
                    {
                        _txtEndTime.text = _txtStartTime.text;
                    }
                    
                    [((UIDatePicker *) [_txtEndTime inputView]) setMinimumDate:startTimeDatePicker.date];
                }
            }
            else {
                if ([activeField isEqual:_txtStartDate])  // aaa If the user has selected the start date
                {
                    [((UIDatePicker *) _txtStartTime.inputView) setMinimumDate:nil];
                }
                else if ([activeField isEqual:_txtEndDate])  // bbb If the user has selected the end date
                {
                    [((UIDatePicker *) _txtEndTime.inputView) setMinimumDate:nil];
                }
            }
        }
        /*If this is the end date that is being selected then we want to ensure that
         the earliest date for the user to select as an end date is the day of the event*/
        if ([activeField isEqual:_txtEndDate])
        {
            // If this is the end date then set the earliest date to start date
            [self setMinimumDateForDatePicker:sender.date];
            NSDateFormatter *df = [NSDateFormatter new];
            [df setDateFormat:@"mm/dd/yy"];
            NSDate *minDate = [df dateFromString:_txtStartDate.text];
            [((UIDatePicker *) _txtEndDate.inputView) setMinimumDate:minDate];
        }
        _txtStartTime.enabled = YES;
    }
}

/*
 
 Set the maximum date for the end date to three days later ensuring that we don't have events that last for months or weeks.
 
 */
- (void) setMaximumDateForEndDate {
    UIDatePicker *datePicker = (UIDatePicker *) _txtStartDate.inputView;
    NSDate *date = [datePicker date];
    date = [date dateByAddingTimeInterval:(60 * 60 * 24 * 3)];
    
    datePicker = (UIDatePicker *) _txtEndDate.inputView;
    [datePicker setMaximumDate:date];
}

/*
 
 Set the minimum date for the end date date selector
 
 */
- (void) setMinimumDateForDatePicker : (NSDate *) date {
    // Get the current date, and set the earliest date to the date selected
    UIDatePicker *datePicker = (UIDatePicker *) _txtEndDate.inputView;
    [datePicker setMinimumDate:date];
    [_txtEndDate setInputView:datePicker];
}

/*
 
 Set the minimum date that the user can select from the picker picker
 
 */

- (void) setMinimumDateForTimePicker : (UITextField *) textField {
    UIDatePicker *datePicker = (UIDatePicker *) textField.inputView;
    NSDate *now = [NSDate new];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier: NSGregorianCalendar];
    NSDateComponents *components = [gregorian components: NSUIntegerMax fromDate: now];
    
    if ([components minute] > 30)
    {
        [components setMinute:0];
        [components setHour:[components hour] + 1];
    }
    else {
        [components setMinute:30];
    }
    
    NSDate *nowTime = [gregorian dateFromComponents:components];
    datePicker.minimumDate = nowTime;
    textField.inputView = datePicker;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [activeField resignFirstResponder];
}

- (void) textFieldDidChange : (id) sender
{

}

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
 
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    int maxLength;
    
    if ([textField isEqual:_txtTitle])
    {
        maxLength = 25;
    }
    else {
        maxLength = 40;
    }
    
    if (newLength > maxLength)
    {
        return NO;
    }
    
    
    return YES;
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
        DEViewChangeCity *viewPostAddress = [[DEViewChangeCity alloc] initWithFrame:self.frame];
        [DEAnimationManager fadeOutWithView:self ViewToAdd:viewPostAddress];
        [viewPostAddress setUpViewWithType:PLACES_API_DATA_RESULT_TYPE_GEOCODE];

        [activeField resignFirstResponder];
        [viewPostAddress.searchBar becomeFirstResponder];
    }
    
    if ([textField isEqual:_txtEndDate])
    {
        [[_txtEndDate layer] setBorderWidth:0.0f];
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
        // Get from the full address name the exact location of the event
        [DELocationManager getLatLongValueFromAddress:fullAddress CompletionBlock:^(PFGeoPoint *value) {
            [[DEPostManager sharedManager] currentPost].location = value;
        }];
        
        _txtAddress.text = fullAddress;
        [_txtAddress validate];
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

    [DELocationManager getAddressFromLatLongValue:[locationManager currentLocation] CompletionBlock:^(NSString *value) {
        _txtAddress.text = value;
    }];
}

- (IBAction)displayInfo:(UIButton *) button {
    
    if (!_infoView.hidden)
    {
        [self animateHideInfoView : button];
    }
    else
    {
        [self animateDisplayInfoView : button];
    }
}

/*
 
 Display to the user what the purpose of post range field is when the question mark button is pressed.
 
 The animation starts as a point above the question mark, then expands outwards, and then expands downwards
 
 */
- (void) animateDisplayInfoView : (UIButton *) button
{
    [_infoView setFrame:CGRectMake(0, 0, 2, 2)];
    CGPoint center = button.center;
    center.y -= DISPLAY_INFO_VIEW_HEIGHT + 50;
    [_infoView setCenter:center];
    _infoView.hidden = NO;
    
    [UIView animateWithDuration:.2 animations:^{
        CGRect frame = _infoView.frame;
        CGPoint center = button.center;
        center.y -= DISPLAY_INFO_VIEW_HEIGHT + 50;
        frame.size.width = DISPLAY_INFO_VIEW_WIDTH;
        [_infoView setFrame:frame];
        [_infoView setCenter:center];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.2 animations:^{
            CGRect frame = _infoView.frame;
            frame.size.height = DISPLAY_INFO_VIEW_HEIGHT;
            [_infoView setFrame:frame];
        }];
    }];
}

/*
 
 Hide the screen that displays to the user the purpose of the post range field when they press the question mark button
 The animation starts as a full box, then retracts upwards, and then inwards.
 
 */
- (void) animateHideInfoView : (UIButton *) button
{
    [UIView animateWithDuration:.2 animations:^{
        CGRect frame = _infoView.frame;
        frame.size.height = 2;
        [_infoView setFrame:frame];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.2 animations:^{
            CGRect frame = _infoView.frame;
            frame.size.width = 2;
            CGPoint point = _infoView.center;
            point.x = button.center.x;
            [_infoView setFrame:frame];
            [_infoView setCenter:point];
        } completion:^(BOOL finished) {
            [_infoView setHidden:YES];
        }];
    }];
}

@end
