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
    
    _images = [NSMutableArray new];
    
    // Make sure that we have an array of four empty objects, this ensures that we can save the images where they need to be located
    for (int i = 0; i < 4; i++) {
        [_images addObject:[NSData new]];
    }
    
    [[_createPostViewTwo txtDescription] setDelegate:self];

    UIPickerView *postRangePickerView = [UIPickerView new];
    [postRangePickerView setDelegate:self];
    [postRangePickerView setDataSource:self];
    [_createPostViewOne.txtPostRange setInputView:postRangePickerView];
    
    postRanges = @[@"1 mile radius", @"5 mile radius", @"10 mile radius", @"15 mile radius"];
    
    [_createPostViewOne displayCurrentLocation];
    
    [[self.navigationController navigationBar] setHidden:YES];
    [self.navigationController setDelegate:self];
    
    [self setUpViews];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.view setHidden:YES];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.view setHidden:NO];
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

    [self saveNewInfoToPost];
    eventViewController.post = _post;
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
        _post.images = _images;
        _post.description = view.txtDescription.text;
        _post.active = YES;
        _post.location = sharedManager.storedLocation;
        _post.quickDescription = view.txtQuickDescription.text;
        _post.images = _images;
    }
    else {
        // Production
        _post.cost = [NSNumber numberWithDouble:[_createPostViewTwo.txtCost.text doubleValue]];
        _post.description =
        _post.title = self.createPostViewTwo.txtTitle.text;
        _post.images = _images;
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
    
    DEPost *newPost = [DEPostManager createPostWithCategory:_createPostViewOne.txtCategory.text
                                                  StartTime:startDate
                                                    EndTime:endDate
                                                   Location:[locationManager geoPoint]
                                                  PostRange:[NSNumber numberWithInt:[_createPostViewOne.txtPostRange.text intValue]]
                                                      Title:nil
                                                       Cost:nil
                                                     Images:nil
                                                Description:nil
                                                    Address:_createPostViewOne.txtAddress.text
                                           QuickDescription:nil];
    
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Posting" bundle:nil];
    DECreatePostViewController *createPostViewController = [sb instantiateViewControllerWithIdentifier:@"CreatePostDetailTwo"];
    
    [self.navigationController pushViewController:createPostViewController animated:YES];
    // Pass the new view controller the new post that was just created.
    createPostViewController.post = newPost;
    newPost = nil;
    postManager = nil;
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
        else {
        #warning - Let the user know that he's taken too many pictures
            // let the user know that he's taken too many pictures
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
        
        [self presentViewController:picker animated:YES completion:NULL];
    }
    else if (buttonIndex == 0)
    {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.delegate = self;
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
    
    // Set the image at the correct location so that it can be restored later to this same exact location
    _images[_currentButton.tag] = UIImageJPEGRepresentation(image, .1);
    [_currentButton setHighlighted:NO];
    image = [self roundImageCornersWithButton:_createPostViewTwo.btnTakePicture Image:image];
    [_currentButton setBackgroundImage:image forState:UIControlStateNormal];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void) savePostDetails
{
    DEPostManager *postManager = [DEPostManager sharedManager];

    DEPost *post = [DEPost new];
    post.title = _createPostViewTwo.txtTitle.text;
    post.images = _images;
    NSNumberFormatter * formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber * cost = [formatter numberFromString:_createPostViewTwo.txtCost.text];
    post.cost = cost;
    post.quickDescription = _createPostViewTwo.txtQuickDescription.text;
    post.description = _createPostViewTwo.txtDescription.text;
    
    [postManager setCurrentPost:post];
    
}

- (void) navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{

    if (viewController.view != _createPostViewTwo)
    {
        [self savePostDetails];
    }
    else
    {
        DEPost *post = [[DEPostManager sharedManager] currentPost];
        _createPostViewTwo.txtTitle.text = post.title;
    
        // Reload the images if there are any images to load
        _images = (NSMutableArray *) post.images;
        
        if ([_images count] != 0)
        {
            NSData *imageData = _images[0];
            UIImage *image = [UIImage imageWithData:imageData];
            UIButton *button = _createPostViewTwo.btnTakePicture;
            [button setHighlighted:NO];
            [button setBackgroundImage:[self roundImageCornersWithButton:_createPostViewTwo.btnTakePicture Image:image] forState:UIControlStateNormal];
            
            for (int i = 1; i < [_images count]; i++) {
                UIButton *button = (UIButton *) [_createPostViewTwo viewWithTag:i];
                NSData *imageData = _images[i];
                UIImage *image = [UIImage imageWithData:imageData];
                image = [self roundImageCornersWithButton:_createPostViewTwo.btnTakePicture Image:image];
                if (image != nil)
                {
                    [button setBackgroundImage:image forState:UIControlStateNormal];
                }
            }
        }
        
        _createPostViewTwo.txtCost.text = [post.cost stringValue];
        _createPostViewTwo.txtQuickDescription.text = post.quickDescription;
        _createPostViewTwo.txtDescription.text = post.description;
    }
    
    
}

- (UIImage *) roundImageCornersWithButton : (UIButton *) button
                               Image : (UIImage *) image
{
    // Begin a new image that will be the new image with the rounded corners
    // (here with the size of an UIImageView)
    UIGraphicsBeginImageContextWithOptions(button.bounds.size, NO, [UIScreen mainScreen].scale);
    
    // Add a clip before drawing anything, in the shape of an rounded rect
    [[UIBezierPath bezierPathWithRoundedRect:button.bounds
                                cornerRadius:20.0] addClip];
    // Draw your image
    [image drawInRect:button.bounds];

    // Get the image, here setting the UIImageView image
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // Lets forget about that we were drawing
    UIGraphicsEndImageContext();
    
    return newImage;
}

#pragma mark - Text View Delegate Methods

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField
{
    DEAddValueViewController *addValueViewController = [DEAddValueViewController new];
    addValueViewController.inputView = textField;

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
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)continueGoingBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)cancel:(id)sender {
    UIView *view = [[self.view subviews] lastObject];
    [DEAnimationManager fadeOutRemoveView:view FromView:self.view];
}
@end
