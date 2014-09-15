//
//  DEEventViewController.m
//  whatsgoinon
//
//  Created by adeiji on 8/11/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import "DEEventViewController.h"
#import "Constants.h"

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
        [_eventView setPost:_post];
        [[_eventView btnGoing] setEnabled:NO];
        [[_eventView btnMaybe] setEnabled:NO];
        [[_eventView lblNumberOfPeopleGoing] setText:0];
        UIImage *mainImage =  [UIImage imageWithData:[[_post images] firstObject]];
        [[_eventView imgMainImage] setImage:mainImage];
        _btnPost.hidden = NO;
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

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.view.hidden = NO;
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.view.hidden = YES;
}

- (IBAction) savePost : (id)sender {
    
    #warning - For now we call SyncManager but we may let PostManager handle this, we'll have to decide later
    BOOL postSaved = [DESyncManager savePost:_post];
    
    if (postSaved)
    {
        _post = nil;
        DECreatePostViewController *createPostViewController = [[UIStoryboard storyboardWithName:@"Posting" bundle:nil] instantiateViewControllerWithIdentifier:@"FinishedPosting"];
        [createPostViewController.navigationItem setHidesBackButton:YES];
        [self.navigationController pushViewController:createPostViewController animated:YES];
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
    [[detailsView lblCost] setText:[NSString stringWithFormat:@"$%@", [_post.cost stringValue]]];
    [[detailsView lblNumberGoing] setText:[NSString stringWithFormat:@"%@", _post.numberGoing]];
    
    if ([DEPostManager isBeforeEvent:_post])
    {
        [[detailsView lblEndsInStartsIn] setText:@"Starts In"];
    }
    else
    {
        [[detailsView lblEndsInStartsIn] setText:@"Ends In"];
    }
    
    [[detailsView lblTimeUntilStartsOrEnds] setText:[DEPostManager getTimeUntilStartOrFinishFromPost:_post]];
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
    [eventDetailsMoreView loadView];
    if (!_isPreview) {
        [[eventDetailsMoreView btnMiscategorized] setEnabled:YES];
        [[eventDetailsMoreView btnPostSomethingSimilar] setEnabled:YES];
        [[eventDetailsMoreView btnReportEvent] setEnabled:YES];
        [eventDetailsMoreView setEventId:[_post objectId]];
        [eventDetailsMoreView setCategory:[_post category]];
    }
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue destinationViewController] isKindOfClass:[DEMapViewController class]])
    {
        DEMapViewController *mapViewController = [segue destinationViewController];
        [mapViewController setLocation:[_post location]];
    }
}

- (IBAction)setEventAsGoing:(id)sender {
    
    static BOOL going = NO;
    DEPostManager *postManager = [DEPostManager sharedManager];
    
    if ( ![[postManager goingPost] containsObject:_post] )
    {
        int numGoing = [_post.numberGoing intValue];
        numGoing ++;
        _post.numberGoing = [NSNumber numberWithInt:numGoing];
        NSDictionary *dictionary = @{ PARSE_CLASS_EVENT_NUMBER_GOING: _post.numberGoing };
        [[postManager goingPost] addObject:_post];
        [DESyncManager updateObjectWithId:_post.objectId UpdateValues:dictionary ParseClassName:PARSE_CLASS_NAME_EVENT];
        [[_viewEventView lblNumGoing] setText:[NSString stringWithFormat:@"%@", [_post numberGoing]]];
        [DEAnimationManager savedAnimationWithView];
        
        going = YES;
        
        
        DEEventDetailsView *eventView = (DEEventDetailsView *) _eventView.detailsView.subviews[0];
        [[eventView lblNumberGoing] setText:[NSString stringWithFormat:@"%@", [_post numberGoing]]];
    }
    
}
- (IBAction)setEventAsMaybeGoing:(id)sender {
    DEPostManager *postManager = [DEPostManager new];
    [[postManager maybeGoingPost] addObject:_post];
}


@end
