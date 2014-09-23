//
//  DEEventDetailsMoreView.m
//  whatsgoinon
//
//  Created by adeiji on 8/15/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import "DEEventDetailsMoreView.h"
#import "Constants.h"

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

- (void) loadView {
    [[self.btnMiscategorized layer] setCornerRadius:BUTTON_CORNER_RADIUS];
    [[self.btnPostSomethingSimilar layer] setCornerRadius:BUTTON_CORNER_RADIUS];
    [[self.btnReportEvent layer] setCornerRadius:BUTTON_CORNER_RADIUS];
}

- (IBAction)postSomethingSimilar:(id)sender {
    UINavigationController *navController = (UINavigationController *)[[[[UIApplication sharedApplication] delegate] window] rootViewController];
        
    DECreatePostViewController *createPostViewController = [[UIStoryboard storyboardWithName:@"Posting" bundle:nil] instantiateInitialViewController];
    
    [navController pushViewController:createPostViewController animated:YES];
}

- (IBAction)reportEvent:(id)sender {

    DEViewReportEvent *viewReportEvent = [[[NSBundle mainBundle] loadNibNamed:@"ViewReportEvent" owner:self options:nil] firstObject];
    [viewReportEvent setEventId:_eventId];
    [viewReportEvent registerForKeyboardNotifications];
    
    CGRect frame = viewReportEvent.frame;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:frame];
    [scrollView setAlwaysBounceVertical:YES];
    [scrollView setContentSize:CGSizeMake(frame.size.width, frame.size.height)];
    [scrollView addSubview:viewReportEvent];
    
    [DEAnimationManager fadeOutWithView:[[self superview] superview] ViewToAdd:scrollView];
}


// Push to the server the fact that this post is miscategorized
- (IBAction)setAsMiscategorized:(id)sender
{
    // Post to the server that this event is miscategorized.
    // Post : Category, Event Id
    [DESyncManager saveEventAsMiscategorizedWithEventId:_eventId Category:_category];
    [DEAnimationManager savedAnimationWithImage:@"miscategorized-indicator-icon.png"];
}


@end
