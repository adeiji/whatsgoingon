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
}

+ (void) hideCommentView
{
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];

    for (UIView *view in [[[window rootViewController] view] subviews]) {
    #warning Right now we're hardcoding in the UIScrollView detection, but that should probably be done differently
        if ([view isKindOfClass:[UIScrollView class]])
        {
            [DEAnimationManager fadeOutRemoveView:view FromView:[[window rootViewController] view]];
        }
    }
}

/*
 
 Display a banner in 7 minutes asking the user to comment
 
 */

+ (void) createPromptUserCommentNotification : (DEPost *) post {
    // Create a local notification so that way if the app is completely closed it will still notify the user that an event has started
    UILocalNotification *localNotification = [UILocalNotification new];
    double minutes = .1;
    NSDate *nowPlusSevenMinutes = [[NSDate new] dateByAddingTimeInterval:(minutes * 60)];
    [localNotification setFireDate:nowPlusSevenMinutes];
    // Set the user info to contain the event id of the post that the user is at
    localNotification.userInfo = @{ kNOTIFICATION_CENTER_EVENT_USER_AT : post.objectId };
    localNotification.alertBody = [NSString stringWithFormat:@"Wanna to comment for event - %@", post.title];
    localNotification.alertAction = [NSString stringWithFormat:@"Since you went to this event, you can comment on it if you want"];
    localNotification.applicationIconBadgeNumber = 0;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];

    NSLog(@"Local Notification Object Set and Scheduled");
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
        NSPredicate *objectIdPredicate = [NSPredicate predicateWithFormat:@"objectId == %@", eventId];
        PFObject *postObj = [[[DEPostManager sharedManager] posts] filteredArrayUsingPredicate:objectIdPredicate][0];
        DEPost *post = [DEPost getPostFromPFObject:postObj];
        DEPromptCommentView *view = [[DEPromptCommentView alloc] initWithPost : post];
        [[[[UIApplication sharedApplication] delegate] window] addSubview:view];
        [view showView];
        [[[DEPostManager sharedManager] eventsUserAt] removeObject:eventId];
    }
    else {
        DEPromptCommentView *view = [[DEPromptCommentView alloc] initWithPost : myPost];
        [[[[UIApplication sharedApplication] delegate] window] addSubview:view];
        [view showView];
        [[[DEPostManager sharedManager] eventsUserAt] removeObject:myPost.objectId];
    }

};

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
    return (UINavigationController *) [[[UIApplication sharedApplication] keyWindow] rootViewController];
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
