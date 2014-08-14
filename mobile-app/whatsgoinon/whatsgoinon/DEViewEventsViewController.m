//
//  DEViewEventsViewController.m
//  whatsgoinon
//
//  Created by adeiji on 8/5/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import "DEViewEventsViewController.h"
#import "Constants.h"

@interface DEViewEventsViewController ()

@end

#define POST_HEIGHT 216
#define POST_WIDTH 140
#define IPHONE_DEVICE_WIDTH 320
#define TOP_MARGIN 20
#define SCROLL_VIEW_DISTANCE_FROM_TOP 20

@implementation DEViewEventsViewController

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
	// Do any additional setup after loading the view.
    
    //Load the posts first so that we can see how big we need to make the scroll view's content size.
    [self loadPosts];
    //The calculation for the height gets the number of posts divided by two and then adds whatever the remainder is.  This makes sure that if there are for example 9 posts, we make sure that we do POST_HEIGHT * 5, and not 4, because the last post needs to show.
    _scrollView.contentSize = CGSizeMake(IPHONE_DEVICE_WIDTH, POST_HEIGHT * (([_posts count] / 2) + ([_posts count] % 2)) + SCROLL_VIEW_DISTANCE_FROM_TOP);
    
    DESelectCategoryView *selectCategoryView = [[[NSBundle mainBundle] loadNibNamed:@"SelectCategoryView" owner:self options:nil] firstObject];
    
    // Add the select category view to the window so that we completely cover the screen including the navigation bar.
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    [selectCategoryView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]];
    [selectCategoryView loadView];
    [window addSubview:selectCategoryView];

    [self resetPostCounter];
    [self displayPost];
    
    // Check to see if this is their first time going to this part of the application
    
    // If it is their first time then show the welcome screen.
    
    
    // Otherwise go straight to the viewing of the post
    
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    for (__strong UIView *view in [_scrollView subviews]) {
        view = nil;
    }
}

- (void) loadPosts {
    _posts = [[DEPostManager sharedManager] posts];
}

- (void) displayPost {
    __block int column = 0;
    
    [_posts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        DEViewEventsView *viewEventsView = [[[NSBundle mainBundle] loadNibNamed:@"ViewEventsView" owner:self options:nil] objectAtIndex:0];
        
        CGRect frame = CGRectMake((column * POST_WIDTH) + (10 * (column + 1)),TOP_MARGIN + POST_HEIGHT * postCounter, POST_WIDTH, POST_HEIGHT);
        viewEventsView.frame = frame;
        DEPost *post = [DEPost getPostFromPFObject:obj];
        
        [viewEventsView renderViewWithPost:post];
        
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

@end