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
    [[_createPostViewTwo txtDescription] setDelegate:self];

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

- (IBAction)displayCurrentLocation:(id)sender {
    
    DELocationManager *locationManager = [DELocationManager sharedManager];
    [DELocationManager getAddressFromLatLongValue:[locationManager geoPoint] CompletionBlock:^(NSString *value) {
        _createPostViewOne.txtAddress.text = value;
    }];
    
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
    }
    else {
        // Production
        _post.cost = [NSNumber numberWithDouble:[_createPostViewTwo.txtCost.text doubleValue]];
        _post.description = _createPostViewTwo.txtDescription.text;
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
    [dateFormatter setDateFormat:@"EEEE MMMM d, YYYY HH:mm a"];
    
    NSDate *startDate = [dateFormatter dateFromString: [NSString stringWithFormat:@"%@ %@", _createPostViewOne.txtStartDate.text, _createPostViewOne.txtStartTime.text]];

    NSDate *endDate = [dateFormatter dateFromString: [NSString stringWithFormat:@"%@ %@", _createPostViewOne.txtEndDate.text, _createPostViewOne.txtEndTime.text]];
    
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
                                                Description:nil];
    
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Posting" bundle:nil];
    DECreatePostViewController *createPostViewController = [sb instantiateViewControllerWithIdentifier:@"CreatePostDetailTwo"];
    
    [self.navigationController pushViewController:createPostViewController animated:YES];
    // Pass the new view controller the new post that was just created.
    createPostViewController.post = newPost;
    newPost = nil;
    postManager = nil;
}

- (IBAction)takePicture:(id)sender {
    
    if (imageCounter < 4)
    {
        // Let the user take a picture and store it
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:picker animated:YES completion:NULL];
    }
    else {
        // let the user know that he's taken too many pictures
    }
}


#pragma mark - ImagePickerControllerDelegate Methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {

    //Get the original image
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    //Shrink the size of the image.
    UIGraphicsBeginImageContext( CGSizeMake(70, 56) );
    [image drawInRect:CGRectMake(0,0,70,56)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageView  *imageView = [self.createPostViewTwo.imageViews objectAtIndex:imageCounter];

    imageView.image = newImage;
    //Increment the imageCounter so that we display on the next image
    imageCounter ++;
    
    [_images addObject:UIImageJPEGRepresentation(image, .1)];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

#pragma mark - Text View Delegate Methods

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    DEAddValueViewController *addValueViewController = [DEAddValueViewController new];
    addValueViewController.inputView = textView;

    [self.navigationController pushViewController:addValueViewController animated:YES];
#warning Do not leave with this String, this is hard coded, instead we want to put a placeholder here instead of actual text
    if (![textView.text isEqualToString:@"Enter a description"])
    {
        DEAddValueView *view = (DEAddValueView *) addValueViewController.view;
        view.txtValue.text = textView.text;
    }
    
    return YES;
}

@end
