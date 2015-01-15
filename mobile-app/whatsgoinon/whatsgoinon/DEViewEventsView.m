//
//  DEViewEvents.m
//  whatsgoinon
//
//  Created by adeiji on 8/5/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import "DEViewEventsView.h"
#import <Parse/Parse.h>

@implementation DEViewEventsView

#define OVERLAY_VIEW 1

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    
    return self;
}

- (void) setUpOverlayViewWithSuperview : (DEViewEventsView *) eventView
{
    [eventView.overlayView setFrame:eventView.imgMainImageView.frame];
    
    if ([DEPostManager isBeforeEvent:eventView.post])
    {
        [[eventView.overlayView lblEndsInStartsIn] setText:@"Starts In"];
        [[eventView.overlayView lblTimeUntilStartsOrEnds] setTextColor:[UIColor colorWithRed:0.0f green:172.0f/255.0f blue:238.0f/255.0f alpha:1.0f]];
        NSNumber *hours = [DEPostManager getDurationOfEvent:eventView.post];
        NSNumberFormatter *formatter = [NSNumberFormatter new];
        [formatter setFormatterBehavior:NSNumberFormatterBehaviorDefault];
        
        NSString *timeString = [NSString stringWithFormat:@"Duration: %@ hr(s)", [formatter stringFromNumber:hours]];
        
        [[eventView.overlayView lblDuration] setText:timeString];
    }
    else
    {
        [[eventView.overlayView lblEndsInStartsIn] setText:@"Ends In"];
        [[eventView.overlayView lblTimeUntilStartsOrEnds] setTextColor:[UIColor colorWithRed:66.0f/255.0f green:188.0f/255.0f blue:98.0f/255.0f alpha:1.0f]];
    }
    
    [[eventView.overlayView lblTimeUntilStartsOrEnds] setText:[DEPostManager getTimeUntilStartOrFinishFromPost:eventView.post]];
}

- (void) showOverlayView : (UILongPressGestureRecognizer *) sender {
    
    NSArray *allViews = [[super superview] subviews];
    DEScreenManager *screenManager = [DEScreenManager sharedManager];
    
    //Get all the sibling DEEventTimeline views and display them on the screen
    for (UIView *superView in allViews) {
        for (UIView *view in [superView subviews]) {
            if ([view isKindOfClass:[DEEventsTimeline class]])
            {
                DEEventsTimeline *overlayView = (DEEventsTimeline *) view;
                [self setUpOverlayViewWithSuperview:(DEViewEventsView *)[overlayView superview]];

                if (sender.state == UIGestureRecognizerStateBegan)
                {
                    [UIView animateWithDuration:.3 animations:^{
                        [[overlayView layer] setOpacity:.8];
                        [screenManager setOverlayDisplayed:YES];
                    }];
                }
                else if (sender.state == UIGestureRecognizerStateEnded)
                {
                    [UIView animateWithDuration:.3 animations:^{
                        [[overlayView layer] setOpacity:0];
                        [screenManager setOverlayDisplayed:NO];
                    }];
                }
            }
        }
    }
}

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void) displayDistanceToLocationWithPost : (DEPost *) post
{
    DELocationManager *locationManager = [DELocationManager sharedManager];

    [DELocationManager getDistanceInMilesBetweenLocation:post.location LocationTwo:[locationManager currentLocation] CompletionBlock:^(NSString *value) {
        
        NSString *valueWithoutCharacters = [value stringByReplacingOccurrencesOfString:@"," withString:@""];
        valueWithoutCharacters = [valueWithoutCharacters stringByReplacingOccurrencesOfString:@" mi" withString:@""];
        
        if ([valueWithoutCharacters doubleValue] > 1000)
        {
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            [formatter setPositiveFormat:@"0.#"];
            double miles = [valueWithoutCharacters doubleValue] / 1000;
            NSString *distanceInShortFormat = [NSString stringWithFormat:@"%@k mi", [formatter stringFromNumber:[NSNumber numberWithDouble:miles]]];
            self.lblDistance.text = distanceInShortFormat;
        }
        else {
            self.lblDistance.text = value;
        }
    }];
}


- (void) addGestureRecognizers
{
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showOverlayView:)];
    longPressGestureRecognizer.minimumPressDuration = .2;
    longPressGestureRecognizer.delegate = self;
    [self addGestureRecognizer:longPressGestureRecognizer];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(displayEventDetails:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    tapGestureRecognizer.delegate = self;
    [self addGestureRecognizer:tapGestureRecognizer];
}

- (void) renderViewWithPost : (DEPost *) myPost
                  ShowBlank : (BOOL) showBlank {

    __block DEPost *post = myPost;
    
    [self addGestureRecognizers];
    
    _overlayView = [[[NSBundle mainBundle] loadNibNamed:@"ViewEventsView" owner:self options:nil] objectAtIndex:OVERLAY_VIEW];
    [_overlayView setFrame:CGRectMake(0, 0, 140, 140)];
    [self addSubview:_overlayView];
    [[_overlayView layer] setOpacity:0];
    [self loadImage];
    if (showBlank)
    {
        [self.imgMainImageView setAlpha:0.0];
    }
    else {
        [self.imgMainImageView setAlpha:1.0];
    }
    
    self.lblNumGoing.text = [NSString stringWithFormat:@"%@", post.numberGoing];
    self.lblTitle.text = post.title;
    self.lblAddress.text = post.address;
    self.lblSubtitle.text = post.quickDescription;
    self.lblViewCount.text = [post.viewCount stringValue];
    [self displayDistanceToLocationWithPost : post];
    
    _post = myPost;
}

- (void) hideImage {
    // Set the alpha to zero so that we still have the cool fade in affect when the user comes back to this post
    [self.imgMainImageView setAlpha:0.0f];
}

- (void) showImage {
    [UIView animateWithDuration:0.5f animations:^{
        [self.imgMainImageView setAlpha:1.0f];
    }];
}

- (void) loadImage
{
    dispatch_async(dispatch_get_main_queue(), ^{
        // Load the images on the main thread asynchronously
        // Make sure that this post actually has an image
        if ([_post.images count] != 0)
        {
            PFFile *imageFile = _post.images[0];
            
            [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                
                @autoreleasepool {
                    NSData *imageData = data;
                    UIImage *image = [UIImage imageWithData:imageData];
                    self.imgMainImageView.image = image;
                    image = nil;
                }
            }];
        }
        else { // If there is no image related to this event then use our placeholder image
            UIImage *image = ImageWithPath(ResourcePath(@"happ-snap-logo-in-app.png"));
            self.imgMainImageView.image = image;
            
            image = nil;
        }
    });

}
// Increment the number of views by one for this post
- (void) updateViewCount {
    //Every time the user clicks on the event, we update its view count
    NSInteger viewCount = [_post.viewCount integerValue];
    viewCount ++;
    _post.viewCount = [NSNumber numberWithInteger:viewCount];
    _postObject[PARSE_CLASS_EVENT_VIEW_COUNT] = _post.viewCount;
    // We can't save this as loaded to the server, otherwise it won't load again
    _postObject[@"loaded"] = @NO;
    [DESyncManager saveUpdatedPFObjectToServer:_postObject];
    _postObject[@"loaded"] = @YES;
    self.lblViewCount.text = [_post.viewCount stringValue];
}

// When the user taps this event it will take them to a screen to view all the details of the event.
- (void) displayEventDetails : (id) sender {
    [self updateViewCount];
    
    UINavigationController *navigationController = (UINavigationController *)[[[[UIApplication sharedApplication] delegate] window] rootViewController];
    
    DEEventViewController *eventViewController = [[UIStoryboard storyboardWithName:@"Event" bundle:nil] instantiateViewControllerWithIdentifier:@"viewEvent"];
    eventViewController.post = _post;
    eventViewController.isPreview = NO;
    eventViewController.viewEventView = self;
    [[DEPostManager sharedManager] setCurrentPost:_post];
    [[DEPostManager sharedManager] setDistanceFromEvent:self.lblDistance.text];
    
    [navigationController pushViewController:eventViewController animated:YES];
    
    // If this event is already saved as going, then we need to display that in the view.
    if ([[[DEPostManager sharedManager] goingPost] containsObject:_post.objectId])
    {
        eventViewController.isGoing = YES;
    }
    else if ([[[DEPostManager sharedManager] maybeGoingPost] containsObject:_post.objectId])
    {
        eventViewController.isMaybeGoing = YES;
    }
    

}

@end
