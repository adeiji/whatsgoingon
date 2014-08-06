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
    
    [self displayPost];
}

- (void) displayPost {
    DEPostManager *postManager = [DEPostManager sharedManager];
    NSArray *posts = [postManager posts];
    DEViewEventsView *viewEventsView = [[[NSBundle mainBundle] loadNibNamed:@"ViewEventsView" owner:self options:nil] objectAtIndex:0];
    
    CGRect frame = CGRectMake(0, 0, 100, 200);
    viewEventsView.frame = frame;
    
    [posts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [viewEventsView renderViewWithPost:obj];
        
        [_scrollView addSubview:viewEventsView];
    
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
