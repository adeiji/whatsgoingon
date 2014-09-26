//
//  DECreatePostViewController.m
//  whatsgoinon
//
//  Created by adeiji on 8/5/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import "DECreatePostViewController.h"
#import "DEPostManager.h"
#import "DESyncManager.h"
#import "Constants.h"

@interface DECreatePostViewController ()

@end

@implementation DECreatePostViewController

static BOOL DEVELOPMENT = YES;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    DEPostManager *postManager = [DEPostManager sharedManager];
    _post = [postManager currentPost];
    
    [[_createPostViewTwo txtDescription] setDelegate:self];
    [[_createPostViewTwo txtQuickDescription] setDelegate:self];
    
    [_createPostViewTwo setupView];
    [_createPostViewOne setupView];

    UIPickerView *postRangePickerView = [UIPickerView new];
    [postRangePickerView setDelegate:self];
    [postRangePickerView setDataSource:self];
    [_createPostViewOne.txtPostRange setInputView:postRangePickerView];
    
    postRanges = @[@"1 mile radius", @"5 mile radius", @"10 mile radius", @"15 mile radius"];
    
    [_createPostViewOne displayCurrentLocation];
    _createPostViewOne.txtCategory.text = [[[DEPostManager sharedManager] currentPost] category];
    
    [[self.navigationController navigationBar] setHidden:YES];
    
    [self setUpViews];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [self.view setHidden:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:_createPostViewOne];
    [[NSNotificationCenter defaultCenter] removeObserver:_createPostViewTwo];
    
    [super viewWillDisappear:animated];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.view setHidden:NO];
    
    [self loadPostDetails];
}

- (void) setUpViews {
    [DEScreenManager setUpTextFields:self.textFields];

    [self.btnNext.layer setCornerRadius:BUTTON_CORNER_RADIUS];
    [self.btnHome.layer setCornerRadius:BUTTON_CORNER_RADIUS];
}

- (void) selectPostRange {
    _createPostViewOne.txtPostRange.text = postRange;
}

- (void) setImageCounterToZero {
    imageCounter = 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[UITextField class]])
        {
            [view resignFirstResponder];
        }
    }
}

// Here we set the rest of the values for the post
// ** Development
// We're going to push directly to the Parse server

// ** Production
// We display the post to allow the user to view the post before he actually makes it live
- (IBAction)displayPreview:(id)sender {
    
    DEEventViewController *eventViewController = [[UIStoryboard storyboardWithName:@"Event" bundle:nil] instantiateViewControllerWithIdentifier:@"viewEvent"];
    
    eventViewController.isPreview = YES;
    eventViewController.post = _post;
    [[DEPostManager sharedManager] setCurrentPost:_post];
    [self.navigationController pushViewController:eventViewController animated:YES];
}

- (void) saveNewInfoToPost {
    DECreatePostView *view = self.createPostViewTwo;
    DELocationManager *sharedManager = [DELocationManager sharedManager];
    
    if (DEVELOPMENT)
    {
        // Development
        _post.title = view.txtTitle.text;
        _post.cost = [NSNumber numberWithDouble:[view.txtCost.text doubleValue]];
        _post.images = [[[DEPostManager sharedManager] currentPost] images];
        _post.description = view.txtDescription.text;
        _post.active = YES;
        _post.location = sharedManager.storedLocation;
        _post.quickDescription = view.txtQuickDescription.text;
        _post.images = [[[DEPostManager sharedManager] currentPost] images];
        
        [[DEPostManager sharedManager] setCurrentPost:_post];
    }
    else {
        // Production
        _post.cost = [NSNumber numberWithDouble:[_createPostViewTwo.txtCost.text doubleValue]];
        _post.description =
        _post.title = view.txtTitle.text;
        _post.images = [[[DEPostManager sharedManager] currentPost] images];
    }
}


- (IBAction)displayInfo:(id)sender {
    
}


- (IBAction)gotoNextScreen:(id)sender {
    DEPostManager *postManager = [DEPostManager sharedManager];
    DELocationManager *locationManager = [DELocationManager sharedManager];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/d/yy h:mm a"];
    
    NSString *startDateString = [NSString stringWithFormat:@"%@ %@", _createPostViewOne.txtStartDate.text, _createPostViewOne.txtStartTime.text];
    NSDate *startDate = [dateFormatter dateFromString: startDateString];

    NSString *endDateString = [NSString stringWithFormat:@"%@ %@", _createPostViewOne.txtEndDate.text, _createPostViewOne.txtEndTime.text];
    NSDate *endDate;
    
    if ([[_createPostViewOne.txtEndTime.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""])
    {
        NSTimeInterval threeHours = (3 * 60 * 60) - 1;
        endDate = [startDate dateByAddingTimeInterval:threeHours];
    }
    else
    {
        endDate = [dateFormatter dateFromString: endDateString];
    }
    
    NSLog(@"Captured Date %@", [startDate description]);
    
    [DELocationManager getLatLongValueFromAddress:_createPostViewOne.txtAddress.text CompletionBlock:^(PFGeoPoint *value) {
        DELocationManager *sharedManager = [DELocationManager sharedManager];
        sharedManager.storedLocation = value;
    }];
    
    _post.startTime = startDate;
    _post.endTime = endDate;
    _post.location = [locationManager geoPoint];
    _post.postRange = [NSNumber numberWithInt:[_createPostViewOne.txtPostRange.text intValue]];
    _post.address = _createPostViewOne.txtAddress.text;
    _post.category = _createPostViewOne.txtCategory.text;

    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Posting" bundle:nil];
    DECreatePostViewController *createPostViewController = [sb instantiateViewControllerWithIdentifier:@"CreatePostDetailTwo"];
    // Pass the new view controller the new post that was just created.
    [self.navigationController pushViewController:createPostViewController animated:YES];
    [postManager setCurrentPost:_post];
}

- (IBAction)takePicture:(id)sender {
    
    _currentButton = (UIButton *) sender;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        if (imageCounter < 4)
        {
            
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Choose From Photo Library", @"Take a Picture",nil];
            
            [actionSheet showInView:self.view];
        }
    }
    else {
        #warning - Let the user know that they need a camera to take a photo
    }
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    if (buttonIndex == 1)
    {
        // Let the user take a picture and store it
        picker.delegate = self;
        picker.allowsEditing = NO;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self savePostDetails];
        [self presentViewController:picker animated:YES completion:NULL];
    }
    else if (buttonIndex == 0)
    {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.delegate = self;
        [self savePostDetails];
        [self presentViewController:picker animated:YES completion:NULL];
    }
    
}

- (IBAction)goHome:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - UIPIckerViewDelegate Methods

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [postRanges count];
}

#pragma mark - UIPickerViewDataSource Methods

- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [postRanges objectAtIndex:row];
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSRange range = [[postRanges objectAtIndex:row] rangeOfString:@" "];
    _createPostViewOne.txtPostRange.text = [NSString stringWithFormat:@"%@ mi", [[postRanges objectAtIndex:row] substringToIndex:range.location] ];
}


#pragma mark - ImagePickerControllerDelegate Methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {

    //Get the original image
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    //Shrink the size of the image.
    UIGraphicsBeginImageContext( CGSizeMake(70, 56) );
    [image drawInRect:CGRectMake(0,0,70,56)];
    UIGraphicsEndImageContext();

    //Increment the imageCounter so that we display on the next image
    imageCounter ++;
    [_currentButton setHighlighted:NO];
    UIButton *button = (UIButton *) [self.view viewWithTag:imageCounter];
    [button setHighlighted:YES];
    
    NSArray *storedImages = [[[DEPostManager sharedManager] currentPost] images];
    NSMutableArray *images = [NSMutableArray arrayWithArray:storedImages];
    // Set the image at the correct location so that it can be restored later to this same exact location
    images[_currentButton.tag] = UIImageJPEGRepresentation(image, .1);
    [_post setImages:images];
    [_currentButton setHighlighted:NO];

    [_currentButton setBackgroundImage:image forState:UIControlStateNormal];
    
    if (![_currentButton isEqual:_createPostViewTwo.btnTakePicture])
    {
        [[_currentButton layer] setBorderColor:[UIColor whiteColor].CGColor];
        [[_currentButton layer] setBorderWidth:1.0f];
    }
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void) savePostDetails
{
    DEPostManager *postManager = [DEPostManager sharedManager];

    DEPost *post = [[DEPostManager sharedManager] currentPost];
    post.title = _createPostViewTwo.txtTitle.text;
    post.images = _post.images;
    NSNumberFormatter * formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber * cost = [formatter numberFromString:_createPostViewTwo.txtCost.text];
    post.cost = cost;
    post.quickDescription = _createPostViewTwo.txtQuickDescription.text;
    post.description = _createPostViewTwo.txtDescription.text;
    
    [postManager setCurrentPost:post];
}

- (void) loadPostDetails
{
    DEPost *post = [[DEPostManager sharedManager] currentPost];
    _createPostViewTwo.txtTitle.text = post.title;
    
    // Reload the images if there are any images to load
    NSArray *images = (NSMutableArray *) post.images;
    
    if ([images count] != 0)
    {
        // Make sure that this is not a PFFile class which would mean that the current post is from an already existing one
        if (![images[0] isKindOfClass:[PFFile class]])
        {
            NSData *imageData = images[0];
            UIImage *image = [UIImage imageWithData:imageData];
            UIButton *button = _createPostViewTwo.btnTakePicture;
            [button setHighlighted:NO];
            [button setBackgroundImage:image forState:UIControlStateNormal];
            
            for (int i = 1; i < [images count]; i++) {
                UIButton *button = (UIButton *) [_createPostViewTwo viewWithTag:i];
                NSData *imageData = images[i];
                UIImage *image = [UIImage imageWithData:imageData];

                if (image != nil)
                {
                    [button setBackgroundImage:image forState:UIControlStateNormal];
                }
            }
        }
    }
    
    _createPostViewTwo.txtCost.text = [post.cost stringValue];
    _createPostViewTwo.txtQuickDescription.text = post.quickDescription;
    _createPostViewTwo.txtDescription.text = post.description;
}


#pragma mark - Text View Delegate Methods

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField
{
    DEAddValueViewController *addValueViewController = [DEAddValueViewController new];
    [self savePostDetails];
    // Let the Add Value View Controller knowh which text field was pressed so that the text displayed will be different
    if ([textField isEqual:_createPostViewTwo.txtQuickDescription])
    {
        [addValueViewController setIsQuickDescription:YES];
    }
    else
    {
        [addValueViewController setIsQuickDescription:NO];
    }
    
    [self.navigationController pushViewController:addValueViewController animated:YES];
#warning Do not leave with this String, this is hard coded, instead we want to put a placeholder here instead of actual text
    if (![textField.text isEqualToString:@"Enter a description"])
    {
        DEAddValueView *view = (DEAddValueView *) addValueViewController.view;
        view.txtValue.text = textField.text;
    }
    
    return YES;
}

- (IBAction)togglePostRangeHelperView:(id)sender {
    [_postRangeHelperView setHidden:!_postRangeHelperView.hidden];
}

- (IBAction)goBack:(id)sender {
    NSArray *viewControllers = self.navigationController.viewControllers;
    
    if ([viewControllers count] == 2)
    {
        UIView *view = [[[NSBundle mainBundle] loadNibNamed:@"ViewAlert" owner:self options:nil] firstObject];
        
        for (UIView *subview in [view subviews]) {
            if([subview isKindOfClass:[UIButton class]])
            {
                [[subview layer] setCornerRadius:BUTTON_CORNER_RADIUS];
            }
        }
        
        [DEAnimationManager fadeOutWithView:self.view ViewToAdd:view];
    }
    else {
        [self savePostDetails];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)continueGoingBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
    [[DEPostManager sharedManager] setCurrentPost:[DEPost new]];
}

- (IBAction)cancel:(id)sender {
    UIView *view = [[self.view subviews] lastObject];
    [DEAnimationManager fadeOutRemoveView:view FromView:self.view];
}
@end
