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
#define APPLE_MAPS_APP_URL @"http://maps.apple.com/?daddr=%@&saddr=%f,%f"
static NSString *const kEventsWithCommentInformation = @"com.happsnap.eventsWithCommentInformation";

const int heightConstraintConstant = 62;

- (void) addObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadComments:) name:NOTIFICATION_CENTER_ALL_COMMENTS_LOADED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAmbassador:) name:NOTIFICATION_CENTER_USER_RETRIEVED object:nil];
}

- (void) setUpView {
    _eventDetailsViewController = [[DEEventDetailsViewController alloc] initWithNibName:@"EventDetailsView" bundle:[NSBundle mainBundle]];
    [[[_eventView btnMainImage] layer] setCornerRadius:BUTTON_CORNER_RADIUS];
    [[[_eventView btnMainImage] layer] setBorderColor:[UIColor whiteColor].CGColor];
    [[[_eventView btnMainImage] layer] setBorderWidth:2.0f];
    [[_eventView lblTitle] setText:_post.title];
    [_lblEventTitle setText:_post.title];
    CGRect frame = [[_eventView detailsView] frame];
    frame.size.width = _eventView.frame.size.width;
    [[_eventView detailsView] setFrame:frame];
    
    BOOL loadComments = YES;
    
    if (_isPreview)
    {
        [self loadPreview];
        loadComments = NO;
    }
    else if (_isEditDeleteMode)
    {
        [self loadEditDeleteModeView];
    }
    else if (_isUpdateMode)
    {
        [self loadUpdateModeView];
    }
    else {
        [self loadNonPreview];
    }
    
    if (loadComments) {
        [DESyncManager getAllCommentsForEventId:[[DEPostManager sharedManager] currentPost].objectId];
    }
    
    [[_eventView lblCost] setText:[[_post cost] stringValue]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addObservers];
    [self addSwipeGestureRecognizer];
	// Do any additional setup after loading the view.
    [self setUpView];
    // Display the Event Details View and then set up the Username Button click action
    [self showEventDetails:nil];
    [self setUsernameButtonClickAction];
    // Make this an asynchronous call
    [_eventView performSelectorInBackground:@selector(loadMapViewWithLocation:) withObject:_post.location];
    userIsAmbassador = NO;
    [DEUserManager getUserFromUsername:_post.username];
    goingButtonBottomSpaceConstraintConstant = _goingButtonBottomSpaceConstraint.constant;
    
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    if (screenHeight < 500)
    {
        _constraintMapViewHeight.constant -= 50;
        _constraintMainImageHeight.constant -= 20;
    }

}

- (void) addSwipeGestureRecognizer {
    UISwipeGestureRecognizer *backswipeGestureRecognizer = [UISwipeGestureRecognizer new];
    [backswipeGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    [backswipeGestureRecognizer addTarget:self action:@selector(goBack:)];
    [backswipeGestureRecognizer setDelegate:self];
    [self.view addGestureRecognizer:backswipeGestureRecognizer];
}


- (void) loadUpdateModeView {
    _goingButtonBottomSpaceConstraint.constant = -40;
    _goingButtonBottomSpaceConstraintMapView.constant = -40;
    [[_eventView btnMaybe] setHidden:YES];
    [[_eventView btnGoing] setTitle:@"Update Now!" forState:UIControlStateNormal];
    [[_eventView btnGoing] removeTarget:self action:@selector(setEventAsGoing:) forControlEvents:UIControlEventTouchUpInside];
    [[_eventView btnGoing] addTarget:self action:@selector(updatePost) forControlEvents:UIControlEventTouchUpInside];
}

/*
 
 Update the current post that the user has just modified
 
 */
- (void) updatePost {
    _post.images = [self imagesToNSDataArray:_post.images Compression:.2];
    if (!_post.thumbsUpCount)
    {
        _post.thumbsUpCount = [NSNumber numberWithInt:0];
    }
    
    [DESyncManager getPFObjectForEventObjectIdAndUpdate:_post.objectId WithPost:_post];

    DECreatePostViewController *createPostViewController = [[UIStoryboard storyboardWithName:@"Posting" bundle:nil] instantiateViewControllerWithIdentifier:@"FinishedPosting"];
    DEFinishedPostingView *finishedPostView = (DEFinishedPostingView *) createPostViewController.view;
    [[finishedPostView lblParagraphOne] setText:@"The changes to your event have been applied."];
    [[finishedPostView lblParagraphFour] setText:@"Need more posting options?  Full feautured posting available on HappSnap.com"];
    [[finishedPostView lblHeader] setText:@"Edit Complete!"];
    [self.navigationController pushViewController:createPostViewController animated:YES];
}

- (void) loadEditDeleteModeView {
    [[_eventView btnGoing] setTitle:@"Edit" forState:UIControlStateNormal];
    [[_eventView btnGoing] removeTarget:self action:@selector(setEventAsGoing:) forControlEvents:UIControlEventTouchUpInside];
    [[_eventView btnGoing] addTarget:self action:@selector(editPostPressed) forControlEvents:UIControlEventTouchUpInside];
    [[_eventView btnMaybe] setTitle:@"Delete" forState:UIControlStateNormal];
    [[_eventView btnMaybe] removeTarget:self action:@selector(setEventAsMaybeGoing:) forControlEvents:UIControlEventTouchUpInside];
    [[_eventView btnMaybe] addTarget:self action:@selector(deletePostPressed) forControlEvents:UIControlEventTouchUpInside];
    [self loadMainImage];
    [self checkIfEventIsDone];
}

- (void) editPostPressed {
    UIStoryboard *createPost = [UIStoryboard storyboardWithName:@"Posting" bundle:nil];
    DECreatePostViewController *createPostViewController = [createPost instantiateInitialViewController];
    createPostViewController.isEditMode = YES;
    [self.navigationController pushViewController:createPostViewController animated:YES];
    [[DEPostManager sharedManager] setCurrentPost:_post];
}

- (void) deletePostPressed {
    deletionPromptView = [[[NSBundle mainBundle] loadNibNamed:@"viewPromptForDeletionOfEvent" owner:self options:nil] firstObject];
    
    [[deletionPromptView subviews] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[UIButton class]])
        {
            UIButton *button = (UIButton *) obj;
            [[button layer] setCornerRadius:BUTTON_CORNER_RADIUS];
        }
    }];
    
    [self.view addSubview:deletionPromptView];

    [DEAnimationManager animateView:deletionPromptView WithInsets:UIEdgeInsetsZero WithSelector:nil];
}

- (IBAction)cancelDeletion:(id)sender {
    [DEAnimationManager animateViewOut:deletionPromptView WithInsets:UIEdgeInsetsZero];
}

- (IBAction)deletePost:(id)sender {
    [DESyncManager deletePostWithId:_post.objectId];
    DEPostManager *postManager = [DEPostManager sharedManager];
    [postManager deletePFObjectWithObjectId:_post.objectId];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CENTER_USERS_EVENTS_LOADED object:nil userInfo:@{ kNOTIFICATION_CENTER_USER_INFO_USER_PROCESS : kNOTIFICATION_CENTER_USER_INFO_USER_PROCESS_FINISHED_LOADING }];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) setUsernameButtonClickAction {
    DEEventDetailsView *detailsView = [[[_eventView detailsView] subviews] lastObject];

    [detailsView.btnUsername addTarget:self action:@selector(usernameButtonClicked) forControlEvents:UIControlEventTouchUpInside];
}

// Take the user to a profile page where they can see limited information about this user
- (void) usernameButtonClicked {
    if (user)
    {
        DESettingsAccount *settingsAccount = [[DESettingsAccount alloc] initWithUser:user IsPublic:YES];
        
        UIScrollView *scrollView = [[[NSBundle mainBundle] loadNibNamed:@"ViewSettingsAccount" owner:self options:nil] objectAtIndex:1];
        [scrollView setContentSize:settingsAccount.frame.size];
        [scrollView addSubview:settingsAccount];
        [DEAnimationManager fadeOutWithView:self.view ViewToAdd:scrollView];
        [scrollView setFrame:[[UIScreen mainScreen] bounds]];
        [settingsAccount setFrame:[scrollView frame]];
        [settingsAccount setIsPublic:YES];
        [settingsAccount.lblTitle setText:user[PARSE_CLASS_USER_CANONICAL_USERNAME]];
    }
}

- (void) loadMainImage {
    
    id firstObject = [[_post images] firstObject];
    
    if ([firstObject isKindOfClass:[PFFile class]])
    {
        PFFile *file = [[_post images] firstObject];
        
        [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error)
            {
                UIImage *mainImage = [UIImage imageWithData:data];
                [[_eventView btnMainImage] setBackgroundImage:mainImage forState:UIControlStateNormal];
            }
        } progressBlock:^(int percentDone) {
            //Display to the user how much has been loaded
        }];
    }
    else if ([firstObject isKindOfClass:[UIImage class]]) {
        UIImage *mainImage = (UIImage *) firstObject;
        [[_eventView btnMainImage] setBackgroundImage:mainImage forState:UIControlStateNormal];
    }
}

- (void) loadNonPreview
{
    [self loadMainImage];
    // Load all the comments so that by the time the user clicks to view the comments they are already loaded.
    [DESyncManager getAllCommentsForEventId:[[DEPostManager sharedManager] currentPost].objectId];
}

- (void) loadPreview
{
    // Compress the image to less data
    NSArray *postImages = [self imagesToNSDataArray:_post.images Compression:.02];
    [_eventView setPost:_post];
    [[_eventView btnGoing] setEnabled:YES];
    [[_eventView btnGoing] setTitle:@"Post Away!" forState:UIControlStateNormal];
    [[_eventView btnGoing] removeTarget:self action:@selector(setEventAsGoing:) forControlEvents:UIControlEventTouchUpInside];
    [[_eventView btnGoing] addTarget:self action:@selector(savePost:) forControlEvents:UIControlEventTouchUpInside];
    _goingButtonBottomSpaceConstraint.constant -= 40;
    [[_eventView btnMaybe] setHidden:YES];
    [[_eventView lblNumberOfPeopleGoing] setText:0];
    
    UIImage *mainImage =  [UIImage imageWithData:[postImages firstObject]];
    [[_eventView btnMainImage] setBackgroundImage:mainImage forState:UIControlStateNormal];
    
}

- (void) checkIfEventIsDone {
    if (([_post.endTime compare:[NSDate new]] == NSOrderedAscending))
    {
        [[_eventView btnGoing] setUserInteractionEnabled:NO];
        [[_eventView btnMaybe] setUserInteractionEnabled:NO];
        [[_eventView btnGoing] setAlpha:.6f];
        [[_eventView btnMaybe] setAlpha:.6f];
    }
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.view.hidden = NO;
    
    // Only do this when this screen is first loaded
    {
        if (_isGoing && !_isEditDeleteMode)
        {
            [self updateViewToGoing];
        }
        if (_isMaybeGoing && !_isEditDeleteMode)
        {
            self.maybeCheckmarkView.hidden = NO;
        }
    }
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.view.hidden = YES;
}

- (IBAction) savePost : (id)sender {
    
    NSArray *postImages = [self imagesToNSDataArray:_post.images Compression:.02];
    [[[DEPostManager sharedManager] currentPost] setImages:postImages];
    BOOL postSaved = [DESyncManager savePost:[[DEPostManager sharedManager] currentPost]];
    [[DEScreenManager sharedManager] showPostingIndicatorWithText:@"Posting Event"];
    
    if (postSaved)
    {
        DECreatePostViewController *createPostViewController = [[UIStoryboard storyboardWithName:@"Posting" bundle:nil] instantiateViewControllerWithIdentifier:@"FinishedPosting"];
        DEFinishedPostingView *finishedPostView = (DEFinishedPostingView *) createPostViewController.view;
        NSDate *laterDate = [NSDate dateWithTimeIntervalSinceNow:(60 * 59 * 24 * 3)];
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:laterDate];
        laterDate = [[NSCalendar currentCalendar] dateFromComponents:components];
        
        // If the start time of the post is beyond three days, then we want to display to the user that this event will not show up until it's within three days of the start time of the event
        if ([[_post startTime] compare:laterDate] == NSOrderedDescending)
        {
            finishedPostView.lblParagraphOne.text = @"PLEASE NOTE: Your event will be available for viewing 3 deays from its start time.";
            finishedPostView.lblParagraphTwo.text = @"Need to make changes?\nEdit or delete your event from";
            finishedPostView.lblParagraphThree.text = @"My Posts";
            finishedPostView.lblParagraphFour.text = @"Need more posting options?\nFull featured posting available on\nHappSnap.com";
        }
        else {
            finishedPostView.lblParagraphOne.text = @"Your post will appear shortly";
            finishedPostView.lblParagraphTwo.text = @"Need to make changes?\nEdit or delete your event from";
            finishedPostView.lblParagraphThree.text = @"My Posts";
            finishedPostView.lblParagraphFour.text = @"Need more posting options?\nFull featured posting available on\nHappSnap.com";
        }
        
        [createPostViewController.navigationItem setHidesBackButton:YES];
        [self.navigationController pushViewController:createPostViewController animated:YES];
        [[DEPostManager sharedManager] setCurrentPost:[DEPost new]];
        [[DELocationManager sharedManager] setPlaceLocation:nil];
    }
    
    _post = nil;
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

    CGRect frame = newView.frame;
    frame.size.width = view.frame.size.width;
    frame.size.height = view.frame.size.height;
    [newView setFrame:frame];
    
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
        if (userIsAmbassador)
        {
            ((DEEventDetailsView *) topView).txtDescription.dataDetectorTypes = UIDataDetectorTypeLink;
        }
        else {
            ((DEEventDetailsView *) topView).txtDescription.dataDetectorTypes = UIDataDetectorTypeNone;
        }
        
        [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            @autoreleasepool {
                NSData *imageData = data;
                UIImage *image = [UIImage imageWithData:imageData];
                ((DEEventDetailsView *) topView).profileImageView.image = image;
                
                image = nil;
                
                if (userIsAmbassador)
                {
                    ((DEEventDetailsView *) topView).ambassadorFlagView.hidden = NO;
                    DELevelHandler *levelHandler = [DELevelHandler new];
                    // Display the ambassador's current level
                    ((DEEventDetailsView *) topView).lblLevel.text = [[levelHandler getLevelInformation:object[PARSE_CLASS_USER_POST_COUNT]] stringValue];
                }
            }
        }];
    }
    
    if ([topView isKindOfClass:[DEEventDetailsView class]])
    {
        [[((DEEventDetailsView *) topView).profileImageView layer] setCornerRadius:((DEEventDetailsView *) topView).profileImageView.frame.size.height / 2.0];
        if (!user[PARSE_CLASS_USER_CANONICAL_USERNAME])
        {
            [((DEEventDetailsView *) topView).btnUsername setTitle:_post.username forState:UIControlStateNormal];
        }
        else {
            [((DEEventDetailsView *) topView).btnUsername setTitle:user[PARSE_CLASS_USER_CANONICAL_USERNAME] forState:UIControlStateNormal];
        }
    }
}


- (void) showFlagIfAmbassadorDetailsView : (DEEventDetailsView *) detailsView {
    if (userIsAmbassador)
    {
        detailsView.ambassadorFlagView.hidden = NO;
    }
    else {
        detailsView.ambassadorFlagView.hidden = YES;

    }
}

#pragma mark - Button Action Methods

- (IBAction)showEventDetails:(id)sender
{
    [self showView:[_eventDetailsViewController viewInfo]];
    
    DEEventDetailsView *detailsView = [[[_eventView detailsView] subviews] lastObject];
    
    if (![detailsView isLoaded])
    {
        [detailsView setIsLoaded:YES];
        
        if (_isPreview)
        {
            [detailsView.btnUsername setTitle:[[DEUserManager sharedManager] userObject][PARSE_CLASS_USER_CANONICAL_USERNAME] forState:UIControlStateNormal];
        }
        
        [[detailsView txtDescription] setText:nil];
        NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
        [fmt setPositiveFormat:@"0.##"];
        
        NSString *eventDuration = [fmt stringFromNumber:[DEPostManager getDurationOfEvent:_post]];
        [[detailsView lblDuration] setText:[NSString stringWithFormat:@"%@hr Event", eventDuration]];
        
        NSString *website = _post.website;
        if (!_post.website)
        {
            website = @"";
        }
        [[detailsView txtDescription] setText:[NSString stringWithFormat:@"%@\n%@", _post.myDescription, website]];

        // If the post is free
        if (_post.cost == nil)
        {
            [[detailsView lblCost] setText:@"free"];
        }
        else {
            [[detailsView lblCost] setText:[NSString stringWithFormat:@"$%@", [_post.cost stringValue]]];
        }
        [[detailsView lblNumberGoing] setText:[NSString stringWithFormat:@"%@", _post.numberGoing]];
        
        [self showFlagIfAmbassadorDetailsView:detailsView];
        
        if ([[_post startTime] compare:[NSDate date]] == NSOrderedDescending)
        {
            NSDate *threeHoursFromNow = [[NSDate date] dateByAddingTimeInterval:60 * 60 * 3];
            NSDateFormatter *df = [NSDateFormatter new];
            [df setDateFormat:@"M/dd/yyyy"];
            
            if ([DEPostManager daysBetweenDate:[NSDate date] andDate:[_post startTime]] > 6) {
                [[detailsView lblEndsInStartsIn] setText:[NSString stringWithFormat:@"Starts %@", [df stringFromDate:[_post startTime]]]];
            }
            else if ([threeHoursFromNow compare:[_post startTime]] == NSOrderedDescending)
            {
                [[detailsView lblEndsInStartsIn] setText:@"Starts In"];
            }
            else {
                [[detailsView lblEndsInStartsIn] setText:[DEPostManager getDayOfWeekFromPost:_post]];
            }
        }
        else
        {
            [[detailsView lblEndsInStartsIn] setText:@"Ends In"];
            [[detailsView lblDuration] setText:@""];
        }
    }
    
    [self adjustDetailsViewHeightDetailsView:detailsView];
    [[detailsView lblTimeUntilStartsOrEnds] setText:[DEPostManager getTimeUntilStartOrFinishFromPost:_post isOverlayView:NO]];
}

- (void) adjustDetailsViewHeightDetailsView : (DEEventDetailsView *) detailsView {
    
    // Set the height of the UITextView for the description to the necessary height to fit all the information
    CGSize sizeThatFitsTextView = [[detailsView txtDescription] sizeThatFits:CGSizeMake([detailsView txtDescription].frame.size.width, 1000)];
    CGFloat heightDifference =  ceilf(sizeThatFitsTextView.height) - heightConstraintConstant;
    [detailsView heightConstraint].constant = ceilf(sizeThatFitsTextView.height);
    
    CGRect frame = [_eventView detailsView].frame;
    frame.size.height += heightDifference + 40;
    frame.origin.y = 0;
    [detailsView setFrame:frame];
    [[_eventView detailsView] setContentSize:detailsView.frame.size];
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
        [shareView setImage:[[_eventView btnMainImage] backgroundImageForState:UIControlStateNormal]];
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
        mapViewController.isPreview = _isPreview;
        [mapViewController updateViewToGoing];
    }

}

#pragma mark - Going and Not Going Methods

- (void) addEventToGoingListAndUpdateGoingCount
{
    int numGoing = [_post.numberGoing intValue];
    numGoing ++;
    _post.numberGoing = [NSNumber numberWithInt:numGoing];
    NSDictionary *dictionary = @{ PARSE_CLASS_EVENT_NUMBER_GOING: _post.numberGoing };
    [[[DEPostManager sharedManager] goingPost] addObject:_post.objectId];
    if (![PFUser currentUser])
    {
        [[[DEPostManager sharedManager] goingPostForNoAccount] addObject:_post.objectId];
        [[DEPostManager sharedManager] saveNoAccountInformation];
    }
    [DESyncManager updateObjectWithId:_post.objectId UpdateValues:dictionary ParseClassName:PARSE_CLASS_NAME_EVENT];
    [[_viewEventView lblNumGoing] setText:[NSString stringWithFormat:@"%@", [_post numberGoing]]];
    [DEAnimationManager savedAnimationWithImage:@"going-indicator-icon.png"];
}

- (IBAction) setEventAsGoing:(id)sender {
    
    static BOOL going = NO;
    DEPostManager *postManager = [DEPostManager sharedManager];
    
    // If the user has not already selected this post as going then we set this post as going for the user and save that to the server.
    if ( ![[postManager goingPost] containsObject:_post] )
    {
        [self addEventToGoingListAndUpdateGoingCount];
        if ([[postManager maybeGoingPost] containsObject:_post.objectId])
        {
            [[postManager maybeGoingPost] removeObject:_post.objectId];
            
        }
        self.maybeCheckmarkView.hidden = YES;
        going = YES;
        // Save this item as going for the user to the server
        [[DEUserManager sharedManager] saveItemToArray:_post.objectId ParseColumnName:PARSE_CLASS_USER_EVENTS_GOING];
        
        if ([_eventView.detailsView.subviews[0] isKindOfClass:[DEEventDetailsView class]])
        {
            DEEventDetailsView *eventView = (DEEventDetailsView *) _eventView.detailsView.subviews[0];
            [[eventView lblNumberGoing] setText:[NSString stringWithFormat:@"%@", [_post numberGoing]]];
        }
        
        // Make sure that the user has not selected maybe going, and if so don't allow them to comment
        if (![[[DEPostManager sharedManager] maybeGoingPost] containsObject:_post] || ![[DEPostManager sharedManager] maybeGoingPost])
        {
            if (![[DELocationManager sharedManager] checkIfCanCommentForEvent:_post])
            {
                // Start monitoring to see if the user is near this event location
                [[DELocationManager sharedManager] startMonitoringRegionForPost:_post MonitorExit:NO];
            }
        }
    }
    
    if (!_mapView)
    {
        [self shareEvent:nil];
    }
    else {
        NSInteger indexOfViewController = self.navigationController.viewControllers.count - 2;
        DEEventViewController *viewController = [self.navigationController.viewControllers objectAtIndex:indexOfViewController];
        viewController.isGoing = YES;
        [viewController updateViewToGoing];
        [viewController shareEvent:nil];

        [self.navigationController popViewControllerAnimated:YES];
    }
    
    [self updateViewToGoing];
    [[_eventView btnMainImage] setHidden:YES];
}

- (IBAction) setEventAsMaybeGoing:(id)sender {
    
    DEPostManager *postManager = [DEPostManager sharedManager];
    if (![[postManager maybeGoingPost] containsObject:_post.objectId])
    {
        [[postManager maybeGoingPost] addObject:_post.objectId];
        if (![PFUser currentUser])
        {
            [[[DEPostManager sharedManager] maybeGoingPostForNoAccount] addObject:_post.objectId];
            [[DEPostManager sharedManager] saveNoAccountInformation];
        }
        // Save this item as maybe going for the user to the server
        [[DEUserManager sharedManager] saveItemToArray:_post.objectId ParseColumnName:PARSE_CLASS_USER_EVENTS_MAYBE];
        self.maybeCheckmarkView.hidden = NO;
        [DEAnimationManager savedAnimationWithImage:@"maybe-indicator-icon.png"];
        if (![[DELocationManager sharedManager] checkIfCanCommentForEvent:_post])
        {
            [[DELocationManager sharedManager] startMonitoringRegionForPost:_post MonitorExit:NO];
        }
    }
}

/*
 
 Takes an array of images and returns an array of their data representations
 
 */
- (NSArray *) imagesToNSDataArray : (NSArray *) array
                      Compression : (CGFloat) compression {
    __block NSMutableArray *dataArray = [NSMutableArray new];
    
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        // If this array still contains images then we do no conversion and return the array that was given
        if ([obj isKindOfClass:[UIImage class]])
        {
            UIImage *image = (UIImage *) obj;
            NSData *dataOfImage = UIImageJPEGRepresentation(image, compression);
            [dataArray addObject:dataOfImage];
        }
        else {
            dataArray = [array mutableCopy];
            *stop = YES;
        }
    }];
    
    return dataArray;
}

- (NSArray *) dataToUIIMageArray : (NSArray *) array {
    NSMutableArray *imageArray = [NSMutableArray new];
    
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSData *data = (NSData *) obj;
        UIImage *image = [UIImage imageWithData:data];
        [imageArray addObject:image];
    }];
    
    return imageArray;
}

#pragma mark - Buttons

/*

 Show a view controller with all the images as the user can see
 
 */
- (IBAction)showImages:(id)sender {
    
    DEViewImagesViewController *pageViewController = [[UIStoryboard storyboardWithName:@"Event" bundle:nil] instantiateViewControllerWithIdentifier:@"viewImages"];
    NSMutableArray *viewControllers = [NSMutableArray new];
    NSArray *postImages = [self imagesToNSDataArray:_post.images Compression:.02];
    for (NSUInteger i = 0; i < [_post.images count]; i ++) {
        DEViewImageViewController *viewController = [[UIStoryboard storyboardWithName:@"Event" bundle:nil] instantiateViewControllerWithIdentifier:@"viewImage"];
        [viewController setImage:postImages[i]];
        [viewController setIndex:i];
        [viewController setPostTitle:_post.title];
        [viewControllers addObject:viewController];
    }
    
    [pageViewController setMyViewControllers:viewControllers];
    if ([viewControllers count] != 0)
    {
        [pageViewController setViewControllers:@[viewControllers[0]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
        [self.navigationController pushViewController:pageViewController animated:YES];
    }
}


- (void) updateViewToGoing
{
    UIButton *goingButton;
    UIButton *maybeButton;
    
    goingButton = [_eventView btnGoing];
    maybeButton = [_eventView btnMaybe];
    
    [goingButton setTitle:@"Map It" forState:UIControlStateNormal];
    [goingButton removeTarget:self action:@selector(setEventAsGoing:) forControlEvents:UIControlEventTouchUpInside];
    [goingButton addTarget:self action:@selector(mapIt) forControlEvents:UIControlEventTouchUpInside];

    _goingButtonBottomSpaceConstraint.constant = -40;
    _goingButtonBottomSpaceConstraintMapView.constant = -40;
    [self.view layoutIfNeeded];
    [maybeButton setHidden:YES];
    
    CGRect frame = _mapView.frame;
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
        PFGeoPoint *currentLocation = [[DELocationManager sharedManager] currentLocation];
        NSString *urlString = [NSString stringWithFormat:APPLE_MAPS_APP_URL, [_post.address stringByReplacingOccurrencesOfString:@" " withString:@"+"], currentLocation.latitude, currentLocation.longitude];

        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    }
}



@end
