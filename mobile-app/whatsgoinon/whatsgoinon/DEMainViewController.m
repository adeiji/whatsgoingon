//
//  DEMainViewController.m
//  whatsgoinon
//
//  Created by adeiji on 8/5/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import "DEMainViewController.h"
#import "DECreatePostViewController.h"

@interface DEMainViewController ()

@end

@implementation DEMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)viewWhatsGoingOnNow:(id)sender {
    // Do any additional setup after loading the view.
    UIStoryboard *viewPosts = [UIStoryboard storyboardWithName:@"ViewPosts" bundle:nil];
    DEViewEventsViewController *viewEventsViewController = [viewPosts instantiateInitialViewController];
    
    [self.navigationController pushViewController:viewEventsViewController animated:YES];
}

- (IBAction)showCreatePostView:(id)sender {
    UIStoryboard *createPost = [UIStoryboard storyboardWithName:@"Posting" bundle:nil];
    DECreatePostViewController *createPostViewController = [createPost instantiateInitialViewController];
    
    [self.navigationController pushViewController:createPostViewController animated:YES];
}
@end
