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
#import <Masonry/Masonry.h>

@interface DEViewEventsViewController ()

@end

#define POST_HEIGHT 278
#define POST_WIDTH 140
#define IPHONE_DEVICE_WIDTH 320
#define TOP_MARGIN 20
#define SCROLL_VIEW_DISTANCE_FROM_TOP 30
#define MAIN_MENU_Y_POS 0

@implementation DEViewEventsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
    //Load the posts first so that we can see how big we need to make the scroll view's content size.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayPost) name:NOTIFICATION_CENTER_ALL_EVENTS_LOADED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showNoInternetConnectionScreen:) name:kReachabilityChangedNotification object:nil];
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
    
    [UIView animateWithDuration:.5f animations:^{
        
        [self.view mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(viewMainMenu.frame.size.width);
            make.top.mas_equalTo(0);
        }];
        
        // Move the main menu over to the right
        CGRect frame = viewMainMenu.frame;
        frame.origin.x = 0;
        viewMainMenu.frame = frame;
    }];
    
    menuDisplayed = YES;
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
    [super viewWillDisappear:animated];
    
    DEScreenManager *screenManager = [DEScreenManager sharedManager];
    UIView *orbView = [[screenManager values] objectForKey:ORB_BUTTON_VIEW];
    
    orbView.hidden = YES;
    self.view.hidden = YES;
    [_scrollView setDelegate:nil];
}

- (void) viewWillAppear:(BOOL)animated {
    
    DEScreenManager *screenManager = [DEScreenManager sharedManager];
    UIView *orbView = [[screenManager values] objectForKey:ORB_BUTTON_VIEW];
    
    orbView.hidden = NO;
    self.view.hidden = NO;
    
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

- (void) showNoInternetConnectionScreen : (NSNotification *) object {
    Reachability *reach = [object valueForKey:@"object"];
    
    if ([reach currentReachabilityStatus] == NotReachable)
    {
        if ([[_scrollView subviews] count] == 2)
        {
            UIView *view = [[[NSBundle mainBundle] loadNibNamed:@"ViewNoInternet" owner:self options:nil] firstObject];
            
            [DEAnimationManager fadeOutWithView:self.view ViewToAdd:view];
            [[DEScreenManager sharedManager] stopActivitySpinner];
        }
    }
}

- (void) displayPost {
    __block int column = 0;
    
    [self loadPosts];
    
    for (UIView *subview in [_scrollView subviews]) {
        [subview removeFromSuperview];
    }
    postCounter = 0;
    //The calculation for the height gets the number of posts divided by two and then adds whatever the remainder is.  This makes sure that if there are for example 9 posts, we make sure that we do POST_HEIGHT * 5, and not 4, because the last post needs to show.
    _scrollView.contentSize = CGSizeMake(IPHONE_DEVICE_WIDTH, ((POST_HEIGHT + TOP_MARGIN) * (([_posts count] / 2) + ([_posts count] % 2))) + SCROLL_VIEW_DISTANCE_FROM_TOP);

    
    [_posts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        DEViewEventsView *viewEventsView = [[[NSBundle mainBundle] loadNibNamed:@"ViewEventsView" owner:self options:nil] objectAtIndex:0];
        
        CGRect frame = CGRectMake((column * POST_WIDTH) + (13 * (column + 1)),(TOP_MARGIN * postCounter) + (POST_HEIGHT * postCounter), POST_WIDTH, POST_HEIGHT);
        viewEventsView.frame = frame;
        DEPost *post = [DEPost getPostFromPFObject:obj];
        
        [viewEventsView renderViewWithPost:post];
        
        [[viewEventsView layer] setCornerRadius:5.0f];
        
        [_scrollView addSubview:viewEventsView];
        
        if (column == 0)
        {
            column = 1;
        }
        else {
            column = 0;
            postCounter ++;
        }
        
        [self getDistanceFromCurrentLocationOfEvent:obj];
    }];
    
    [self loadVisiblePost:_scrollView];
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
- (void) scrollViewDidScroll:(UIScrollView *)scrollView
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
