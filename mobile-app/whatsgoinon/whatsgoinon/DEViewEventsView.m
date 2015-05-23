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
const int POST_WIDTH = 140;

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
    
    // If the event is 3 hours before the event, then we simply display as normal
    
    CGRect frame = _overlayView.frame;
    frame.size.width = eventView.frame.size.width;
    frame.origin.y = eventView.imgMainImageView.frame.size.height - 24;
    [_overlayView setFrame:frame];
    
    if ([[eventView.post startTime] compare:[NSDate date]] == NSOrderedDescending)
    {
        if ([DEPostManager isLessThanThreeHoursBeforeEvent:eventView.post])
        {
            [self displayOverlayViewForEventInLessThanThreeHoursFromNowWithView:eventView];
        }
        else if (![DEPostManager isLessThanThreeHoursBeforeEvent:eventView.post]) {
            [self displayOverlayViewForEventInMoreThanThreeHoursFromNowWithView:eventView];
        }
    }
    else if (([[eventView.post startTime] compare:[NSDate date]] == NSOrderedAscending) && ([[eventView.post endTime] compare:[NSDate date]] == NSOrderedDescending))
    {
        NSString *timeUntilStartOrFinishFromPost = [DEPostManager getTimeUntilStartOrFinishFromPost:eventView.post isOverlayView:YES];
        [[eventView.overlayView lblEndsInStartsIn] setText:[NSString stringWithFormat:@"Ends In %@", timeUntilStartOrFinishFromPost]];
        
        NSDateFormatter *df = [NSDateFormatter new];
        [df setDateFormat:@"h:mm a"];
    }
    else {
        [[eventView.overlayView lblEndsInStartsIn] setText:@"DONE"];
    }
}


- (void) displayOverlayViewForEventInLessThanThreeHoursFromNowWithView : (DEViewEventsView *) eventView {
    NSDateFormatter *df = [NSDateFormatter new];
    [df setDateFormat:@"h:mm a"];
    NSAttributedString *timeUntilStartOrFinishFromPost = [[NSAttributedString alloc] initWithString:[DEPostManager getTimeUntilStartOrFinishFromPost:eventView.post isOverlayView:YES]  attributes:@{ NSForegroundColorAttributeName : [HPStyleKit greenColor] }] ;
    NSMutableAttributedString *timeDisplay = [[NSMutableAttributedString alloc] initWithString:@"Starts in "];
    [timeDisplay appendAttributedString:timeUntilStartOrFinishFromPost];
    [[eventView.overlayView lblEndsInStartsIn] setAttributedText:timeDisplay];
}

- (void) displayDayOfWeekWithView : (DEViewEventsView *) eventView {

}

- (void) displayOverlayViewForEventInMoreThanThreeHoursFromNowWithView : (DEViewEventsView *) eventView {
    [self displayDayOfWeekWithView:eventView];
    NSDateFormatter *df = [NSDateFormatter new];
    [df setDateFormat:@"h:mm a"];
    NSTimeZone *timeZone = [NSTimeZone defaultTimeZone];
    [df setTimeZone:timeZone];
    NSString *dayOfWeek = [DEPostManager getDayOfWeekFromPost:eventView.post];
    NSString *myStartTime = [df stringFromDate:eventView.post.startTime];
    NSAttributedString *startTime = [[NSAttributedString alloc] initWithString:myStartTime attributes:@{ NSForegroundColorAttributeName : [HPStyleKit blueColor] }];
    NSMutableAttributedString *timeDisplay = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"Starts %@ @ ", dayOfWeek]];
    [timeDisplay appendAttributedString:startTime];
    [[eventView.overlayView lblEndsInStartsIn] setAttributedText:timeDisplay];
}

- (void) showOverlayView {
    
    NSArray *allViews = [self subviews];
    DEScreenManager *screenManager = [DEScreenManager sharedManager];
    
    //Get all the sibling DEEventTimeline views and display them on the screen
    for (UIView *view in allViews) {
        if ([view isKindOfClass:[DEEventsTimeline class]])
        {
            DEEventsTimeline *overlayView = (DEEventsTimeline *) view;
            [self setUpOverlayViewWithSuperview:(DEViewEventsView *)[overlayView superview]];
            [UIView animateWithDuration:.3 animations:^{
                [[overlayView layer] setOpacity:1];
                [screenManager setOverlayDisplayed:YES];
            }];
        }
    }
}

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]])
    {
        return NO;
    }
    
    return YES;
}

- (void) displayDistanceToLocationWithPost : (DEPost *) post
{
    // Perform task here
    CLLocationDegrees latitude = post.location.latitude;
    CLLocationDegrees longitude = post.location.longitude;
    PFGeoPoint *location = [[DELocationManager sharedManager] currentLocation];
    CLLocation *currentLocation = [[CLLocation alloc] initWithLatitude:location.latitude longitude:location.longitude];
    CLLocation *eventLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    CLLocationDistance distance = [currentLocation distanceFromLocation:eventLocation];
    NSLog(@"Distance to event: %f", distance);
    // Check to see if the event is currently going on, or finished within the hour
    double miles = distance / 1609.34;
    if (miles > 1000)
    {
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setPositiveFormat:@"0.#"];
        miles = miles / 1000;
        NSString *distanceInShortFormat = [NSString stringWithFormat:@"%@k mi", [formatter stringFromNumber:[NSNumber numberWithDouble:miles]]];
        self.lblDistance.text = distanceInShortFormat;
    }
    else if (miles > .1) {
        self.lblDistance.text = [NSString stringWithFormat:@"%.1f mi", miles];
    }
    else if (miles < .1) {
        double feet = miles * 5280;
        self.lblDistance.text = [NSString stringWithFormat:@"%.0f ft", feet];
    }
}


- (void) addGestureRecognizers
{
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
    [self addSubview:_overlayView];
    [[_overlayView layer] setOpacity:0];
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
    self.imgMainImageView.image = nil;
    [self.imgMainImageView setAlpha:0.0f];
}

- (void) showImage {
    if (self.imgMainImageView.image == nil)
    {
        [self loadImage];
        [UIView animateWithDuration:0.5f animations:^{
            [self.imgMainImageView setAlpha:1.0f];
        }];
    }
}

- (void) loadImage
{
    dispatch_async(dispatch_get_main_queue(), ^{
        // Load the images on the main thread asynchronously
        // Make sure that this post actually has an image
        if ([_post.images count] != 0)
        {
            if ([_post.images[0] isKindOfClass:[PFFile class]])
            {
                PFFile *imageFile = _post.images[0];
                [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                    NSData *imageData = data;
                    UIImage *image = [UIImage imageWithData:imageData];
                    self.imgMainImageView.image = image;
                    image = nil;

                }];
            }
            else if ([_post.images[0] isKindOfClass:[UIImage class]]) {
                UIImage *image = (UIImage *) _post.images[0];
                self.imgMainImageView.image = image;
                image = nil;
            }
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
    if ([_searchBar isFirstResponder])
    {
        [_searchBar resignFirstResponder];
    }
    else {
        if ([_post.username isEqualToString:[[PFUser currentUser] username]])
        {
            [self showEventEditing : YES];
        }
        else {
            [self showEventEditing : NO];
        }
    }
}

- (void) showEventEditing : (BOOL) editing {
    UINavigationController *navigationController = (UINavigationController *)[[[[UIApplication sharedApplication] delegate] window] rootViewController];
    DEEventViewController *eventViewController = [[UIStoryboard storyboardWithName:@"Event" bundle:nil] instantiateViewControllerWithIdentifier:@"viewEvent"];
    eventViewController.post = _post;
    eventViewController.isPreview = NO;
    eventViewController.isEditDeleteMode = editing;
    eventViewController.viewEventView = self;
    [[DEPostManager sharedManager] setCurrentPost:_post];
    [[DEPostManager sharedManager] setDistanceFromEvent:self.lblDistance.text];
    
    [navigationController pushViewController:eventViewController animated:YES];
    
    if ([PFUser currentUser])
    {
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
    else {
        // If this event is already saved as going, then we need to display that in the view.
        if ([[[DEPostManager sharedManager] goingPostForNoAccount] containsObject:_post.objectId])
        {
            eventViewController.isGoing = YES;
        }
        else if ([[[DEPostManager sharedManager] maybeGoingPostForNoAccount] containsObject:_post.objectId])
        {
            eventViewController.isMaybeGoing = YES;
        }
    }
    
}
@end
