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

@implementation DEViewEventsViewController

struct TopMargin {
    int column;
    int height;
};

- (void) addObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayPost:) name:NOTIFICATION_CENTER_ALL_EVENTS_LOADED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showNoInternetConnectionScreen:) name:kReachabilityChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayPostFromNewCity) name:NOTIFICATION_CENTER_CITY_CHANGED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayPastEpicEvents:) name:NOTIFICATION_CENTER_NO_DATA object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayNoDataInCategory:) name:NOTIFICATION_CENTER_NONE_IN_CATEGORY object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayUserSavedEvents:) name:NOTIFICATION_CENTER_SAVED_EVENTS_LOADED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayNoSavedEvents) name:NOTIFICATION_CENTER_NO_SAVED_EVENTS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeAllPostFromScreen) name:kNOTIFICATION_CENTER_USER_INFO_USER_PROCESS_NEW object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayPastEpicEvents:) name:NOTIFICATION_CENTER_PAST_EPIC_EVENTS_LOADED object:nil];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //Load the posts first so that we can see how big we need to make the scroll view's content size.
    [self addObservers];
    
    if (!_shouldNotDisplayPosts)
    {
        if (_now)
        {
            [DESyncManager getAllValuesForNow:YES];
        }
        else {
            [DESyncManager getAllValuesForNow:NO];
        }
    }
    
    
    DESelectCategoryView *selectCategoryView = [[[NSBundle mainBundle] loadNibNamed:@"SelectCategoryView" owner:self options:nil] firstObject];
    
    // Add the select category view to the window so that we completely cover the screen including the navigation bar.
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    [selectCategoryView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]];
    [selectCategoryView loadView];
    [window addSubview:selectCategoryView];
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
    
    DEScreenManager *screenManager = [DEScreenManager sharedManager];
    UIView *orbView = [[screenManager values] objectForKey:ORB_BUTTON_VIEW];
    
    orbView.hidden = YES;
    self.view.hidden = YES;
    [_scrollView setDelegate:nil];
}

- (void) viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
    [self.view setHidden:YES];
    [self.scrollView removeFromSuperview];
    [self hideOrbView];
    
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.scrollView setDelegate:self];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self showOrbView];
    self.view.hidden = NO;
    
    if (menuDisplayed && ![[[DEScreenManager sharedManager] mainMenu] superview])
    {
        DEScreenManager *screenManager = [DEScreenManager sharedManager];
        [[self view] addSubview:[screenManager mainMenu]];
        [[[DEScreenManager sharedManager] mainMenu] setHidden:NO];
        [self hideOrbView];
    }
    
    if (![_scrollView superview])
    {
        [_containerView addSubview:_scrollView];
        [_scrollView setTranslatesAutoresizingMaskIntoConstraints:YES];
    }
}

- (void) hideOrbView
{
    DEScreenManager *screenManager = [DEScreenManager sharedManager];
    UIView *orbView = [[screenManager values] objectForKey:ORB_BUTTON_VIEW];
    
    orbView.hidden = YES;
}

- (void) showOrbView
{
    DEScreenManager *screenManager = [DEScreenManager sharedManager];
    UIView *orbView = [[screenManager values] objectForKey:ORB_BUTTON_VIEW];
    
    orbView.hidden = NO;
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
    
    CGRect frame = view.frame;
    frame.size.width = _scrollView.frame.size.width;
    [view setFrame:frame];
    
    [_scrollView addSubview:view];
    [self loadPosts];
    [self addEventsToScreen : view.frame.size.height + 15
               ProcessStatus:kNOTIFICATION_CENTER_USER_INFO_USER_PROCESS_FINISHED_LOADING
                    Category:nil
                   PostArray:_posts
                   ShowBlank:YES];
    [self setUpScrollViewForPostsWithTopMargin:view.frame.size.height + 15];
    [self loadVisiblePost:_scrollView];
    
    DEScreenManager *screenManager = [DEScreenManager sharedManager];
    UIView *orbView = [[screenManager values] objectForKey:ORB_BUTTON_VIEW];
    
    orbView.hidden = YES;
}

- (void) displayNoDataInCategory : (NSNotification *) notification
{
    if (notification.userInfo[kNOTIFICATION_CENTER_USER_INFO_CATEGORY])
    {
        [self displayCategory:notification.userInfo[kNOTIFICATION_CENTER_USER_INFO_CATEGORY]];
    }
    
    for (UIView *subview in [_scrollView subviews]) {
        [subview removeFromSuperview];
    }
    
    UIView *view = [[[NSBundle mainBundle] loadNibNamed:@"SelectCategoryView" owner:self options:nil] lastObject];
    [_scrollView addSubview:view];
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
    
    for (UIView *subview in [_scrollView subviews]) {
        if ([subview isKindOfClass:[DEViewEventsView class]])
        {
            ((DEViewEventsView *) subview).imgMainImageView.image = nil;
            [subview removeFromSuperview];
        }
        
        [subview removeFromSuperview];
    }
}

- (void) displayPost : (NSNotification *) notification {
    
    if (notification.userInfo[kNOTIFICATION_CENTER_USER_INFO_CATEGORY] && notification.userInfo[kNOTIFICATION_CENTER_USER_INFO_USER_PROCESS])
    {
        [self displayCategory:notification.userInfo[kNOTIFICATION_CENTER_USER_INFO_CATEGORY]];
        category = notification.userInfo[kNOTIFICATION_CENTER_USER_INFO_CATEGORY];
    }
    
    [self loadPosts];
    [self addEventsToScreen : 0
               ProcessStatus:notification.userInfo[kNOTIFICATION_CENTER_USER_INFO_USER_PROCESS]
                    Category:notification.userInfo[kNOTIFICATION_CENTER_USER_INFO_CATEGORY]
                   PostArray:_posts
                   ShowBlank:YES];
    [self loadVisiblePost:_scrollView];
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
    [self addEventsToScreen:0
              ProcessStatus:kNOTIFICATION_CENTER_USER_INFO_USER_PROCESS_FINISHED_LOADING Category:nil
                  PostArray:postArray
                  ShowBlank:YES];
    [self loadVisiblePost:_scrollView];
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

- (void) addEventsToScreen : (NSInteger) topMargin
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
    
    validated = NO;

    [postArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
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
            
            NSLog(@"Column One Margin: %f", columnOneMargin);
            NSLog(@"Column Two Margin: %f", columnTwoMargin);
            NSLog(@"Margin: %f", margin);
            NSLog(@"Post Counter: %i", postCounter);
        }
    }];
    
    // Add the column one or column two margin, depending on which is greater to the height of the scroll view's content size
    if (columnOneMargin > columnTwoMargin)
    {
        scrollViewContentSizeHeight += (columnOneMargin * screenSizeRelativeToiPhone5Width);
    }
    else {
        scrollViewContentSizeHeight += (columnTwoMargin * screenSizeRelativeToiPhone5Width);
    }
    
    CGSize size = _scrollView.contentSize;
    size.height = scrollViewContentSizeHeight;
    [_scrollView setContentSize:size];

    // If we've finished loading all the events then we reset everything back to zero so that next time we load events it will show them correctly
    if ([process isEqualToString:kNOTIFICATION_CENTER_USER_INFO_USER_PROCESS_FINISHED_LOADING])
    {
        column = 0;
        postCounter = 1;
        columnOneMargin = 0;
        columnTwoMargin = 0;
        margin = 0;
        scrollViewContentSizeHeight = 0;
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
    UIView *view = [[[NSBundle mainBundle] loadNibNamed:@"ViewEventsView" owner:self options:nil] lastObject];
    [_scrollView addSubview:view];
    [_scrollView setContentSize:view.frame.size];
    DEScreenManager *screenManager = [DEScreenManager sharedManager];
    UIView *orbView = [[screenManager values] objectForKey:ORB_BUTTON_VIEW];
    
    orbView.hidden = YES;
}

/*
 
 Load the event
 
 */

- (void) loadEvent : (PFObject *) obj
           Margin1 : (CGFloat *) columnOneMargin
           Margin2 : (CGFloat *) columnTwoMargin
            Column : (CGFloat *) column
         TopMargin : (NSInteger) topMargin
       PostCounter : (int *) postCounter
         ShowBlank : (BOOL) showBlank
{
    CGFloat viewEventsViewFrameHeight = POST_HEIGHT;
    DEPost *post = [DEPost getPostFromPFObject:obj];
    obj[@"loaded"] = @YES;
    
    DEViewEventsView *viewEventsView = [[[NSBundle mainBundle] loadNibNamed:@"ViewEventsView" owner:self options:nil] objectAtIndex:0];
    
    [viewEventsView renderViewWithPost:post
                             ShowBlank:showBlank];
    [viewEventsView setPostObject:obj];

    
    CGFloat heightDifference = [self getLabelHeightDifference:viewEventsView];
    
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
    
    CGFloat viewEventsViewHeight = (POST_HEIGHT * screenSizeRelativeToiPhone5Width) + heightDifference;
    CGRect frame = CGRectMake((column * (POST_WIDTH * screenSizeRelativeToiPhone5Width)) + ((widthMargin * screenSizeRelativeToiPhone5Width) * (column + 1)), topMargin + (margin * screenSizeRelativeToiPhone5Width), (POST_WIDTH * screenSizeRelativeToiPhone5Width), viewEventsViewHeight);
    
    view.frame = frame;
    // Set up the Subtitle frame
    frame = [[view lblSubtitle ] frame];
    frame.size.height += heightDifference;
    [[view lblSubtitle] setFrame:frame];
}
/*
 
 Get the difference of height between the label with no description, and the label with the size necessary to fit to the description
 
 */
- (CGFloat) getLabelHeightDifference : (DEViewEventsView *) view {
    // Set the height of the UITextView for the description to the necessary height to fit all the information
    CGSize sizeThatFitsTextView = [[view lblSubtitle] sizeThatFits:CGSizeMake([view lblSubtitle].frame.size.width, 1000)];
    // Get the heightDifference from what it's original size is and what it's size will be
    CGFloat heightDifference = ceilf(sizeThatFitsTextView.height) - [view lblSubtitle].frame.size.height;
    
    NSLog(@"The height difference for the label is: %f", heightDifference);
    return heightDifference;
}

- (void) getDistanceFromCurrentLocationOfEvent : (PFObject *) event {

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Display the main menu on the current screen

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
        }
    }
    
}

- (void) searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    
    _searchPosts = [NSMutableArray new];
}

- (void) searchBarTextDidEndEditing:(UISearchBar *)searchBar
{

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

        [self addEventsToScreen:0
                  ProcessStatus:kNOTIFICATION_CENTER_USER_INFO_USER_PROCESS_FINISHED_LOADING
                       Category:nil
                      PostArray:_searchPosts
                      ShowBlank:NO];
        [self loadVisiblePost:_scrollView];
        _searchPosts = [NSMutableArray new];
    }
    else {
        for (PFObject *obj in _posts) {
            obj[@"loaded"] = @NO;
        }
        
        [self addEventsToScreen:0
                  ProcessStatus:kNOTIFICATION_CENTER_USER_INFO_USER_PROCESS_FINISHED_LOADING
                       Category:nil
                      PostArray:_posts
                      ShowBlank:NO];
        [self loadVisiblePost:_scrollView];
    }
}

@end
