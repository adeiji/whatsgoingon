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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAmbassador:) name:NOTIFICATION_CENTER_USER_RETRIEVED object:nil];
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
    
    // Display the Event Details View and then set up the Username Button click action
    [self showEventDetails:nil];
    [self setUsernameButtonClickAction];
    
    // Make this an asynchronous call
    [_eventView performSelectorInBackground:@selector(loadMapViewWithLocation:) withObject:_post.location];
    
    if (_isGoing)
    {
        [self updateViewToGoing];
    }
    if (_isMaybeGoing)
    {
        self.maybeCheckmarkView.hidden = NO;
    }
    
    userIsAmbassador = NO;
    [DEUserManager getUserFromUsername:_post.username];

}


- (void) setUsernameButtonClickAction {
    DEEventDetailsView *detailsView = [[[_eventView detailsView] subviews] lastObject];

    [detailsView.btnUsername addTarget:self action:@selector(usernameButtonClicked) forControlEvents:UIControlEventTouchUpInside];
}

// Take the user to a profile page where they can see limited information about this user

- (void) usernameButtonClicked {
    DESettingsAccount *settingsAccount = [[DESettingsAccount alloc] initWithUser:user IsPublic:YES];
    
    UIScrollView *scrollView = [[[NSBundle mainBundle] loadNibNamed:@"ViewSettingsAccount" owner:self options:nil] lastObject];
    [scrollView setContentSize:settingsAccount.frame.size];
    [scrollView addSubview:settingsAccount];
    [DEAnimationManager fadeOutWithView:self.view ViewToAdd:scrollView];
    [settingsAccount setIsPublic:YES];
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
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
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
    ((UIScrollView *) view).contentSize = newView.frame.size;
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

- (void) showAmbassador : (NSNotification *) notification {
    PFObject *object = [notification.userInfo objectForKey:NOTIFICATION_CENTER_USER_RETRIEVED];
    user = (PFUser *) object;
    if ([object[PARSE_CLASS_USER_RANK] isEqualToString:USER_RANK_AMBASSADOR])
    {
        userIsAmbassador = YES;
    }
    else {
        userIsAmbassador = NO;
    }
    
    UIView *topView = [[[_eventView detailsView] subviews] firstObject];
    if ([topView isKindOfClass:[DEEventDetailsView class]])
    {        
        PFFile *imageFile = object[PARSE_CLASS_USER_PROFILE_PICTURE];
        
        [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            
            @autoreleasepool {
                NSData *imageData = data;
                UIImage *image = [UIImage imageWithData:imageData];
                ((DEEventDetailsView *) topView).profileImageView.image = image;
                
                image = nil;
            }
        }];
    }
    
    [[((DEEventDetailsView *) topView).profileImageView layer] setCornerRadius:((DEEventDetailsView *) topView).profileImageView.frame.size.height / 2.0];
}



#pragma mark - Button Action Methods

- (IBAction)showEventDetails:(id)sender
{
    [self showView:[_eventDetailsViewController viewInfo]];
    
    DEEventDetailsView *detailsView = [[[_eventView detailsView] subviews] lastObject];
    
    [detailsView.btnUsername setTitle:_post.username forState:UIControlStateNormal];
    
    if (userIsAmbassador)
    {
        detailsView.ambassadorFlagView.hidden = NO;
    }
    else {
        detailsView.ambassadorFlagView.hidden = YES;
    }
    
    [[detailsView txtDescription] setText:_post.myDescription];
    // Set the height of the UITextView for the description to the necessary height to fit all the information
    CGSize sizeThatFitsTextView = [[detailsView txtDescription] sizeThatFits:CGSizeMake([detailsView txtDescription].frame.size.width, 1000)];
    CGFloat heightDifference =  ceilf(sizeThatFitsTextView.height) - [detailsView heightConstraint].constant;
    [detailsView heightConstraint].constant = ceilf(sizeThatFitsTextView.height);
    
    CGRect frame = detailsView.frame;
    frame.size.height += heightDifference;
    [detailsView setFrame:frame];
    [[_eventView detailsView] setContentSize:detailsView.frame.size];
    
    [[detailsView lblCost] setText:[NSString stringWithFormat:@"$%@", [_post.cost stringValue]]];
    [[detailsView lblNumberGoing] setText:[NSString stringWithFormat:@"%@", _post.numberGoing]];
    [detailsView layoutIfNeeded];
    
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
    
    // If the user has not already selected this post as going then we set this post as going for the user and save that to the server.
    if ( ![[postManager goingPost] containsObject:_post] )
    {
        int numGoing = [_post.numberGoing intValue];
        numGoing ++;
        _post.numberGoing = [NSNumber numberWithInt:numGoing];
        NSDictionary *dictionary = @{ PARSE_CLASS_EVENT_NUMBER_GOING: _post.numberGoing };
        [[postManager goingPost] addObject:_post.objectId];
        [DESyncManager updateObjectWithId:_post.objectId UpdateValues:dictionary ParseClassName:PARSE_CLASS_NAME_EVENT];
        [[_viewEventView lblNumGoing] setText:[NSString stringWithFormat:@"%@", [_post numberGoing]]];
        [DEAnimationManager savedAnimationWithImage:@"going-indicator-icon.png"];
        
        going = YES;
        // Save this item as going for the user to the server
        [[DEUserManager sharedManager] saveItemToArray:_post.objectId ParseColumnName:PARSE_CLASS_USER_EVENTS_GOING];
        
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

- (IBAction)setEventAsMaybeGoing:(id)sender {
    DEPostManager *postManager = [DEPostManager new];
    [[postManager maybeGoingPost] addObject:_post.objectId];
    // Save this item as maybe going for the user to the server
    [[DEUserManager sharedManager] saveItemToArray:_post.objectId ParseColumnName:PARSE_CLASS_USER_EVENTS_MAYBE];
    self.maybeCheckmarkView.hidden = NO;
    [DEAnimationManager savedAnimationWithImage:@"maybe-indicator-icon.png"];
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




@end
