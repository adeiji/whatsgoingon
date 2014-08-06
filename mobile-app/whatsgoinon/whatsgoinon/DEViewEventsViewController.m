//
//  DEViewEventsViewController.m
//  whatsgoinon
//
//  Created by adeiji on 8/5/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import "DEViewEventsViewController.h"


@interface DEViewEventsViewController ()

@end

#define POST_HEIGHT 216
#define POST_WIDTH 140
#define IPHONE_DEVICE_WIDTH 320

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
    
    _scrollView.contentSize = CGSizeMake(IPHONE_DEVICE_WIDTH, POST_HEIGHT * [_posts count]);
    
    [self resetPostCounter];
    [self loadPosts];
    [self displayPost];
}

- (void) loadPosts {
    _posts = [[DEPostManager sharedManager] posts];
}

- (void) displayPost {
    
    [_posts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        DEViewEventsView *viewEventsView = [[[NSBundle mainBundle] loadNibNamed:@"ViewEventsView" owner:self options:nil] objectAtIndex:0];
        
        CGRect frame = CGRectMake(0, POST_HEIGHT * postCounter, POST_WIDTH, POST_HEIGHT);
        viewEventsView.frame = frame;
        [viewEventsView renderViewWithPost:obj];
        
        [_scrollView addSubview:viewEventsView];
        postCounter ++;
    }];
    
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
