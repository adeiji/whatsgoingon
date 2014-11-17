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

#define POST_HEIGHT 278
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
    //Load the posts first so that we can see how big we need to make the scroll view's content size.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayPost) name:NOTIFICATION_CENTER_ALL_EVENTS_LOADED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showNoInternetConnectionScreen:) name:kReachabilityChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayPostFromNewCity) name:NOTIFICATION_CENTER_CITY_CHANGED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayNoData) name:NOTIFICATION_CENTER_NO_DATA object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayNoDataInCategory) name:NOTIFICATION_CENTER_NONE_IN_CATEGORY object:nil];
    
    DESelectCategoryView *selectCategoryView = [[[NSBundle mainBundle] loadNibNamed:@"SelectCategoryView" owner:self options:nil] firstObject];
    
    // Add the select category view to the window so that we completely cover the screen including the navigation bar.
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    [selectCategoryView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]];
    [selectCategoryView loadView];
    [window addSubview:selectCategoryView];

    [self resetPostCounter];
    
    // Check to see if this is their first time going to this part of the application
    // If it is their first time then show the welcome screen.
    
    
    // Otherwise go straight to the viewing of the post
    // Add the gesture recognizer which will be used to show and hide the main menu view
    [self addGestureRecognizers];
    
    viewMainMenu = [[[NSBundle mainBundle] loadNibNamed:@"MainMenuView" owner:self options:nil] firstObject];
    [viewMainMenu setUpView];
    DEScreenManager *screenManager = [DEScreenManager sharedManager];
    [screenManager setMainMenu:viewMainMenu];
    [self.view setBackgroundColor:[UIColor clearColor]];
    [self.navigationController setNavigationBarHidden:YES];
    [self.scrollView setDelegate:self];

    [_scrollView removeConstraints:[_scrollView constraints]];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_scrollView.superview.mas_top).offset(74);
        make.left.equalTo(_scrollView.superview.mas_left);
        make.bottom.equalTo(_scrollView.superview.mas_bottom);
        make.right.equalTo(_scrollView.superview.mas_right);
    }];
    
    [_scrollView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self displayPost];
    
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

- (void) showMainMenu
{
    [[[self view] superview] addSubview:viewMainMenu];
    CGRect frame = viewMainMenu.frame;
    frame.origin.y = MAIN_MENU_Y_POS;
    frame.origin.x = -frame.size.width;
    viewMainMenu.frame = frame;

    [self.view mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.offset(viewMainMenu.frame.size.width);
        make.top.offset(0);
    }];
    
    // tell constraints they need updating
    [self.view setNeedsUpdateConstraints];
    // update constraints now so we can animate the change
    [self.view updateConstraintsIfNeeded];
    
    [UIView animateWithDuration:.5f animations:^{
        [self.view layoutIfNeeded];
        // Move the main menu over to the right
        CGRect frame = viewMainMenu.frame;
        frame.origin.x = 0;
        viewMainMenu.frame = frame;
    }];
    
    menuDisplayed = YES;
    [self hideOrbView];
    [[DEScreenManager sharedManager] setMainMenu:viewMainMenu];
}

- (void) hideMainMenu
{
    [UIView animateWithDuration:.5f animations:^{
        [self.view mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(0);
        }];
        
        CGRect frame = viewMainMenu.frame;
        frame.origin.x = -(viewMainMenu.frame.size.width);
        viewMainMenu.frame = frame;
    } completion:^(BOOL finished) {
        [viewMainMenu removeFromSuperview];
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


- (void) viewWillDisappear:(BOOL)animated {
    
    DEScreenManager *screenManager = [DEScreenManager sharedManager];
    UIView *orbView = [[screenManager values] objectForKey:ORB_BUTTON_VIEW];
    
    orbView.hidden = YES;
    self.view.hidden = YES;
    [_scrollView setDelegate:nil];
    
    [super viewWillDisappear:animated];

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

- (void) viewWillAppear:(BOOL)animated {
    
    [self showOrbView];
    self.view.hidden = NO;
    [_scrollView setDelegate:self];

    
    [super viewWillAppear:animated];
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    for (__strong UIView *view in [_scrollView subviews]) {
        view = nil;
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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

- (void) displayNoData
{
    UIView *view = [[[NSBundle mainBundle] loadNibNamed:@"ViewEventsView" owner:self options:nil] lastObject];
    [_scrollView addSubview:view];
    [self loadPosts];
    [self setUpScrollViewForPostsWithTopMargin:view.frame.size.height + 15];
    [self addEventsToScreen : view.frame.size.height + 15];
    [self loadVisiblePost:_scrollView];
    
    DEScreenManager *screenManager = [DEScreenManager sharedManager];
    UIView *orbView = [[screenManager values] objectForKey:ORB_BUTTON_VIEW];
    
    orbView.hidden = YES;
}

- (void) displayNoDataInCategory
{
    for (UIView *subview in [_scrollView subviews]) {
        [subview removeFromSuperview];
    }
    
    UIView *view = [[[NSBundle mainBundle] loadNibNamed:@"SelectCategoryView" owner:self options:nil] lastObject];
    [_scrollView addSubview:view];
    [self showOrbView];
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

- (void) displayPost {
    
    [self loadPosts];
    
    for (UIView *subview in [_scrollView subviews]) {
        [subview removeFromSuperview];
    }
    
    [self setUpScrollViewForPostsWithTopMargin:0];
    [self addEventsToScreen : 0];
    [self loadVisiblePost:_scrollView];
    
    [self showOrbView];
}

- (void) setUpScrollViewForPostsWithTopMargin : (NSInteger) topMargin
{
    //The calculation for the height gets the number of posts divided by two and then adds whatever the remainder is.  This makes sure that if there are for example 9 posts, we make sure that we do POST_HEIGHT * 5, and not 4, because the last post needs to show.
    _scrollView.contentSize = CGSizeMake(IPHONE_DEVICE_WIDTH, topMargin + ((POST_HEIGHT + TOP_MARGIN) * (([_posts count] / 2) + ([_posts count] % 2))) + SCROLL_VIEW_DISTANCE_FROM_TOP);
}

- (void) addEventsToScreen : (NSInteger) topMargin
{
    __block int column = 0;
    postCounter = 0;
    __block CGFloat columnOneMargin = 0;
    __block CGFloat columnTwoMargin = 0;
    __block CGFloat margin = 0;
    
    [_posts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        DEViewEventsView *viewEventsView = [[[NSBundle mainBundle] loadNibNamed:@"ViewEventsView" owner:self options:nil] objectAtIndex:0];
        DEPost *post = [DEPost getPostFromPFObject:obj];
        
        [viewEventsView renderViewWithPost:post];
        [[viewEventsView layer] setCornerRadius:5.0f];
    
        // Set the height of the UITextView for the description to the necessary height to fit all the information
        CGSize sizeThatFitsTextView = [[viewEventsView lblSubtitle] sizeThatFits:CGSizeMake([viewEventsView lblSubtitle].frame.size.width, 1000)];
        CGFloat heightDifference =  ceilf(sizeThatFitsTextView.height) - [viewEventsView lblSubtitle].frame.size.height;

        if (column == 0)
        {
            margin = columnOneMargin + (TOP_MARGIN * postCounter) + (POST_HEIGHT * postCounter);
        }
        else {
            margin = columnTwoMargin + (TOP_MARGIN * postCounter) + (POST_HEIGHT * postCounter);
        }
        
        CGRect frame = CGRectMake((column * POST_WIDTH) + (13 * (column + 1)), topMargin + margin, POST_WIDTH, POST_HEIGHT + heightDifference);
        viewEventsView.frame = frame;
        
        frame = viewEventsView.lblSubtitle.frame;
        frame.size.height += heightDifference;
        [[viewEventsView lblSubtitle] setFrame:frame];

        [_scrollView addSubview:viewEventsView];
    
        if (column == 0)
        {
            column = 1;
            columnOneMargin += heightDifference;
        }
        else {
            column = 0;
            columnTwoMargin += heightDifference;
            postCounter ++;
        }
        
        [self getDistanceFromCurrentLocationOfEvent:obj];
    }];
}


- (void) getDistanceFromCurrentLocationOfEvent : (PFObject *) event {

}

- (void) resetPostCounter {
    postCounter = 0;
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
            if (CGRectIntersectsRect(scrollView.bounds, view.frame) && ![((DEViewEventsView *) view) isImageLoaded])
            {
                [((DEViewEventsView *) view) loadImage];
            }
        }
    }
    
}

@end
