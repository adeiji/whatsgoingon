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
    
    if ([[DEUserManager sharedManager] isLoggedIn])
    {
        DECreatePostViewController *createPostViewController = [[UIStoryboard storyboardWithName:@"Posting" bundle:nil] instantiateInitialViewController];
        createPostViewController.isPostSomethingSimilar = YES;
        [navController pushViewController:createPostViewController animated:YES];
        
        DEPost *post = [[DEPostManager sharedManager] currentPost];
        // Make a copy of the post so that we can reference the original post in order to get the images back
        createPostViewController.originalPost = [post copy];
        
        // Set the images to nil so that the images do not show up in the new post that the user is creating
        post.images = nil;
        // Get all the categories
        NSMutableDictionary *plistData = [[NSMutableDictionary alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"categories" ofType:@"plist"]];
        
        NSArray *categories = [plistData allKeys];
        NSInteger indexOfCategory = 0;
        for (NSString *category in categories) {
            if ([category isEqualToString:post.categoryStr])
            {
                break;
            }
            
            indexOfCategory ++;
        }
    }
    else
    {
        DELoginViewController *loginViewController = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:PROMPT_LOGIN_VIEW_CONTROLLER];
        
        loginViewController.posting = YES;
        [[DEScreenManager getMainNavigationController] pushViewController:loginViewController animated:YES];
    }
}

- (IBAction)reportEvent:(id)sender {

    DEViewReportEvent *viewReportEvent = [[[NSBundle mainBundle] loadNibNamed:@"ViewReportEvent" owner:self options:nil] firstObject];
    [viewReportEvent setEventId:_eventId];
    [viewReportEvent registerForKeyboardNotifications];
    CGRect frame = [[UIScreen mainScreen] bounds];
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:frame];
    
    frame = viewReportEvent.frame;
    frame.size.height = scrollView.frame.size.height;
    frame.size.width = scrollView.frame.size.width;
    [viewReportEvent setFrame:frame];
    [scrollView setAlwaysBounceVertical:YES];
    [scrollView setContentSize:CGSizeMake(frame.size.width, frame.size.height)];
    [scrollView addSubview:viewReportEvent];
    
    [DEAnimationManager fadeOutWithView:[[self superview] superview] ViewToAdd:scrollView];
    [viewReportEvent updateView];
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
