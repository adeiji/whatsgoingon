//
//  DEEventViewController.m
//  whatsgoinon
//
//  Created by adeiji on 8/11/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import "DEEventViewController.h"

@interface DEEventViewController ()

@end

@implementation DEEventViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _eventDetailsViewController = [[DEEventDetailsViewController alloc] initWithNibName:@"EventDetailsView" bundle:[NSBundle mainBundle]];
    
    if (_isPreview)
    {
        [[_eventView btnGoing] setEnabled:NO];
        [[_eventView btnMaybe] setEnabled:NO];
        [[_eventView lblNumberOfPeopleGoing] setText:0];
        UIImage *mainImage =  [UIImage imageWithData:[[_post images] firstObject]];
        [[_eventView imgMainImage] setImage:mainImage];
        UIBarButtonItem *postButton = [[UIBarButtonItem alloc]
                                       initWithTitle:@"Post!"
                                       style:UIBarButtonItemStyleBordered
                                       target:self
                                       action:@selector(savePost)];
        self.navigationItem.rightBarButtonItem = postButton;
    }
    else {
        PFFile *file = [[_post images] firstObject];
        [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error)
            {
                UIImage *mainImage = [UIImage imageWithData:data];
                [[_eventView imgMainImage] setImage:mainImage];
            }
        } progressBlock:^(int percentDone) {
            //Display to the user how much has been loaded
        }];
    }
    
    [[_eventView lblCost] setText:[[_post cost] stringValue]];
    
    [self showEventDetails:nil];
    
    // Make this an asynchronous call
    [_eventView performSelectorInBackground:@selector(loadMapViewWithLocation:) withObject:_post.location];
    
}

- (void) viewDidDisappear:(BOOL)animated {
    if (!_isPreview)
    {
        DEScreenManager *sharedManager = [DEScreenManager sharedManager];
        UIButton *button = [[sharedManager values] objectForKey:@"viewCategoriesButton"];
        button.hidden = false;
    }
}

- (void) savePost {
    
    //For now we call SyncManager but we may let PostManager handle this, we'll have to decide later
    BOOL postSaved = [DESyncManager savePost:_post];
    
    if (postSaved)
    {
        _post = nil;
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *) showView : (UIView *) newView {
    UIView *view = [[[_eventView detailsView] subviews] lastObject];
    [view removeFromSuperview];
    view = [_eventView detailsView];
    [view addSubview:newView];
    
    return newView;
}

#pragma mark - Button Action Methods

- (IBAction)showEventDetails:(id)sender
{
    [self showView:[_eventDetailsViewController viewInfo]];
    
    DEEventDetailsView *detailsView = [[[_eventView detailsView] subviews] lastObject];
    
    [[detailsView txtDescription] setText:_post.description];
    [[detailsView lblCost] setText:[_post.cost stringValue]];
    [[detailsView lblNumberGoing] setText:@"0"];
    [[detailsView lblTimeUntilStartsOrEnds] setText:@"3 hrs"];
}
- (IBAction)showEventComments:(id)sender
{
    [self showView:[_eventDetailsViewController viewNoComments]];
}
- (IBAction)shareEvent:(id)sender
{
    DESharingView *shareView = (DESharingView *) [self showView:[_eventDetailsViewController viewSocialNetworkShare]];
    
    if (!_isPreview)
    {
        [[shareView btnShareTwitter] setEnabled:YES];
        [[shareView btnShareFacebook] setEnabled:YES];
        [[shareView btnShareInstagram] setEnabled:YES];
        [shareView setImage:[[_eventView imgMainImage] image]];
        [shareView setPost:_post];
        [shareView getAddress];
    }
}
- (IBAction)viewMoreForEvent:(id)sender
{
    DEEventDetailsMoreView *eventDetailsMoreView = (DEEventDetailsMoreView *)[self showView:[_eventDetailsViewController viewMore]];
    
    if (!_isPreview) {
        [[eventDetailsMoreView btnMiscategorized] setEnabled:YES];
        [[eventDetailsMoreView btnPostSomethingSimilar] setEnabled:YES];
        [[eventDetailsMoreView btnReportEvent] setEnabled:YES];
    }
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue destinationViewController] isKindOfClass:[DEMapViewController class]])
    {
        DEMapViewController *mapViewController = [segue destinationViewController];
        [mapViewController setLocation:[_post location]];
    }
}

@end
