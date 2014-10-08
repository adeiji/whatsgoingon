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

#define GOOGLE_MAPS_APP_URL @"comgooglemaps://?saddr=&daddr=%@&center=%f,%f&zoom=10"
#define APPLE_MAPS_APP_URL @"http://maps.apple.com/?daddr=%@&saddr=%@"

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadComments:) name:NOTIFICATION_CENTER_ALL_COMMENTS_LOADED object:nil];
    
	// Do any additional setup after loading the view.
    _eventDetailsViewController = [[DEEventDetailsViewController alloc] initWithNibName:@"EventDetailsView" bundle:[NSBundle mainBundle]];
    [[[_eventView imgMainImage] layer] setCornerRadius:BUTTON_CORNER_RADIUS];
    [[[_eventView imgMainImage] layer] setBorderColor:[UIColor whiteColor].CGColor];
    [[[_eventView imgMainImage] layer] setBorderWidth:2.0f];
    [[_eventView lblTitle] setText:_post.title];

    if (_isPreview)
    {
        [self loadPreview];
    }
    else {
        [self loadNonPreview];
    }
    
    [[_eventView lblCost] setText:[[_post cost] stringValue]];
    
    [self showEventDetails:nil];
    
    // Make this an asynchronous call
    [_eventView performSelectorInBackground:@selector(loadMapViewWithLocation:) withObject:_post.location];
    
    if (_isGoing && _mapView)
    {
        [self updateViewToGoing];
    }
}

- (void) loadNonPreview
{
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
    
    // Load all the comments so that by the time the user clicks to view the comments they are already loaded.
    [DESyncManager getAllCommentsForEventId:[[DEPostManager sharedManager] currentPost].objectId];
}

- (void) loadPreview
{
    [_eventView setPost:_post];
    [[_eventView btnGoing] setEnabled:NO];
    [[_eventView btnMaybe] setEnabled:NO];
    [[_eventView lblNumberOfPeopleGoing] setText:0];
    UIImage *mainImage =  [UIImage imageWithData:[[_post images] firstObject]];
    [[_eventView imgMainImage] setImage:mainImage];
    _btnPost.hidden = NO;
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
    BOOL postSaved = [DESyncManager savePost:[[DEPostManager sharedManager] currentPost]];
    
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
    
    for (UIView *view in [[_eventView detailsView] subviews]) {
        [view removeFromSuperview];
    }
    
    UIView *view = [_eventView detailsView];
    [view addSubview:newView];
    
    if ([newView isKindOfClass:[DEViewComments class]])
    {
        ((UIScrollView *) view).scrollEnabled = NO;
    }
    else
    {
        ((UIScrollView *) view).scrollEnabled = YES;
    }
    
    return newView;
}

- (void) loadComments : (NSNotification *) notification
{
    DEViewComments *view = (DEViewComments *) [_eventDetailsViewController viewComments];
    [view setComments:notification.userInfo[@"comments"]];
    
    if ([view.comments count] > 0)
    {
        DEViewComments *viewComments = (DEViewComments *) [_eventDetailsViewController viewComments];
        [viewComments setPost:_post];
        [viewComments.tableView reloadData];
    }
    
    int thumbsUp = 0;
    int thumbsDown = 0;
    
    for (PFObject *object in view.comments) {
        if ([object[PARSE_CLASS_COMMENT_THUMBS_UP] isEqual:[NSNumber numberWithBool:YES]])
        {
            thumbsUp ++;
        }
        else
        {
            thumbsDown ++;
        }
    }
    
    [view.lblThumbsUp setText:[[NSNumber numberWithInt:thumbsUp] stringValue]];
    [view.lblThumbsDown setText:[[NSNumber numberWithInt:thumbsDown] stringValue]];
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
    DEViewComments *view = (DEViewComments *) [_eventDetailsViewController viewComments];

    if ([view.comments count] == 0)
    {
        [self showView:[_eventDetailsViewController viewNoComments]];
    }
    else
    {
        DEViewComments *viewComments = (DEViewComments *) [self showView:[_eventDetailsViewController viewComments]];
        [viewComments setPost:_post];
        [viewComments.tableView reloadData];
    }
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
        [[DEPostManager sharedManager] setCurrentPost:_post];
    }
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"viewMap"])
    {
        DEEventViewController *mapViewController = [segue destinationViewController];
        mapViewController.isGoing = _isGoing;
        mapViewController.post = _post;
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
        [DEAnimationManager savedAnimationWithImage:@"going-indicator-icon.png"];
        
        going = YES;
        
        if ([_eventView.detailsView.subviews[0] isKindOfClass:[DEEventDetailsView class]])
        {
            DEEventDetailsView *eventView = (DEEventDetailsView *) _eventView.detailsView.subviews[0];
            [[eventView lblNumberGoing] setText:[NSString stringWithFormat:@"%@", [_post numberGoing]]];
        }
    }
    
    if (!_mapView)
    {
        [self shareEvent:nil];
    }
    else {
        NSInteger indexOfViewController = self.navigationController.viewControllers.count - 2;
        DEEventViewController *viewController = [self.navigationController.viewControllers objectAtIndex:indexOfViewController];
        [viewController shareEvent:nil];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    [self updateViewToGoing];
    [[_eventView imgMainImage] setHidden:YES];
}

- (void) updateViewToGoing
{
    UIButton *button = [_eventView btnGoing];
    [button setTitle:@"Map It" forState:UIControlStateNormal];
    [button removeTarget:self action:@selector(setEventAsGoing:) forControlEvents:UIControlEventTouchUpInside];
    [button addTarget:self action:@selector(mapIt) forControlEvents:UIControlEventTouchUpInside];

    CGRect frame = button.frame;
    frame.origin.y += 40;
    [button setFrame:frame];
   // [[_eventView btnMaybe] setTitle:@"Undo" forState:UIControlStateNormal];
    [[_eventView btnMaybe] setHidden:YES];
    
    frame = _mapView.frame;
    frame.size.height += 40;
    [_mapView setFrame:frame];
    
    _isGoing = YES;
}
- (void) mapIt
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Get Directions To Event" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Use Google Maps", @"Use Apple Maps", nil];
    
    [actionSheet showInView:self.view];
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        NSString *urlString = [NSString stringWithFormat:GOOGLE_MAPS_APP_URL, [_post.address stringByReplacingOccurrencesOfString:@" " withString:@"+"], _post.location.longitude, _post.location.latitude ];
        if ([[UIApplication sharedApplication] canOpenURL:
             [NSURL URLWithString:@"comgooglemaps://"]]) {
            [[UIApplication sharedApplication] openURL:
             [NSURL URLWithString:urlString]];
        } else {
            NSLog(@"Can't use comgooglemaps://");
        }
    }
    else if (buttonIndex == 1)
    {
        [DELocationManager getAddressFromLatLongValue:[[DELocationManager sharedManager] currentLocation] CompletionBlock:^(NSString *value) {
            NSString *urlString = [NSString stringWithFormat:APPLE_MAPS_APP_URL, [_post.address stringByReplacingOccurrencesOfString:@" " withString:@"+"], [value stringByReplacingOccurrencesOfString:@" " withString:@"+"] ];

            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        }];
    }
}

- (IBAction)setEventAsMaybeGoing:(id)sender {
    DEPostManager *postManager = [DEPostManager new];
    [[postManager maybeGoingPost] addObject:_post];
    
    [DEAnimationManager savedAnimationWithImage:@"maybe-indicator-icon.png"];
}


@end
