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
}

// Here we set the rest of the values for the post
// ** Development
// We're going to push directly to the Parse server

// ** Production
// We display the post to allow the user to view the post before he actually makes it live
- (IBAction)displayPreview:(id)sender {
    // Development
    _post.title = @"Chicken Scratch";
    _post.cost = @14.0;
    _post.images = nil;
    _post.description = @"This is just a test of the iOS version";
    // Production
//    _post.cost = [NSNumber numberWithDouble:[_createPostViewTwo.txtCost.text doubleValue]];
//
//    _post.description = _createPostViewTwo.txtDescription.text;
    
    //For now we call SyncManager but we may let PostManager handle this, we'll have to decide later
    [DESyncManager savePost:_post];
}

- (IBAction)displayInfo:(id)sender {
}

- (IBAction)gotoNextScreen:(id)sender {
    DEPostManager *postManager = [DEPostManager sharedManager];
    
    DEPost *newPost = [DEPostManager createPostWithCategory:_createPostViewOne.txtCategory.text
                                                  StartTime:[NSDate date]
                                                    EndTime:[NSDate date]
                                                   Latitude:[NSNumber numberWithDouble:3.88979878973]
                                                  Longitude:[NSNumber numberWithDouble:9.4884883849]
                                                  PostRange:[NSNumber numberWithInt:5]
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
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
}

@end
