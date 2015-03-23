//
//  DEScreenManager.m
//  whatsgoinon
//
//  Created by adeiji on 8/7/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import "DEScreenManager.h"
#import "Constants.h"

@implementation DEScreenManager

+ (id)sharedManager {
    static DEScreenManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        _overlayDisplayed = NO;
        _values = [NSMutableDictionary new];
        _screenHeight = [[UIScreen mainScreen] bounds].size.height;
    }
    return self;
}

+ (void) setBackgroundWithImageURL:(NSString *)imageUrl
{
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    UIImageView *blurredImageView = nil;
    
    for (UIView *subview in [window subviews]) {
        // Check to see if there is a UIImageView alreay in the view hierarchy
        if ([subview isKindOfClass:[UIImageView class]])
        {
            blurredImageView = (UIImageView *) subview;
            [blurredImageView setImage:nil];
        }
    }
    // If there is no blurred image view in the window view hierarchy then add it now
    if (!blurredImageView)
    {
        blurredImageView = [UIImageView new];
        [window addSubview:blurredImageView];
        [[blurredImageView layer] setZPosition:-1];
    }
    // Set the new background
    UIImage *image = ImageWithPath(ResourcePath(imageUrl)); // Uses imageWithContentsOfFile so that the image is not cached
    [blurredImageView setImage:image];
    [blurredImageView setFrame:window.frame];
}

+ (void) showCommentView : (DEPost *) post {
    
    DEViewComment *view = [[DEViewComment alloc] init];
    [view setPost:post];
    
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:window.bounds];
    [scrollView addSubview:view];
    NSArray *subviews = [window subviews];
    bool exist = NO;
    
    for (UIView *subview in subviews) {
        if ([subview isKindOfClass:[view class]])
        {
            exist = YES;
        }
    }
    
    if (!exist)
    {
        [DEAnimationManager fadeOutWithView:[[window rootViewController] view]  ViewToAdd:scrollView];
    }
    
    [[DELocationManager sharedManager] stopMonitoringRegionForPost:post];
    [[DEPostManager sharedManager] removeEventFromPromptedForCommentEvents:post];
}

+ (void) hideCommentView
{
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];

    for (UIView *view in [[[window rootViewController] view] subviews]) {
        if ([view isKindOfClass:[UIScrollView class]])
        {
            [DEAnimationManager fadeOutRemoveView:view FromView:[[window rootViewController] view]];
        }
    }
}

/*
 
 Display a banner in 15 minutes asking the user to comment.  Set whether or not this event is something that will show in the future after the event started, or if we're showing this event immediately
 
 */

+ (void) createPromptUserCommentNotification : (DEPost *) post
                                  TimeToShow : (NSDate *) dateToShow
                                    isFuture : (BOOL) future {
    
    // Perform task here
    // Create a local notification so that way if the app is completely closed it will still notify the user that an event has started
    UILocalNotification *localNotification = [UILocalNotification new];
    double minutes = 1;
    NSDate *nowPlusSevenMinutes = [dateToShow dateByAddingTimeInterval:(minutes * 60)];
    [localNotification setFireDate:nowPlusSevenMinutes];
    // Set the user info to contain the event id of the post that the user is at
    localNotification.userInfo = @{ kNOTIFICATION_CENTER_EVENT_USER_AT : post.objectId,
                                    kNOTIFICATION_CENTER_LOCAL_NOTIFICATION_FUTURE : [NSNumber numberWithBool:future] };
    localNotification.alertBody = [NSString stringWithFormat:@"So, tell us what you think about\n%@?", post.title];
    localNotification.alertAction = [NSString stringWithFormat:@"comment for this event"];
    localNotification.applicationIconBadgeNumber = 0;
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
    NSLog(@"Local Notification Object Set and Scheduled");

}

- (UIView *) setUpIndicatorViewWithText : (NSString *) text {
    UIView *view = [UIView new];
    CGRect window = [[UIScreen mainScreen] bounds];
    if (gettingEventsView || postingIndicatorView)
    {
        [view setFrame:CGRectMake(0, window.size.height - 50, window.size.width, 25)];
    }
    else {
        [view setFrame:CGRectMake(0, window.size.height - 25, window.size.width, 25)];
    }
    
    [view setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:.85f]];
    
    UILabel *posting = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, 100, 25)];
    [posting setText:text];
    [posting setFont:[UIFont fontWithName:@"Avenir Medium" size:12.0f]];
    [posting setTextColor:[UIColor whiteColor]];
    [[[[UIApplication sharedApplication] delegate] window] addSubview:view];
    
    UIProgressView *progressView = [UIProgressView new];
    [progressView setFrame:CGRectMake(150, 25/2.0f, window.size.width - 175, 10)];
    [progressView setProgressTintColor:[UIColor greenColor]];
    [view addSubview:progressView];
    [view addSubview:posting];
    [progressView setProgress:.25 animated:YES];
    [progressView setBackgroundColor:[UIColor whiteColor]];
    
    return view;
}

- (void) showGettingEventsIndicatorWitText : (NSString *) text
{
    gettingEventsView = [self setUpIndicatorViewWithText:@"Getting Events"];
    dispatch_async(dispatch_get_main_queue(), ^{
        gettingEventsTimer = [NSTimer scheduledTimerWithTimeInterval:.35 target:self selector:@selector(incrementGettingEventsProgressView) userInfo:nil repeats:YES];
        
        [gettingEventsTimer fire];
    });
}

- (void) showPostingIndicatorWithText : (NSString *) text
{
    postingIndicatorView = [self setUpIndicatorViewWithText:@"Posting Event"];
    dispatch_async(dispatch_get_main_queue(), ^{
        postingTimer = [NSTimer scheduledTimerWithTimeInterval:.35 target:self selector:@selector(incrementPostingProgressView) userInfo:nil repeats:YES];
        
        [postingTimer fire];
    });
    
}

- (void) incrementGettingEventsProgressView {
    UIProgressView *progressView;
    
    for (UIView *subview in [gettingEventsView subviews]) {
        if ([subview isKindOfClass:[UIProgressView class]])
        {
            progressView = (UIProgressView *) subview;
        }
    }
    
    if (progressView.progress < .80)
    {
        [progressView setProgress:progressView.progress + .15 animated:YES];
    }
    else {
        [gettingEventsTimer setFireDate:[NSDate distantFuture]];
        [gettingEventsTimer invalidate];
        
        gettingEventsTimer = nil;
    }
}

- (void) incrementPostingProgressView {
    UIProgressView *progressView;
    
    for (UIView *subview in [postingIndicatorView subviews]) {
        if ([subview isKindOfClass:[UIProgressView class]])
        {
            progressView = (UIProgressView *) subview;
        }
    }
    
    if (progressView.progress < .80)
    {
        [progressView setProgress:progressView.progress + .15 animated:YES];
    }
    else {
        [postingTimer setFireDate:[NSDate distantFuture]];
        [postingTimer invalidate];
        
        postingTimer = nil;
    }
}

- (void) hideIndicatorIsPosting : (BOOL) isPosting {
    UIProgressView *progressView;
    __block UIView *view;
    __block NSTimer *timer;
    
    if (isPosting)
    {
        view = postingIndicatorView;
        timer = postingTimer;
    }
    else {
        view = gettingEventsView;
        timer = gettingEventsTimer;
    }
    
    for (UIView *subview in [view subviews]) {
        if ([subview isKindOfClass:[UIProgressView class]])
        {
            progressView = (UIProgressView *) subview;
        }
    }
    
    [progressView setProgress:1.0f animated:NO];
    [progressView setProgressTintColor:[HPStyleKit blueColor]];
    for (UIView *myView in [view subviews]) {
        if ([myView isKindOfClass:[UILabel class]])
        {
            UILabel *label = (UILabel *) myView;
            [label setText:@"Completed"];
            [label setTextColor:[HPStyleKit blueColor]];
        }
    }
    
    [UIView animateWithDuration:1.0f animations:^{
        [view setAlpha:0.0f];
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
        if ([view isEqual:gettingEventsView])
        {
            gettingEventsView = nil;
        }
        else {
            postingIndicatorView = nil;
        }
        [timer setFireDate:[NSDate distantFuture]];
        [timer invalidate];
        timer = nil;
    }];
}

/*
 
 Display a screen similar to an iOS banner that asks the user if he wants to comment on the event that he just visited
 
 */
+ (void) promptForComment : (NSString *) eventId
                     Post : (DEPost *) myPost
{
    if (!myPost)
    {
        // Get the corresponding Event to this eventId
        __block PFObject *postObj;
        
        if ([[DEPostManager sharedManager] posts])
        {
            [[[DEPostManager sharedManager] posts] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                PFObject *object = (PFObject *) obj;
                if ([object.objectId isEqualToString:eventId ])
                {
                    postObj = object;
                    *stop = YES;
                }
            }];
            
            DEPost *post = [DEPost getPostFromPFObject:postObj];
            DEPromptCommentView *view = [[DEPromptCommentView alloc] initWithPost : post];
            [[[[UIApplication sharedApplication] delegate] window] addSubview:view];
            {
                CGRect frame = view.frame;
                frame.size.width = [[UIScreen mainScreen] bounds].size.width;
                [view setFrame:frame];
            }
            
            [view showView];
            [[[DEPostManager sharedManager] eventsUserAt] removeObject:eventId];
            // Make sure its saved that the user has already been prompted to comment for the event
            [[[DEPostManager sharedManager] promptedForCommentEvents] addObject:eventId];
            DEAppDelegate *appDelegate = (DEAppDelegate *) [[UIApplication sharedApplication] delegate];
            [appDelegate saveAllCommentArrays];
            [[DELocationManager sharedManager] stopMonitoringRegionForPost:post];
            [[DEPostManager sharedManager] removeEventFromPromptedForCommentEvents:post];
        }
    }
    else {
        DEPromptCommentView *view = [[DEPromptCommentView alloc] initWithPost : myPost];
        [[[[UIApplication sharedApplication] delegate] window] addSubview:view];
        {
            CGRect frame = view.frame;
            frame.size.width = [[UIScreen mainScreen] bounds].size.width;
            [view setFrame:frame];
        }
        [view showView];
        [[[DEPostManager sharedManager] eventsUserAt] removeObject:myPost.objectId];
        // Make sure its saved that the user has already been prompted to comment for the event
        [[[DEPostManager sharedManager] promptedForCommentEvents] addObject:myPost.objectId];
        DEAppDelegate *appDelegate = (DEAppDelegate *) [[UIApplication sharedApplication] delegate];
        [appDelegate saveAllCommentArrays];
        [[DELocationManager sharedManager] stopMonitoringRegionForPost:myPost];
        [[DEPostManager sharedManager] removeEventFromPromptedForCommentEvents:myPost];
    }

}



- (void) startActivitySpinner
{
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    spinner.center = window.center;
    spinner.hidesWhenStopped = YES;
    [window addSubview:spinner];
    [spinner startAnimating];
}

- (void) stopActivitySpinner {
    [spinner stopAnimating];
}



+ (void) setUpTextFields : (NSArray *) textFields
{
    for (UITextField *textField in textFields) {
        
        [textField.layer setCornerRadius:BUTTON_CORNER_RADIUS];
        UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        [textField setLeftViewMode:UITextFieldViewModeAlways];
        [textField setLeftView:spacerView];
        [textField setInputAccessoryView:[self createInputAccessoryView]];
        if ([textField respondsToSelector:@selector(setAttributedPlaceholder:)])
        {
            textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:textField.placeholder attributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] }];
        }
        else    // Prior to 6.0
        {
            
        }
    }
}

+ (UIView *) createInputAccessoryView {
    UIView *inputAccView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320.0f, 60.0f)];
    [inputAccView setBackgroundColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:.8f]];
    
    UIButton *btnDone = [UIButton buttonWithType:UIButtonTypeSystem];
    [btnDone setFrame:CGRectMake(10, 10, 50.0f, 40.0f)];
    [btnDone setTitle:@"Done" forState:UIControlStateNormal];
    [btnDone setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnDone addTarget:self action:@selector(hideKeyboard) forControlEvents:UIControlEventTouchUpInside];
    [inputAccView addSubview:btnDone];
    return inputAccView;
}

+ (void) hideKeyboard
{
    UIViewController *viewController = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    [viewController.view endEditing:YES];
}

// Gotos the stored next screen.  If the next screen that should be gone to is the main menu screen than we pop all the view controllers off the stack

- (void) gotoNextScreen {
    UINavigationController *navController = (UINavigationController *) [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    
    [navController popToRootViewControllerAnimated:NO];
    
    if (![_nextScreen isKindOfClass:[DEMainViewController class]])
    {
        [navController pushViewController:_nextScreen animated:YES];
    }
    else {
        [navController popToRootViewControllerAnimated:YES];
    }
}

+ (UINavigationController *) getMainNavigationController
{
    return (UINavigationController *) [[[[UIApplication sharedApplication] delegate] window] rootViewController];
}


- (void) showEmail
{
    // Subject
    NSString *emailTitle = @"HappSnap Feedback";
    
    // Content
    NSString *messageBody = @"";
    
    //To address
    NSArray *toRecipients = [NSArray arrayWithObject:@"adebayoiji@gmail.com"];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipients];
    
    [[[DEScreenManager sharedManager] nextScreen] presentViewController:mc animated:YES completion:NULL];
}

- (void) showTextWithMessage : (NSString *) message
{
    MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
    picker.messageComposeDelegate = self;
    picker.body = message;
    [[DEScreenManager sharedManager] setNextScreen:[DEScreenManager getMainNavigationController].topViewController];
    [[[DEScreenManager sharedManager] nextScreen] presentViewController:picker animated:YES completion:NULL];
}

// Display the new view controller, but remove all other views from the View Controller stack first.
+ (void) popToRootAndShowViewController : (UIViewController *) viewController
{
    // Successful login
    UINavigationController *navigationController = (UINavigationController *)[[[[UIApplication sharedApplication] delegate] window] rootViewController];
    
    [navigationController popToRootViewControllerAnimated:NO];
    [navigationController pushViewController:viewController animated:YES];
    
    [[viewController navigationController] setNavigationBarHidden:NO];
    
}

- (void) messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    switch (result) {
        case MessageComposeResultCancelled:
            NSLog(@"Message Cancelled");
            break;
        case MessageComposeResultSent:
            NSLog(@"Message saved");
            break;
        case MessageComposeResultFailed:
            NSLog(@"Message send failure");
            break;
        default:
            break;
    }
    
    [[[DEScreenManager sharedManager] nextScreen] dismissViewControllerAnimated:YES completion:NULL];
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail Cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail Saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail Sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    [[[DEScreenManager sharedManager] nextScreen] dismissViewControllerAnimated:YES completion:NULL];
}



@end
