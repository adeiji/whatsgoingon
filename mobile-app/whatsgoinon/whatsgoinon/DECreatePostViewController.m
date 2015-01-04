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
    [self setUpViews];
    postRanges = @[@"1 mile radius", @"2 mile radius", @"3 mile radius", @"5 mile radius", @"10 mile radius", @"15 mile radius", @"20 mile radius", @"30 mile radius", @"ALL"];
    
    if (_createPostViewOne.switchUseCurrentLocation.on)
    {
        [_createPostViewOne displayCurrentLocation];
    }

    _createPostViewOne.txtCategory.text = [[[DEPostManager sharedManager] currentPost] category];
    [[self.navigationController navigationBar] setHidden:YES];
    [self addObservers];
    
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    [DEScreenManager setBackgroundWithImageURL:@"HappSnap-bg.png"];
    
    if ([[[DEUserManager sharedManager] userObject][PARSE_CLASS_USER_RANK] isEqualToString:USER_RANK_STANDARD])
    {
        _createPostViewTwo.txtWebsite.hidden = YES;
    }
    
    _createPostViewTwo.txtWebsite.text = @"";
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
    [self loadPostDetails];
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
    [[_infoView layer] setCornerRadius:BUTTON_CORNER_RADIUS];
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
        //  Display the event preview
        DEEventViewController *eventViewController = [[UIStoryboard storyboardWithName:@"Event" bundle:nil] instantiateViewControllerWithIdentifier:@"viewEvent"];
        eventViewController.isPreview = YES;
        eventViewController.post = _post;
        [self savePostDetails];
        _post.website = website;
        [[DEPostManager sharedManager] setCurrentPost:_post];
        [self.navigationController pushViewController:eventViewController animated:YES];
    }
}

- (void) saveNewInfoToPost {
    DECreatePostView *view = self.createPostViewTwo;
    
    // Development
    _post.title = view.txtTitle.text;
    _post.cost = [NSNumber numberWithDouble:[view.txtCost.text doubleValue]];
    _post.images = [[[DEPostManager sharedManager] currentPost] images];
    
    NSString *description = [NSString stringWithFormat:@"%@ /n%@", _createPostViewTwo.txtDescription.text, _createPostViewTwo.txtWebsite.text];
    _post.myDescription = description;
    
    _post.active = YES;
    _post.quickDescription = view.txtQuickDescription.text;
    _post.images = [[[DEPostManager sharedManager] currentPost] images];
    
    [[DEPostManager sharedManager] setCurrentPost:_post];

}


- (IBAction)displayInfo:(id)sender {
    
    if (!_infoView.hidden)
    {
        [self animateHideInfoView];
    }
    else
    {
        [self animateDisplayInfoView];
    }
}

- (void) animateDisplayInfoView
{
    CGRect frame = _infoView.frame;

    int height = 118;
    int width = 183;
    int xPos = 47;
    int yPos = 321;
    
    frame.origin.x  = frame.origin.x + frame.size.width;
    frame.origin.y = _btnPostRangeHelperView.center.y;
    frame.size.height = 2;
    frame.size.width = 2;
    [_infoView setFrame:frame];
    _infoView.hidden = NO;
    
    [UIView animateWithDuration:.2 animations:^{
        CGRect frame = _infoView.frame;
        frame.size.width = width;
        frame.origin.x = xPos;
        [_infoView setFrame:frame];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.2 animations:^{
            CGRect frame = _infoView.frame;
            frame.size.height = height;
            frame.origin.y = yPos;
            [_infoView setFrame:frame];
        }];
    }];
}

- (void) animateHideInfoView
{
    
    [UIView animateWithDuration:.2 animations:^{
        CGRect frame = _infoView.frame;
        frame.origin.y = _btnPostRangeHelperView.center.y;
        frame.size.height = 2;
        [_infoView setFrame:frame];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.2 animations:^{
            CGRect frame = _infoView.frame;
            frame.origin.x = frame.origin.x + (frame.size.width);
            frame.size.width = 2;
            [_infoView setFrame:frame];
        } completion:^(BOOL finished) {
            [_infoView setHidden:YES];
        }];
    }];
}


- (IBAction)gotoNextScreen:(id)sender {
    
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
    
    // Check address availability
    
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
    // Pass the new view controller the new post that was just created.
    [self.navigationController pushViewController:createPostViewController animated:YES];
    [postManager setCurrentPost:_post];
    
    // Check to see what the rank of the user is and if the user is simply standard, then we want to disable the ability to add a website to the information
    [DEUserManager getUserRank : [[PFUser currentUser] username]];
}


- (void) checkAddressAvailability
{
    [DELocationManager getLatLongValueFromAddress:_createPostViewOne.txtAddress.text CompletionBlock:^(PFGeoPoint *value) {
        DELocationManager *sharedManager = [DELocationManager sharedManager];
        if (value)
        {
            sharedManager.storedLocation = value;         
        }
    }];
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
        picker.allowsEditing = YES;
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
    
    // If there is a space within this field meaning that the user did not select 'ALL'
    if (range.length != 0)
    {
        _createPostViewOne.txtPostRange.text = [NSString stringWithFormat:@"%@ mi", [[postRanges objectAtIndex:row] substringToIndex:range.location] ];
    }
    else {
        _createPostViewOne.txtPostRange.text = [NSString stringWithFormat:@"%@", [postRanges objectAtIndex:row] ];
    }
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
    images[_currentButton.tag] = UIImageJPEGRepresentation(image, .02);
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
    NSNumber * cost = [NSNumber numberWithDouble:[_createPostViewTwo.txtCost.text doubleValue]];
    post.cost = cost;
    post.quickDescription = _createPostViewTwo.txtQuickDescription.text;
    website = _createPostViewTwo.txtWebsite.text;
    NSString *description = [NSString stringWithFormat:@"%@", _createPostViewTwo.txtDescription.text];

    post.myDescription = description;
    
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
    
    [_createPostViewTwo.txtQuickDescription validate];
    [_createPostViewTwo.txtDescription validate];
    
    _createPostViewTwo.txtWebsite.text = website;
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

    DEAddValueView *view = (DEAddValueView *) addValueViewController.view;
    view.txtValue.text = textField.text;
    
    if ([textField.text isEqualToString:@""])
    {
        [addValueViewController showTutorial];
    }
    
    return YES;
}

- (IBAction)togglePostRangeHelperView:(id)sender {
//    [_postRangeHelperView setHidden:!_postRangeHelperView.hidden];
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
