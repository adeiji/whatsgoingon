//
//  DEViewEventsViewController.m
//  whatsgoinon
//
//  Created by adeiji on 8/5/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import "DEViewEventsViewController.h"
#import "Constants.h"
#import "Reachability.h"


@interface DEViewEventsViewController ()

@end

#define POST_HEIGHT 305
#define POST_WIDTH 140
#define IPHONE_DEVICE_WIDTH 320
#define TOP_MARGIN 20
#define SCROLL_VIEW_DISTANCE_FROM_TOP 30
#define MAIN_MENU_Y_POS 0

const int NO_USER_EVENTS = 5;
NSString *IS_FIRST_TIME_VIEWING_SCREEN = @"com.happsnap.isfirsttimeviewingscreen";

@implementation DEViewEventsViewController

struct TopMargin {
    int column;
    int height;
};

- (void) addObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayPost) name:NOTIFICATION_CENTER_ALL_EVENTS_LOADED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSelectorToNewCity) name:kNOTIFICATION_CENTER_IS_CITY_CHANGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayUsersEvents:) name:NOTIFICATION_CENTER_USERS_EVENTS_LOADED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orbClicked) name:NOTIFICATION_CENTER_ORB_CLICKED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showNoInternetConnectionScreen:) name:kReachabilityChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayPostFromNewCity) name:NOTIFICATION_CENTER_CITY_CHANGED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayPastEpicEvents:) name:NOTIFICATION_CENTER_NO_DATA object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayNoDataInCategory:) name:NOTIFICATION_CENTER_NONE_IN_CATEGORY object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayUserSavedEvents:) name:NOTIFICATION_CENTER_SAVED_EVENTS_LOADED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayNoSavedEvents) name:NOTIFICATION_CENTER_NO_SAVED_EVENTS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeAllPostFromScreen) name:kNOTIFICATION_CENTER_USER_INFO_USER_PROCESS_NEW object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayPastEpicEvents:) name:NOTIFICATION_CENTER_PAST_EPIC_EVENTS_LOADED object:nil];
}

#pragma mark - Activity Spinners


- (void) startActivitySpinner
{
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    spinner.center = self.view.center;
    spinner.hidesWhenStopped = YES;
    [self.view addSubview:spinner];
    [spinner startAnimating];
}

- (void) stopActivitySpinner {
    [spinner hidesWhenStopped];
    [spinner stopAnimating];
}


- (void) changeSelectorToNewCity {
    postSelector = @selector(getAllValuesWithinMilesForNow:PostsArray:Location:);
}

- (void) loadFirstTimeView {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber *isFirstTimeViewingScreen = (NSNumber *) [userDefaults objectForKey:IS_FIRST_TIME_VIEWING_SCREEN];
    welcomeScreen = NO;
    
    if (!isFirstTimeViewingScreen)
    {
        welcomeView = (DEWelcomeEventView *)[[[NSBundle mainBundle] loadNibNamed:@"WelcomeEventsView" owner:self options:nil] firstObject];
        [welcomeView setFrame:[[UIScreen mainScreen] bounds]];
        [[welcomeView.btnStart layer] setCornerRadius:BUTTON_CORNER_RADIUS];
        [self.view addSubview:welcomeView];
        [userDefaults setObject:@YES forKey:IS_FIRST_TIME_VIEWING_SCREEN];
        welcomeScreen = YES;
    }
}

- (void)viewDidLoad
{
    [[DELocationManager sharedManager] updateLocation];
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    //Load the posts first so that we can see how big we need to make the scroll view's content size.
    [self addObservers];
    
    if (!_shouldNotDisplayPosts)
    {
        [self startActivitySpinner];
        if (_now)
        {
            [DESyncManager getAllValuesForNow:YES];
        }
        else {
            [DESyncManager getAllValuesForNow:NO];
        }
    }
    
    [self loadFirstTimeView];
    DESelectCategoryView *selectCategoryView = [[[NSBundle mainBundle] loadNibNamed:@"SelectCategoryView" owner:self options:nil] firstObject];
    [self.view addSubview:selectCategoryView];
    [selectCategoryView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]];
    [selectCategoryView loadView];
    orbView = selectCategoryView.orbView;
    outerView = selectCategoryView.outerView;
    /*
     If the welcome screen is displayed then don't allow the orb view to be selected
     */
    if (welcomeScreen)
    {
        [orbView setEnabled:NO];
    }
    [selectCategoryView setFrame:[[UIScreen mainScreen] bounds]];
    [self.view addSubview:selectCategoryView];
    [DEScreenManager setBackgroundWithImageURL:@"HappSnap-bg.png"];
    
    /* Check to see if this is their first time going to this part of the application
     If it is their first time then show the welcome screen.
     Otherwise go straight to the viewing of the post
     Add the gesture recognizer which will be used to show and hide the main menu view*/
    [self addGestureRecognizers];
    
    viewMainMenu = [[[NSBundle mainBundle] loadNibNamed:@"MainMenuView" owner:self options:nil] firstObject];
    [viewMainMenu setSuperView:self.view];
    [viewMainMenu setupView];
    DEScreenManager *screenManager = [DEScreenManager sharedManager];
    [screenManager setMainMenu:viewMainMenu];
    [self.view setBackgroundColor:[UIColor clearColor]];
    [self.navigationController setNavigationBarHidden:YES];
    [self setUpSearchBar];
    [self removeAllPostFromScreen];
}

- (void) removeFirstResponder {
    [_searchBar resignFirstResponder];
}

- (void) setUpSearchBar
{
    [self.searchBar setInputAccessoryView:[DEScreenManager createInputAccessoryView]];
    [self.searchBar setBackgroundImage:[UIImage new]];
    
    for (UIView *view in self.searchBar.subviews) {
        for (UIView *subview in view.subviews) {
            if ([subview isKindOfClass:[UITextField class]])
            {
                [subview setBackgroundColor:[UIColor colorWithRed:0.0/255.0f green:0.0/255.0f blue:0.0/255.0f alpha:.30]];
            }
        }
    }
}

- (void) addGestureRecognizers
{
    UISwipeGestureRecognizer *swipeRightGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showOrHideMainMenu:)];
    [swipeRightGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    
    [[self view] addGestureRecognizer:swipeRightGestureRecognizer];
    
    UISwipeGestureRecognizer *swipeLeftGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showOrHideMainMenu:)];
    [swipeLeftGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    
    [[self view] addGestureRecognizer:swipeLeftGestureRecognizer];

}

- (void) enableClickOnEvents : (BOOL) clickable {
    for (UIView *subview in [_scrollView subviews]) {
        if (clickable) {
            [subview setUserInteractionEnabled:YES];
        }
        else {
            [subview setUserInteractionEnabled:NO];
        }
    }
}

- (void) showMainMenu
{
    [self enableClickOnEvents:NO];
    DEScreenManager *screenManager = [DEScreenManager sharedManager];
    [[[self view] superview] addSubview:[screenManager mainMenu]];
    CGRect frame = [screenManager mainMenu].frame;
    frame.origin.y = MAIN_MENU_Y_POS;
    frame.origin.x = -frame.size.width;
    frame.size.height = [[UIScreen mainScreen] bounds].size.height;
    viewMainMenu.frame = frame;
    
    self.mainViewRightConstraint.constant = self.mainViewRightConstraint.constant - frame.size.width;
    self.mainViewLeftConstraint.constant = self.mainViewLeftConstraint.constant + frame.size.width;
    
    // tell constraints they need updating and update constraints now so we can animate the change
    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
    
    [UIView animateWithDuration:.5f animations:^{
        [self.view layoutIfNeeded];
        // Move the main menu over to the right
        CGRect frame = [screenManager mainMenu].frame;
        frame.origin.x = 0;
        [screenManager mainMenu].frame = frame;
    }];
    
    menuDisplayed = YES;
    [self hideOrbView];
}

- (void) hideMainMenu
{
    DEScreenManager *screenManager = [DEScreenManager sharedManager];
    [self enableClickOnEvents:YES];
    self.mainViewLeftConstraint.constant = 0;
    self.mainViewRightConstraint.constant = 0;
    
    [UIView animateWithDuration:.5f animations:^{
        [self.view layoutIfNeeded];
        CGRect frame = [screenManager mainMenu].frame;
        frame.origin.x = -([screenManager mainMenu].frame.size.width);
        [screenManager mainMenu].frame = frame;
    } completion:^(BOOL finished) {
        [[screenManager mainMenu] removeFromSuperview];
    }];
    
    menuDisplayed = NO;
    [self showOrbView];
}

- (void) showOrHideMainMenu : (UISwipeGestureRecognizer *) gestureRecognizer {
    
    if (gestureRecognizer.direction == UISwipeGestureRecognizerDirectionRight )
    {
        [self showMainMenu];
    }
    else {
        [self hideMainMenu];
    }
}


- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    // Check to see if the this View Controller is still in the view controller hierarchy, if not then we remove all the images
    if (![self.navigationController.viewControllers containsObject:self])
    {
        for (UIView *subview in [_scrollView subviews]) {
            if ([subview isKindOfClass:[DEViewEventsView class]])
            {
                ((DEViewEventsView *) subview).imgMainImageView.image = nil;
                [subview removeFromSuperview];
            }
            
        }
        
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
    
    self.view.hidden = YES;
    [_scrollView setDelegate:nil];
}

- (void) viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
    [self.view setHidden:YES];
    [self.scrollView removeFromSuperview];
    
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.scrollView setDelegate:self];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.view.hidden = NO;
    
    if (menuDisplayed && ![[[DEScreenManager sharedManager] mainMenu] superview])
    {
        DEScreenManager *screenManager = [DEScreenManager sharedManager];
        [[self view] addSubview:[screenManager mainMenu]];
        [[[DEScreenManager sharedManager] mainMenu] setHidden:NO];
    }
    
    if (![_scrollView superview])
    {
        [_containerView addSubview:_scrollView];
        [_scrollView setTranslatesAutoresizingMaskIntoConstraints:YES];
    }
}

- (void) orbClicked {
    if (welcomeScreen)
    {
        [self hideWelcomeScreen:nil];
    }
}

- (IBAction)hideWelcomeScreen:(id)sender {
    for (UIView *subview in [welcomeView subviews]) {
        [subview removeFromSuperview];
    }
    [UIView animateWithDuration:.25f animations:^{
        CGRect frame = welcomeView.frame;
        frame.origin.y = welcomeView.center.y;
        frame.size.height = 20;
        [welcomeView setFrame:frame];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.25f animations:^{
            CGRect frame = welcomeView.frame;
            frame.origin.x = welcomeView.center.x;
            frame.size.width = 20;
            [welcomeView setFrame:frame];
        } completion:^(BOOL finished) {
            [welcomeView removeFromSuperview];
        }];
    }];
    
    welcomeScreen = NO;
    [orbView setEnabled:YES];
    
}

- (void) hideOrbView
{
    if (!welcomeScreen)
    {
        orbView.hidden = YES;
        outerView.hidden = YES;
    }
}

- (void) showOrbView
{
    orbView.hidden = NO;
    outerView.hidden = NO;
}

- (void) loadPosts {
    _posts = [[DEPostManager sharedManager] posts];
}

- (void) displayPostFromNewCity
{
    for (UIView *subview in [_scrollView subviews]) {
        [subview removeFromSuperview];
    }
}

- (void) displayPastEpicEvents : (NSNotification *) notification
{
    BOOL isPastEpicEvent = notification.userInfo[kNOTIFICATION_CENTER_USER_INFO_IS_EPIC_EVENTS];
    UIView *view;
    
    [self removeAllPostFromScreen];

    if (!isPastEpicEvent)
    {
        // If this method is being called because there are no events loaded
        view = [[[NSBundle mainBundle] loadNibNamed:@"ViewEventsView" owner:self options:nil] objectAtIndex:2];
    }
    else {
        view = [[[NSBundle mainBundle] loadNibNamed:@"ViewEventsView" owner:self options:nil] objectAtIndex:4];
    }
    
    [self moveViewToCenterOfScrollViewView:view];
    [_scrollView addSubview:view];

    [self setUpScrollViewForPostsWithTopMargin:view.frame.size.height + 15];
    [self stopActivitySpinner];
    [self displayPost:nil TopMargin:view.frame.size.height + 15 PostArray:nil];
    
    [self hideOrbView];
    
    _lblCategoryHeader.text = @"Past Epic Events";
}

- (void) moveViewToCenterOfScrollViewView : (UIView *) view {
    CGPoint center = view.center;
    center.x = _scrollView.center.x;
    [view setCenter:center];
}

- (void) displayNoDataInCategory : (NSNotification *) notification
{
    if (!welcomeScreen)
    {
        [_scrollView setContentSize:_scrollView.frame.size];
        [self removeAllPostFromScreen];
        if (notification.userInfo[kNOTIFICATION_CENTER_USER_INFO_CATEGORY])
        {
            [self displayCategory:notification.userInfo[kNOTIFICATION_CENTER_USER_INFO_CATEGORY]];
        }
        UIView *view = [[[NSBundle mainBundle] loadNibNamed:@"SelectCategoryView" owner:self options:nil] lastObject];
        [self moveViewToCenterOfScrollViewView:view];
        [_scrollView addSubview:view];
    }
    else {
        [DESyncManager loadEpicEvents:NO];
    }
}

- (void) scrollToTopOfScrollView
{
    [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [_scrollView setContentSize:_scrollView.frame.size];
}

- (void) showNoInternetConnectionScreen : (NSNotification *) object {
    Reachability *reach = [object valueForKey:@"object"];
    
    if ([reach currentReachabilityStatus] == NotReachable)
    {
        if ([[_scrollView subviews] count] == 2)
        {
            UIView *view = [[[NSBundle mainBundle] loadNibNamed:@"ViewNoInternet" owner:self options:nil] firstObject];
            
            for (UIView *subview in [view subviews]) {
                if ([subview isKindOfClass:[UIButton class]])
                {
                    UIButton *button = (UIButton *) subview;
                    [[button layer] setCornerRadius:BUTTON_CORNER_RADIUS];
                    
                    [button addTarget:self action:@selector(goHome:) forControlEvents:UIControlEventTouchUpInside];
                }
            }
            
            [DEAnimationManager fadeOutWithView:self.view ViewToAdd:view];
            [[DEScreenManager sharedManager] stopActivitySpinner];
        }
        
        [self hideOrbView];
    }
}

- (void) displayCategory : (NSString *) myCategory
{
    self.lblCategoryHeader.text = myCategory;
}

// Remove all the events/posts currently on the screen and free the images from memory
- (void) removeAllPostFromScreen {
    // Always hide the main menu when we show anything new on the screen
    [self hideMainMenu];
    for (UIView *subview in [_scrollView subviews]) {
        if ([subview isKindOfClass:[DEViewEventsView class]])
        {
            ((DEViewEventsView *) subview).imgMainImageView.image = nil;
            [subview removeFromSuperview];
        }
        
        [subview removeFromSuperview];
    }
}

- (void) displayUsersEvents : (NSNotification *) notification {
    if ([[[DEPostManager sharedManager] posts] count] != 0)
    {
        [self removeAllPostFromScreen];
        [self displayPost:notification TopMargin:0 PostArray:nil];
    }
    else {
        [self showNoPostedEventsByUser];
    }
}

- (void) displayPost {
    [self stopActivitySpinner];
    [self displayPost:nil TopMargin:0 PostArray:nil];
}

- (void) displayPost : (NSNotification *) notification
           TopMargin : (CGFloat) topMargin
           PostArray : (NSArray *) postArray
{
    _isNewProcess = YES;
    if (notification.userInfo[kNOTIFICATION_CENTER_USER_INFO_CATEGORY] && notification.userInfo[kNOTIFICATION_CENTER_USER_INFO_USER_PROCESS])
    {
        [self displayCategory:notification.userInfo[kNOTIFICATION_CENTER_USER_INFO_CATEGORY]];
        category = notification.userInfo[kNOTIFICATION_CENTER_USER_INFO_CATEGORY];
    }
    
    if (!postArray)
    {
        [self loadPosts];
    }
    else {
        _posts = postArray;
    }
    
    [self addEventsToScreen : topMargin
               ProcessStatus:kNOTIFICATION_CENTER_USER_INFO_USER_PROCESS_NEW
                    Category:notification.userInfo[kNOTIFICATION_CENTER_USER_INFO_CATEGORY]
                   PostArray:_posts
                   ShowBlank:YES];
    [self loadVisiblePost:_scrollView];
}

/*
 
 Display to the user that he has no events that he posted, and show a button which will allow the user to post an event.
 
 */
- (void) showNoPostedEventsByUser {
    [self removeAllPostFromScreen];
    UIView *noPostedEventsView = [[[NSBundle mainBundle] loadNibNamed:@"ViewEventsView" owner:self options:nil] objectAtIndex:NO_USER_EVENTS];
    [noPostedEventsView setFrame:[[UIScreen mainScreen] bounds]];
    [_scrollView addSubview:noPostedEventsView];
    CGRect frame = [noPostedEventsView frame];
    frame.size.height = _scrollView.frame.size.height;
    [noPostedEventsView setFrame:frame];
    CGSize contentSize = [_scrollView contentSize];
    contentSize.height = _scrollView.frame.size.height;
    [_scrollView setContentSize:contentSize];
    [self hideOrbView];
}

/*
    1. Remove all the post from the screen
    2. Get all the actual events from the Event Ids that are stored within the application
    3. Add those views to the screen
*/
- (void) displayUserSavedEvents : (NSNotification *) notification {
    
    [self removeAllPostFromScreen];

    NSArray *postArray = [[DEPostManager sharedManager] loadedSavedEvents];
    postArray = [self setAllPostsToNotLoaded:postArray];
    [self displayPost:nil TopMargin:0 PostArray:postArray];
    [self loadVisiblePost:_scrollView];
    _lblCategoryHeader.text = @"My Events";
}

- (void) getEventsFromEventIdsInGoingAndMaybe {
    
}

- (void) setUpScrollViewForPostsWithTopMargin : (NSInteger) topMargin
{
    //The calculation for the height gets the number of posts divided by two and then adds whatever the remainder is.  This makes sure that if there are for example 9 posts, we make sure that we do POST_HEIGHT * 5, and not 4, because the last post needs to show.
    CGSize size = _scrollView.contentSize;
    size.height = size.height + topMargin;
    _scrollView.contentSize = size;
}

- (void) addEventsToScreen : (CGFloat) topMargin
             ProcessStatus : (NSString *) process
                  Category : (NSString *) myCategory
                 PostArray : (NSArray *) postArray
                 ShowBlank : (BOOL) showBlank
{
    static CGFloat column = 0;
    static int postCounter = 1;
    static CGFloat columnOneMargin = 0;
    static CGFloat columnTwoMargin = 0;
    static CGFloat margin = 0;
    CGFloat scrollViewContentSizeHeight = 0;
    CGFloat screenSizeRelativeToiPhone5Width = [[UIScreen mainScreen]  bounds].size.width / 320;
    __block BOOL validated;
    static int count = 0;
    validated = NO;

    if ([process isEqualToString: kNOTIFICATION_CENTER_USER_INFO_USER_PROCESS_NEW])
    {
        count = 0;
    }
    
    if (_isNewProcess)     /* If we've finished loading all the
                                 events then we reset everything back
                                 to zero so that next time we load
                                 events it will show them correctly*/
    {
        column = 0;
        postCounter = 1;
        columnOneMargin = 0;
        columnTwoMargin = 0;
        margin = 0;
        scrollViewContentSizeHeight = 0;
        _isNewProcess = NO;
    }
    
    if (count < [postArray count])
    {
        for (int i = 0; i < 10; i ++) {
            if ([postArray count] != 0 && count < [postArray count])
            {
                id obj = postArray[count];
                validated = [self isValidToShowEvent:obj Category:myCategory PostNumber : postCounter];
                // Show the event on the screen
                if (([obj[@"loaded"] isEqual:@NO] || !obj[@"loaded"])  && validated)
                {
                    [self loadEvent:obj
                            Margin1:&columnOneMargin
                            Margin2:&columnTwoMargin
                             Column:&column
                          TopMargin:topMargin
                        PostCounter:&postCounter
                          ShowBlank:showBlank];
                }
                
                count ++;
            }
        }


        // Add the column one or column two margin, depending on which is greater to the height of the scroll view's content size
        if (columnOneMargin > columnTwoMargin)
        {
            scrollViewContentSizeHeight += (columnOneMargin) + topMargin;
        }
        else {
            scrollViewContentSizeHeight += (columnTwoMargin) + topMargin;
        }
        
        CGSize size = _scrollView.contentSize;
        size.height = scrollViewContentSizeHeight;
        [_scrollView setContentSize:size];
        
    }

    
}

- (NSArray *) setAllPostsToNotLoaded : (NSArray *) posts {
    for (PFObject *obj in posts) {
        obj[@"loaded"] = @NO;
    }
    
    return posts;
}

/*
 
 Display to the user that there were no events that the user has saved
 
 */

- (void) displayNoSavedEvents {
    [self removeAllPostFromScreen];
    UIView *view = [[[NSBundle mainBundle] loadNibNamed:@"ViewEventsView" owner:self options:nil] objectAtIndex:3];
    [_scrollView addSubview:view];
    [self moveViewToCenterOfScrollViewView:view];
    [_scrollView setContentSize:view.frame.size];
    [self showOrbView];
    
    [self scrollToTopOfScrollView];
}

/*
 
 Load the event
 
 */

- (void) loadEvent : (PFObject *) obj
           Margin1 : (CGFloat *) columnOneMargin
           Margin2 : (CGFloat *) columnTwoMargin
            Column : (CGFloat *) column
         TopMargin : (CGFloat) topMargin
       PostCounter : (int *) postCounter
         ShowBlank : (BOOL) showBlank
{
    CGFloat viewEventsViewFrameHeight = POST_HEIGHT;
    DEPost *post = [DEPost getPostFromPFObject:obj];
    obj[@"loaded"] = @YES;
    
    DEViewEventsView *viewEventsView = [[[NSBundle mainBundle] loadNibNamed:@"ViewEventsView" owner:self options:nil] objectAtIndex:0];
    [viewEventsView setSearchBar:_searchBar];
    [viewEventsView renderViewWithPost:post
                             ShowBlank:showBlank];
    [viewEventsView setPostObject:obj];

    
    CGFloat heightDifference = [self getLabelHeightDifference:viewEventsView];
    heightDifference += [self getEventImageHeightDifference:viewEventsView];
    
    [self setUpViewEventsFrame:*columnOneMargin
                        Margin:*columnTwoMargin
                          Post:post
                        Column:*column
                ViewEventsView:viewEventsView
              HeightDifference:heightDifference
                     TopMargin:topMargin];
    


    [_scrollView addSubview:viewEventsView];
    
    if (*column == 0)
    {
        *column = 1;
        *columnOneMargin += viewEventsViewFrameHeight + heightDifference + TOP_MARGIN;
    }
    else {
        *column = 0;
        *columnTwoMargin += viewEventsViewFrameHeight + heightDifference + TOP_MARGIN;
        *postCounter = *postCounter + 1;
    }
    
    [self getDistanceFromCurrentLocationOfEvent:obj];
    
}

/*
 
 Check to see if it is valid to show this event on the screen
 
 */

- (BOOL) isValidToShowEvent : (PFObject *) obj
                   Category : (NSString *) myCategory
                 PostNumber : (int) postCounter
{
    BOOL validated = NO;
    
    if ([myCategory isEqualToString:CATEGORY_TRENDING])
    {
        if (postCounter < 50)
        {
            if ([obj[PARSE_CLASS_EVENT_POST_RANGE] isEqual:@0])
            {
                validated = YES;
            }
            else {
                validated = NO;
            }
        }
    }
    else {
        validated = YES;
    }
    
    return validated;
}

/*
 
 Set up the view events view.  Add the event, and display it properly with its image
 
 */
- (void) setUpViewEventsFrame : (CGFloat) columnOneMargin
                       Margin : (CGFloat) columnTwoMargin
                         Post : (DEPost *) post
                       Column : (int) column
               ViewEventsView : (DEViewEventsView *) view
             HeightDifference : (CGFloat) heightDifference
                    TopMargin : (CGFloat) topMargin

{
    CGFloat margin;
    [[view layer] setCornerRadius:5.0f];
    static double widthMargin = 13;
    
    if (column == 0)
    {
        margin = columnOneMargin;
    }
    else {
        margin = columnTwoMargin;
    }
    
    CGFloat screenSizeRelativeToiPhone5Width = [[UIScreen mainScreen]  bounds].size.width / 320;
    
    CGFloat viewEventsViewHeight = (POST_HEIGHT) + heightDifference;
    CGRect frame = CGRectMake((column * (POST_WIDTH * screenSizeRelativeToiPhone5Width)) + ((widthMargin * screenSizeRelativeToiPhone5Width) * (column + 1)), topMargin + (margin), (POST_WIDTH * screenSizeRelativeToiPhone5Width), viewEventsViewHeight);

    view.frame = frame;
}
/*
 
 Get the difference of height between the label with no description, and the label with the size necessary to fit to the description
 
 */
- (CGFloat) getLabelHeightDifference : (DEViewEventsView *) view {
    // Set the height of the UITextView for the description to the necessary height to fit all the information
    CGSize sizeThatFitsTextView = [[view lblSubtitle] sizeThatFits:CGSizeMake([view lblSubtitle].frame.size.width, 1000)];
    // Get the heightDifference from what it's original size is and what it's size will be
    CGFloat heightDifference = ceilf(sizeThatFitsTextView.height) - [view lblSubtitle].frame.size.height;
    
    return heightDifference;
}

- (CGFloat) getEventImageHeightDifference : (DEViewEventsView *) view {
    if ([[view post].images count] != 0)
    {
        PFFile *file = [view post].images[0];
        if ([file.name containsString:IMAGE_DIMENSION_HEIGHT]) {
            NSRange widthRange = [file.name rangeOfString:IMAGE_DIMENSION_WIDTH];
            NSString *dimensions = [file.name substringFromIndex:widthRange.location];
            NSRange heightRange = [dimensions rangeOfString:IMAGE_DIMENSION_HEIGHT];
            NSString *width = [dimensions substringToIndex:heightRange.location];
            width = [width stringByReplacingOccurrencesOfString:IMAGE_DIMENSION_WIDTH withString:@""];
            NSString *height = [dimensions substringFromIndex:heightRange.location];
            height = [height stringByReplacingOccurrencesOfString:IMAGE_DIMENSION_HEIGHT withString:@""];
            
            double imageWidth = [width doubleValue];
            double imageHeight = [height doubleValue];
            
            return [self resizeViewEventsImageView:view ImageWidth:imageWidth ImageHeight:imageHeight];
        }
    }
    return 0;
}

- (CGFloat) resizeViewEventsImageView : (DEViewEventsView *) view
                        ImageWidth : (double) width
                       ImageHeight : (double) height
{
    CGFloat correctImageViewHeight = (view.imgMainImageView.frame.size.width / width) * height;
    
    if (correctImageViewHeight < view.imageViewHeightConstraint.constant) {
        [view.imgMainImageView setContentMode:UIViewContentModeScaleAspectFill];
    }
    else {
         view.imageViewHeightConstraint.constant = correctImageViewHeight;
    }
    
    return view.imageViewHeightConstraint.constant - view.imgMainImageView.frame.size.height;
}

- (void) getDistanceFromCurrentLocationOfEvent : (PFObject *) event {

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 
 Display the screen to allow the user to post an event
 
 */
- (IBAction)showCreatePostScreen:(id)sender {
    DECreatePostViewController *viewController = [[UIStoryboard storyboardWithName:@"Posting" bundle:nil] instantiateViewControllerWithIdentifier:@"createPostDetailsOne"];
    
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)displayMainMenu:(id)sender {

    if (!menuDisplayed)
    {
        [self showMainMenu];
    }
    else {
        [self hideMainMenu];
    }
}

- (IBAction)goHome:(id)sender {
    
    if (menuDisplayed)
    {
        [viewMainMenu removeFromSuperview];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


#pragma mark - Scroll View Delegate Methods
- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self loadVisiblePost:scrollView];
}

- (void) scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    [self loadVisiblePost:scrollView];
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadVisiblePost:scrollView];
    BOOL scrollDown= NO;
    
    if (scrollView.contentOffset.y > lastContentOffset)
    {
        scrollDown = YES;
    }
    
    if (scrollDown && scrollView.contentOffset.y > scrollView.contentSize.height - 1000)
    {
        [self addEventsToScreen : 0
                   ProcessStatus:nil
                        Category:nil
                       PostArray:_posts
                       ShowBlank:YES];
        
        NSLog(@"Load events again");
    }
    
    lastContentOffset = scrollView.contentOffset.y;
}

- (void) loadVisiblePost : (UIScrollView *) scrollView
{
    for (UIView *view in [scrollView subviews]) {
        if ([view isKindOfClass:[DEViewEventsView class]])
        {
            if (CGRectIntersectsRect(scrollView.bounds, view.frame))
            {
                [((DEViewEventsView *) view) showImage];

            }
            else {
                [((DEViewEventsView *) view) hideImage];
            }
        }
    }
    
}

- (void) searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    _searchPosts = [NSMutableArray new];
    _postsCopy = [_posts copy];
}

- (void) searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [self removeAllPostFromScreen];
    
    for (PFObject *obj in _posts)
    {
        obj[@"loaded"] = @NO;
    }
    
    _isNewProcess = YES;
    [self addEventsToScreen:0
              ProcessStatus:kNOTIFICATION_CENTER_USER_INFO_USER_PROCESS_NEW
                   Category:nil
                  PostArray:_posts
                  ShowBlank:NO];
    [self loadVisiblePost:_scrollView];
}

#pragma mark - Search Bar Delegate Methods
- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self removeAllPostFromScreen];
    
    if (![[searchText stringByReplacingOccurrencesOfString:@" " withString:@"" ] isEqualToString:@""])
    {
        [_posts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            DEPost *post = [DEPost getPostFromPFObject:obj];
            if ([[post.myDescription lowercaseString] rangeOfString:[searchText lowercaseString] ].location != NSNotFound ||
                [[post.title lowercaseString] rangeOfString:[searchText lowercaseString]].location != NSNotFound ||
                [[post.address lowercaseString] rangeOfString:[searchText lowercaseString]].location != NSNotFound ||
                [[post.category lowercaseString] rangeOfString:[searchText lowercaseString]].location != NSNotFound ||
                [[post.quickDescription lowercaseString] rangeOfString:[searchText lowercaseString]].location != NSNotFound
                )
            {
                PFObject *unloadedObject = obj;
                unloadedObject[@"loaded"] = @NO;
                [_searchPosts addObject:unloadedObject];
            }
        }];
        
        _posts = _searchPosts;
        _isNewProcess = YES;
        [self addEventsToScreen:0
                  ProcessStatus:kNOTIFICATION_CENTER_USER_INFO_USER_PROCESS_NEW
                       Category:nil
                      PostArray:_posts
                      ShowBlank:NO];
        [self loadVisiblePost:_scrollView];
        _searchPosts = [NSMutableArray new];
    }
    else {
        _posts = [_postsCopy copy];
        
        for (PFObject *obj in _posts) {
            obj[@"loaded"] = @NO;
        }
        _isNewProcess = YES;
        [self addEventsToScreen:0
                  ProcessStatus:kNOTIFICATION_CENTER_USER_INFO_USER_PROCESS_NEW
                       Category:nil
                      PostArray:_posts
                      ShowBlank:NO];
        [self loadVisiblePost:_scrollView];
    }
}

@end
