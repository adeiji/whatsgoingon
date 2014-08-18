//
//  DEEventDetailsMoreView.m
//  whatsgoinon
//
//  Created by adeiji on 8/15/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import "DEEventDetailsMoreView.h"

@implementation DEEventDetailsMoreView

#define NAVIGATION_BAR_HEIGHT 50

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (IBAction)postSomethingSimilar:(id)sender {
    UINavigationController *navController = (UINavigationController *)[[[[UIApplication sharedApplication] delegate] window] rootViewController];
    
    DECreatePostViewController *createPostViewController = [[UIStoryboard storyboardWithName:@"Posting" bundle:nil] instantiateInitialViewController];
    
    [navController pushViewController:createPostViewController animated:YES];
}

- (IBAction)reportEvent:(id)sender {

    DEViewReportEvent *viewReportEvent = [[[NSBundle mainBundle] loadNibNamed:@"ViewReportEvent" owner:self options:nil] firstObject];
    [viewReportEvent setEventId:_eventId];
    
    CGRect frame = viewReportEvent.frame;
    
    frame.origin.x = ([[UIScreen mainScreen] bounds].size.width - frame.size.width) / 2;
    frame.origin.y = ([[UIScreen mainScreen] bounds].size.height - frame.size.height) / 2 - NAVIGATION_BAR_HEIGHT;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:frame];
    [scrollView setAlwaysBounceVertical:YES];
    [scrollView setContentSize:CGSizeMake(frame.size.width, frame.size.height)];
    [scrollView addSubview:viewReportEvent];
    [[[self superview] superview] addSubview:scrollView];
}

// Push to the server the fact that this post is miscategorized
- (IBAction)setAsMiscategorized:(id)sender
{
    
}
@end
