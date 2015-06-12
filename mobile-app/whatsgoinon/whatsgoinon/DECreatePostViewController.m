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
#import <objc/runtime.h>

@interface DECreatePostViewController ()

@end

@implementation DECreatePostViewController


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
    if ([_post.images count] == 0)
    {
        imagesCopy = [NSMutableArray new];
    }
    else {
        imagesCopy = [_post.images mutableCopy];
    }
    [self setUpViews];
    postRanges = @[@"ALL", @"1 mile radius", @"2 mile radius", @"3 mile radius", @"5 mile radius", @"10 mile radius", @"15 mile radius", @"20 mile radius", @"30 mile radius"];
    
    if (_createPostViewOne.switchUseCurrentLocation.on)
    {
        [_createPostViewOne displayCurrentLocation];
    }
    
    _createPostViewOne.txtCategory.text = _post.category;
    [[self.navigationController navigationBar] setHidden:YES];
    [self addObservers];
    
    [DEScreenManager setBackgroundWithImageURL:@"newyork-blur.png"];
    
    if (![[[DEUserManager sharedManager] userObject][PARSE_CLASS_USER_RANK] isEqualToString:USER_RANK_AMBASSADOR])
    {
        _createPostViewTwo.txtWebsite.hidden = YES;
    }
    
//    _createPostViewTwo.txtWebsite.text = @"";
}

/*
 
 Get the start and end date and time for the event and store those values in the respective text boxes.  Also displays the address
 
 */
- (void) setTimesAndAddressForEditMode {
    NSDateFormatter *df = [NSDateFormatter new];
    [df setDateStyle:NSDateFormatterShortStyle];
    _createPostViewOne.txtStartDate.text = [df stringFromDate:_post.startTime];
    _createPostViewOne.txtEndDate.text = [df stringFromDate:_post.endTime];
    [df setDateFormat:@"hh:mm a"];
    _createPostViewOne.txtStartTime.text = [df stringFromDate:_post.startTime];
    _createPostViewOne.txtEndTime.text = [df stringFromDate:_post.endTime];
    _createPostViewOne.txtAddress.text = _post.address;
}
/*
 
 Display from the post the descriptions the price and the saved images.
 
 */
- (void) setDescriptionsPriceAndImages {
    
    NSString *cost = [_post.cost stringValue];
    cost = [cost isEqual: @"0"] ? @"Free" : [_post.cost stringValue];
    _createPostViewTwo.txtCost.text = cost;
    _createPostViewTwo.txtDescription.text = _post.myDescription;
    _createPostViewTwo.txtQuickDescription.text = _post.quickDescription;
    _createPostViewTwo.txtTitle.text = _post.title;
    _createPostViewTwo.txtWebsite.text = _post.website;
    
    static BOOL imagesConverted = NO;
    
    [self convertPFFileArrayToImageArrayConverted:imagesConverted Images:_post.images];
    imagesConverted = YES;
}

/*
 
 Get all the actual images from the PFFiles and store them in an array for later usage
 
 */
- (void) convertPFFileArrayToImageArrayConverted : (BOOL) isConverted
                                          Images : (NSArray *) array {
    __block int counter = 0;
    imagesCopy = [NSMutableArray new];
    // If we haven't already converted these images
    if (!isConverted)
    {
        [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            PFFile *file = (PFFile *) obj;
            [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {

                UIImage *image = [UIImage imageWithData:data];
                image.tag = [NSNumber numberWithInt:counter];
                counter ++;
                [imagesCopy addObject:image];
                _post.images = imagesCopy;
            NSLog(@"happsnap.decreatepostviewcontroller.image.loaded");
            }];
        } ];
    }
    else {
        imagesCopy = [_post.images mutableCopy];
        [self loadImages];
    }
}

- (void) setButtonBackgroundImageToSavedPostImageButton : (UIImage *) image
{
    __block UIButton *button;
    [_cameraButtons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (((UIButton *) obj).tag == ((NSNumber *) image.tag).integerValue)
        {
            button = (UIButton *) obj;
            *stop = YES;
        }
    }];
    
    [button setBackgroundImage:image forState:UIControlStateNormal];
}

- (void) setEditableTextFields {
    // Check to see if this event is started or not
    if (([_post.startTime compare:[NSDate new]] == NSOrderedAscending) && ([_post.endTime compare:[NSDate new]] == NSOrderedDescending))
    {
        _createPostViewOne.txtAddress.userInteractionEnabled = NO;
        _createPostViewOne.txtCategory.userInteractionEnabled = NO;
        _createPostViewOne.txtEndDate.userInteractionEnabled = NO;
        _createPostViewOne.txtStartDate.userInteractionEnabled = NO;
        _createPostViewOne.txtStartTime.userInteractionEnabled = NO;
        _createPostViewOne.txtEndTime.userInteractionEnabled = NO;
        _createPostViewOne.txtPostRange.userInteractionEnabled = NO;
        _createPostViewTwo.txtTitle.userInteractionEnabled = NO;
        _createPostViewTwo.txtWebsite.userInteractionEnabled = NO;
        _createPostViewTwo.txtCost.userInteractionEnabled = NO;
    }
}

- (BOOL) checkForEditMode {
    if (_isEditMode)
    {
        [self setEditableTextFields];
        [self setTimesAndAddressForEditMode];
        _createPostViewOne.txtAddress.text = _post.address;
        [self setDescriptionsPriceAndImages];
        [_createPostViewOne setUpTextFieldAvailability:_isEditMode];
        
        return YES;
    }
    
    return NO;
}

- (void) addObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showOrHideWebsiteInfoTextField:) name:NOTIFICATION_CENTER_USER_RANK_RETRIEVED object:nil];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [self.view setHidden:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:_createPostViewOne];
    [[NSNotificationCenter defaultCenter] removeObserver:_createPostViewTwo];
    
    if ([self.view isEqual:_createPostViewTwo])
    {
        [self savePostDetails];
    }
    
    [super viewWillDisappear:animated];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.view setHidden:NO];
    
    [_createPostViewTwo setupView];
    [_createPostViewOne setupView];
    if (![self checkForEditMode])
    {
        [self loadPostDetails];
    }
}

- (void) setUpViews {
    
    [[_createPostViewTwo txtDescription] setDelegate:self];
    [[_createPostViewTwo txtQuickDescription] setDelegate:self];
    
    UIPickerView *postRangePickerView = [UIPickerView new];
    [postRangePickerView setDelegate:self];
    [postRangePickerView setDataSource:self];
    [_createPostViewOne.txtPostRange setInputView:postRangePickerView];
    
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

// ** Production
// We display the post to allow the user to view the post before he actually makes it live
- (IBAction)displayPreview:(id)sender {

    if ([_createPostViewTwo page2ValidateTextFields])
    {
        if ([[_post images] count] != 0)
        {
            //  Display the event preview
            DEEventViewController *eventViewController = [[UIStoryboard storyboardWithName:@"Event" bundle:nil] instantiateViewControllerWithIdentifier:@"viewEvent"];
            
            if (!_isEditMode)
            {
                eventViewController.isPreview = YES;
            }
            else {
                eventViewController.isUpdateMode = YES;
            }
            eventViewController.post = _post;
            [self savePostDetails];
            [[DEPostManager sharedManager] setCurrentPost:_post];
            [self.navigationController pushViewController:eventViewController animated:YES];
        }
        else {
            [[_createPostViewTwo.btnTakePicture layer] setBorderColor:[UIColor redColor].CGColor];
            [[_createPostViewTwo.btnTakePicture layer] setBorderWidth:5.0f];
        }
    }
}

- (IBAction)gotoNextScreen:(id)sender {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone defaultTimeZone]];
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
    
    // Check to see if the address that has been selected is an actual existing address
    [self checkAddressAvailability];
    
    _post.startTime = startDate;
    _post.endTime = endDate;
    _post.postRange = [NSNumber numberWithInt:[_createPostViewOne.txtPostRange.text intValue]];
    _post.address = _createPostViewOne.txtAddress.text;
    _post.category = _createPostViewOne.txtCategory.text;

    if ([_createPostViewOne validateTextFields])
    {
        [self displayNextScreen];
    }
}

/*

Display the second screen for the post details
 
*/
- (void) displayNextScreen {
    
    DEPostManager *postManager = [DEPostManager sharedManager];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Posting" bundle:nil];
    DECreatePostViewController *createPostViewController = [sb instantiateViewControllerWithIdentifier:@"CreatePostDetailTwo"];
    createPostViewController.isEditMode = _isEditMode;
    // Pass the new view controller the new post that was just created.
    [self.navigationController pushViewController:createPostViewController animated:YES];
    [postManager setCurrentPost:_post];
    
    // Check to see what the rank of the user is and if the user is simply standard, then we want to disable the ability to add a website to the information
    [DEUserManager getUserRank : [[PFUser currentUser] username]];
}


- (void) checkAddressAvailability
{
    if ([[DELocationManager sharedManager] placeLocation])
    {
        _post.location = [[DELocationManager sharedManager] placeLocation];
    }
    else {
        [DELocationManager getLatLongValueFromAddress:_createPostViewOne.txtAddress.text CompletionBlock:^(PFGeoPoint *value) {
            DELocationManager *sharedManager = [DELocationManager sharedManager];
            if (value)
            {
                sharedManager.storedLocation = value;
                _post.location = value;
            }
        }];
    }
}

// We get the user rank from the notification, and if the user is a standard user then we want to keep the website text field hidden.
- (void) showOrHideWebsiteInfoTextField : (NSNotification *) notification {
    if (![notification.userInfo[kNOTIFICATION_CENTER_USER_RANK_OBJECT_INFO] isEqualToString:USER_RANK_STANDARD])
    {
        _createPostViewTwo.txtWebsite.hidden = NO;
    }
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
    }
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    if (buttonIndex == 1)
    {
        // Let the user take a picture and store it
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self savePostDetails];
        [self presentViewController:picker animated:YES completion:NULL];
    }
    else if (buttonIndex == 0)
    {
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
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
    
    // If there is a space within this field meaning that the user did not select 'ALL'
    if (range.length != 0)
    {
        _createPostViewOne.txtPostRange.text = [NSString stringWithFormat:@"%@ mi", [[postRanges objectAtIndex:row] substringToIndex:range.location] ];
    }
    else {
        _createPostViewOne.txtPostRange.text = [NSString stringWithFormat:@"%@", [postRanges objectAtIndex:row] ];
    }
}

- (void) saveImage : (UIImage *) image
  PickerController : (UIImagePickerController *) picker
{
    //Shrink the size of the image.
    UIGraphicsBeginImageContext( CGSizeMake(70, 56) );
    [image drawInRect:CGRectMake(0,0,70,56)];
    UIGraphicsEndImageContext();
    NSArray *storedImages = [[[DEPostManager sharedManager] currentPost] images];
    NSMutableArray *images = [NSMutableArray arrayWithArray:storedImages];
    image.tag = [NSNumber numberWithInteger:_currentButton.tag];
    
    if ([images count] == 0)
    {
        // Set the image at the correct location so that it can be restored later to this same exact location
        [imagesCopy addObject:image];
    }
    else {
        __block BOOL foundImage = NO;
        // check to see if this a new image or the user clicked a button with an image already inside
        [images enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            UIImage *myImage = (UIImage *) obj;
            if (((NSNumber *)myImage.tag).integerValue == ((NSNumber *) image.tag).integerValue)
            {
                obj = image;
                foundImage = YES;
                // Get the object with this tag as an array, and then simply get the first and only object
                UIImage *imageToRemove = [imagesCopy filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"tag == %@", myImage.tag]][0];
                [imagesCopy removeObject:imageToRemove];
                [imagesCopy addObject:image];
            }
        }];
        
        if (!foundImage)
        {
            // Set the image at the correct location so that it can be restored later to this same exact location
            [imagesCopy addObject:image];
        }
    }
    images = imagesCopy;
    [_post setImages:images];
    [[_currentButton layer] setBorderColor:[UIColor whiteColor].CGColor];
    [[_currentButton layer] setBorderWidth:1.0f];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - ImagePickerControllerDelegate Methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {

    //Get the original image
    __block UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    if (!image)
    {
    }
    else {
        [self saveImage:image PickerController:picker];
    }
    
}

- (void) savePostDetails
{
    DEPostManager *postManager = [DEPostManager sharedManager];

    DEPost *post = [[DEPostManager sharedManager] currentPost];
    if (_createPostViewTwo)
    {
        post.title = _createPostViewTwo.txtTitle.text;
        NSNumber * cost = [NSNumber numberWithDouble:[_createPostViewTwo.txtCost.text doubleValue]];
        post.website = _createPostViewTwo.txtWebsite.text;
        post.cost = cost;
    }
    
    post.images = _post.images;
    
    [postManager setCurrentPost:post];
}


- (void) loadImages {
    
    if ([imagesCopy count] != 0)
    {
        // If not a PFFile class this means that the current post is from an already existing one

        [imagesCopy enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:[UIImage class]])
            {
                UIImage *image = (UIImage *) obj;
                __block UIButton *button;
                
                [_cameraButtons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if (((UIButton *) obj).tag == ((NSNumber *) image.tag).integerValue)
                    {
                        button = (UIButton *) obj;
                        *stop = YES;
                    }
                }];

                [button setBackgroundImage:image forState:UIControlStateNormal];
            }
            else if ([obj isKindOfClass:[PFFile class]]) {
                PFFile *file = (PFFile *) obj;
                __block UIButton *button;
                
                [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                    UIImage *image = [UIImage imageWithData:data];
                
                    [_cameraButtons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        if (((UIButton *) obj).tag == ((NSNumber *) image.tag).integerValue)
                        {
                            button = (UIButton *) obj;
                            *stop = YES;
                        }
                    }];
                    
                    [button setBackgroundImage:image forState:UIControlStateNormal];
                }];
            }
        }];
        
    }
}

- (void) loadPostDetails
{
    DEPost *post = [[DEPostManager sharedManager] currentPost];
    _createPostViewTwo.txtTitle.text = post.title;
    // Reload any images that were taken
    [self loadImages];
    
    if (![post.cost isEqual:@0] && post.cost != nil)    // If the cost is not free or has not been entered yet
    {
        _createPostViewTwo.txtCost.text = [post.cost stringValue];
    }
    else    // If the cost is free then make sure that's displayed
    {
        _createPostViewTwo.txtCost.text = @"FREE";
    }
    _createPostViewTwo.txtQuickDescription.text = post.quickDescription;
    _createPostViewTwo.txtDescription.text = post.myDescription;
    _createPostViewTwo.txtTitle.text = post.title;
    [_createPostViewTwo.txtQuickDescription validate];
    [_createPostViewTwo.txtDescription validate];
    _createPostViewTwo.txtWebsite.text = post.website;
}


#pragma mark - Text View Delegate Methods

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField
{
    DEAddValueViewController *addValueViewController = [DEAddValueViewController new];
    [self savePostDetails];

    DEAddValueView *view = (DEAddValueView *) addValueViewController.view;
    
    // Let the Add Value View Controller knowh which text field was pressed so that the text displayed will be different
    if ([textField isEqual:_createPostViewTwo.txtQuickDescription])
    {
        [addValueViewController setIsQuickDescription:YES];
        view.txtValue.text = [[DEPostManager sharedManager] currentPost].quickDescription;
    }
    else
    {
        [addValueViewController setIsQuickDescription:NO];
        view.txtValue.text = [[DEPostManager sharedManager] currentPost].myDescription;
        addValueViewController.lblMinCharacters.text = @"500";
    }
    
    [self.navigationController pushViewController:addValueViewController animated:YES];
    
    if ([textField.text isEqualToString:@""])
    {
        [addValueViewController showTutorial];
    }
    
    return YES;
}

- (IBAction)goBack:(id)sender {
    BOOL secondPage = NO;
    int counter = 0;
    
    for (UIViewController *viewController in self.navigationController.viewControllers) {
        if ([viewController isKindOfClass:[DECreatePostViewController class]])
        {
            counter ++;
        }
    }
    
    if (counter > 1)
    {
        secondPage = YES;
    }
    
    if (!secondPage)
    {
        UIView *view = [[[NSBundle mainBundle] loadNibNamed:@"ViewAlert" owner:self options:nil] firstObject];
        for (UIView *subview in [view subviews]) {
            if([subview isKindOfClass:[UIButton class]])
            {
                [[subview layer] setCornerRadius:BUTTON_CORNER_RADIUS];
            }
        }
        
        [DEAnimationManager fadeOutWithView:self.view ViewToAdd:view];
        [view setFrame:self.view.frame];
    }
    else {
        [self savePostDetails];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)continueGoingBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
    if (!_isPostSomethingSimilar)
    {
        [[DEPostManager sharedManager] setCurrentPost:[DEPost new]];
    }
}

- (IBAction)cancel:(id)sender {
    UIView *view = [[self.view subviews] lastObject];
    [DEAnimationManager fadeOutRemoveView:view FromView:self.view];
}
@end

@implementation UIImage (UIImageWithTag)

@dynamic tag;

- (void) setTag:(id) tag {
    objc_setAssociatedObject(self, @selector(tag), tag, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id) tag {
    return objc_getAssociatedObject(self, @selector(tag));
}

@end
