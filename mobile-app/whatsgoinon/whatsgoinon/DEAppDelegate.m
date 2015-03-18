//
//  DEAppDelegate.m
//  whatsgoinon
//
//  Created by adeiji on 8/4/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//
// HappSnap SKU - com.happsnap.dephyned
#import "DEAppDelegate.h"
#import <Parse/Parse.h>
#import "TestFlight.h"
#import <FacebookSDK/FacebookSDK.h>
#import <GoogleMaps/GoogleMaps.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import <ParseCrashReporting/ParseCrashReporting.h>

@implementation DEAppDelegate

static NSString *const kEventsUserPromptedForComment = @"com.happsnap.eventsUserPromptedForComment";
static NSString *const kEventsUserGoingTo = @"com.happsnap.eventsUserGoingTo";
static NSString *const kEventsUserMaybeGoingTo = @"com.happsnap.eventsMaybeGoingTo";
static NSString *const kEventsWithCommentInformation = @"com.happsnap.eventsWithCommentInformation";

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self setUpParseWithLaunchOptions:launchOptions];
    [GMSServices provideAPIKey:@"AIzaSyAChpei4sacCZDpzE4boq1lhftbBteTYak"];
    [[[DELocationManager sharedManager] locationManager] startUpdatingLocation];
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        // Make sure this keeps running in the background
        [[[DELocationManager sharedManager] locationManager] requestAlwaysAuthorization];
    }
    
    [self registerForNotifications:application];
    [DEScreenManager sharedManager];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [[UITextField appearance] setKeyboardAppearance:UIKeyboardAppearanceDark];
    [self checkIfLocalNotification:launchOptions];
    [self loadPromptedForCommentEvents];
    [self loadGoingPosts];
    [self loadMaybeGoingPosts];
    [[DEPostManager sharedManager] setGoingPostWithCommentInformation:[self getPostWithCommentInformation]];
    [self checkIfCanComment];
    [self loadAnalyticsArray];

    // Application is launched because of a significant location change
    if ([launchOptions objectForKey:UIApplicationLaunchOptionsLocationKey])
    {
        [self respondToSignificantLocationChange];
    }

    return YES;
}

- (void) checkIfCanComment {
    [self cancelAllFutureNotifications];
    
    NSArray *postsWithCommentInformation = [self getPostWithCommentInformation];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    CLLocation *location = [[[DELocationManager sharedManager] locationManager] location];
    
    if (postsWithCommentInformation != nil)
    {
        [postsWithCommentInformation enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            BOOL commented = [self checkForCommentingValuesDictionary:(NSMutableDictionary *) obj CurrentLocation:location];
            if (commented)
            {
                [[[DEPostManager sharedManager] promptedForCommentEvents] addObject:obj[PARSE_CLASS_EVENT_OBJECT_ID]];
                [userDefaults setObject:[[DEPostManager sharedManager] promptedForCommentEvents] forKey:kEventsUserPromptedForComment];
            }
        }];
    }
    
    [userDefaults setObject:[[DEPostManager sharedManager] goingPostWithCommentInformation] forKey:kEventsWithCommentInformation];
}

- (void) setUpParseWithLaunchOptions : (NSDictionary *) launchOptions {
    // Connect our app to Parse
    // Allow the parse local data store
    [ParseCrashReporting enable];
    [Parse setApplicationId:@"3USSbS5bzUbOMXvC1bpGiQBx28ANI494v3B1OuYR"
                  clientKey:@"WR9vCDGASNSkgQsFI7AjW7cLAVL4T3m0g9S1mDb0"];
    [PFTwitterUtils initializeWithConsumerKey:@"TFcHVbGMjgBiXuSUpE16untPd" consumerSecret:@"alxo7PP08tyyG2mR3QFm8n8XHdJBcTzGw1u7BKW7A13AaeCWe8"];
    [PFFacebookUtils initializeFacebook];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];

}

- (void) sendNotification {
    // Perform task here
    // Create a local notification so that way if the app is completely closed it will still notify the user that an event has started
    UILocalNotification *localNotification = [UILocalNotification new];
    double minutes = 15;
    NSDate *nowPlusSevenMinutes = [[NSDate new] dateByAddingTimeInterval:(minutes * 60)];
    [localNotification setFireDate:nowPlusSevenMinutes];
    // Set the user info to contain the event id of the post that the user is at
    localNotification.alertBody = [NSString stringWithFormat:@"Recieved significant location change update"];
    localNotification.applicationIconBadgeNumber = 0;
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

- (void) cancelAllFutureNotifications
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // Make sure that there actually is some data stored that we're pulling
    NSMutableArray *savedPromptedForCommentEvents = [[defaults objectForKey:kEventsUserPromptedForComment] mutableCopy];
    NSArray *scheduledLocalNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    [scheduledLocalNotifications enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UILocalNotification *notification = (UILocalNotification *) obj;
        if ([notification.userInfo[kNOTIFICATION_CENTER_LOCAL_NOTIFICATION_FUTURE] isEqual:[NSNumber numberWithBool:YES]])
        {
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
            NSString *eventId = notification.userInfo[kNOTIFICATION_CENTER_EVENT_USER_AT];
            [savedPromptedForCommentEvents removeObject:eventId];
        }
    }];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[[DEPostManager sharedManager] promptedForCommentEvents] forKey:kEventsUserPromptedForComment];
    
}

- (NSMutableArray *) loadAnalyticsArray {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *array = [defaults objectForKey:kAnalyticsArray];
    
    if (!array)
    {
        array = [NSMutableArray new];
    }
    else {
        if ([[UIApplication sharedApplication] applicationState] != UIApplicationStateBackground)
        {
            array = nil;
            [defaults setObject:array forKey:kAnalytics];
            [defaults synchronize];
        }
    }
    
    return array;
}

- (NSMutableDictionary *) getTimeLapsedAnalyticsDictionary : (NSMutableDictionary *) dictionary {
    NSDate *previousDateTime = [analytics objectForKey:PARSE_ANALYTICS_TIME];
    if (previousDateTime)
    {
        double timeLapse = [previousDateTime timeIntervalSinceDate:[NSDate date]];
        [dictionary setObject:[NSNumber numberWithDouble:timeLapse] forKey:PARSE_ANALYTICS_TIME_LAPSED];
    }
    
    return dictionary;
}



/*
 
 Get the distance between the location the user is at now and the location that the user was at last time the app updated from a significant location change update
 
 */
- (NSMutableDictionary *) getDistanceTraveledAnalyticsDictionary : (NSMutableDictionary *) dictionary
{
    CLLocation *location = [[[DELocationManager sharedManager] locationManager] location];
    CLLocationDegrees latitude = [[dictionary objectForKey:PARSE_ANALYTICS_LATITUDE] doubleValue];
    CLLocationDegrees longitude = [[dictionary objectForKey:PARSE_ANALYTICS_LONGITUDE] doubleValue];
    CLLocation *previousLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    double distance = [location distanceFromLocation:previousLocation];
    NSNumber *distanceObject = [NSNumber numberWithDouble:distance];
    
    [dictionary setObject:distanceObject forKey:PARSE_ANALYTICS_DISTANCE_TRAVELED];
    return dictionary;
}

- (NSString *) getNowString {
    NSDate *now = [NSDate date];
    NSDateFormatter *df = [NSDateFormatter new];
    [df setDateStyle:NSDateFormatterShortStyle];
    [df setTimeStyle:NSDateFormatterFullStyle];
    return [df stringFromDate:now];
}

- (NSMutableDictionary *) getCurrentLocationAnalyticsDictionary : (NSMutableDictionary *) dictionary {
    CLLocation *location = [[[DELocationManager sharedManager] locationManager] location];
    CLLocationDegrees latitude = location.coordinate.latitude;
    CLLocationDegrees longitude = location.coordinate.longitude;
    
    NSNumber *latObject = [NSNumber numberWithDouble:latitude];
    NSNumber *longObject = [NSNumber numberWithDouble:longitude];
    
    [dictionary setObject:latObject forKey:PARSE_ANALYTICS_LATITUDE];
    [dictionary setObject:longObject forKey:PARSE_ANALYTICS_LONGITUDE];
    
    return dictionary;
}

- (NSMutableDictionary *) getAnalyticsInformation : (NSMutableDictionary *) analyticsDictionary {
    analyticsDictionary = [NSMutableDictionary new];
    analyticsDictionary = [self getDistanceTraveledAnalyticsDictionary:analyticsDictionary];
    analyticsDictionary = [self getTimeLapsedAnalyticsDictionary:analyticsDictionary];
    analyticsDictionary = [self getCurrentLocationAnalyticsDictionary:analyticsDictionary];
    
    return analyticsDictionary;
    
}

/* 1.  Get the current Location
 2.  See if any of the events the user is going to are nearby */

- (void) respondToSignificantLocationChange
{
    
    bgTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [[UIApplication sharedApplication] endBackgroundTask:bgTask];
    }];
    
    //### background task starts
    CLLocationManager *manager = [[CLLocationManager alloc] init];
    CLLocation *location = [manager location];
    manager.delegate = self;
    [manager startMonitoringSignificantLocationChanges];
    
    [self cancelAllFutureNotifications];

    NSArray *postsWithCommentInformation = [self getPostWithCommentInformation];
    
    if (postsWithCommentInformation != nil)
    {
        [postsWithCommentInformation enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [self checkForCommentingValuesDictionary:(NSMutableDictionary *) obj CurrentLocation:location];
        }];
    }
    
    if (bgTask != UIBackgroundTaskInvalid)
    {
        [[UIApplication sharedApplication] endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }
    
}

- (void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {

}

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {

}

- (BOOL) checkForCommentingValuesDictionary : (NSDictionary *) obj
                                             CurrentLocation : (CLLocation *) location
{
    NSDictionary *values = (NSDictionary *) obj;
    NSString *postTitle = values[PARSE_CLASS_EVENT_TITLE];
    CLLocationDegrees latitude = ((NSNumber *) values[LOCATION_LATITUDE]).doubleValue;
    CLLocationDegrees longitude = ((NSNumber *) values[LOCATION_LONGITUDE]).doubleValue;
    CLLocation *eventLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    
    if ([self checkIfNearEventLocation:location Event:eventLocation EventName:postTitle])
    {
        NSDate *later = values[PARSE_CLASS_EVENT_END_TIME];
        NSDate *startTime = values[PARSE_CLASS_EVENT_START_TIME];
        NSString *postId = values[PARSE_CLASS_EVENT_OBJECT_ID];
        
        later = [later dateByAddingTimeInterval:(60 * 60)];
        
        if (([startTime compare:[NSDate date]] == NSOrderedAscending) && ([later compare:[NSDate date]] == NSOrderedDescending))
        {
            [self createPromptUserCommentNotification:postId Title:postTitle TimeToShow:[NSDate new] isFuture:NO];
            return YES;
        }
        else if ([later compare:[NSDate date]] == NSOrderedDescending)  // If the user is simply early
        {
            [self createPromptUserCommentNotification:postId Title:postTitle TimeToShow:[NSDate new] isFuture:YES];
            return YES;
        }
    }

    return NO;
}

- (void) saveCurrentLocatino {
    
}

- (void) createPromptUserCommentNotification : (NSString *) postId
                                       Title : (NSString *) postTitle
                                  TimeToShow : (NSDate *) dateToShow
                                    isFuture : (BOOL) future {
    
    
    // Perform task here
    // Create a local notification so that way if the app is completely closed it will still notify the user that an event has started
    UILocalNotification *localNotification = [UILocalNotification new];
    double minutes = 1;
    NSDate *nowPlusSevenMinutes = [dateToShow dateByAddingTimeInterval:(60 * minutes)];
    [localNotification setFireDate:nowPlusSevenMinutes];
    // Set the user info to contain the event id of the post that the user is at
    localNotification.userInfo = @{ kNOTIFICATION_CENTER_EVENT_USER_AT : postId,
                                    kNOTIFICATION_CENTER_LOCAL_NOTIFICATION_FUTURE : [NSNumber numberWithBool:future] };
    localNotification.alertBody = [NSString stringWithFormat:@"So, tell us what you think about\n%@?", postTitle];
    localNotification.alertAction = [NSString stringWithFormat:@"comment for this event"];
    localNotification.applicationIconBadgeNumber = 0;
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
    NSLog(@"Local Notification Object Set and Scheduled");
    
    // Get the corresponding Event to this eventId
    NSPredicate *objectIdPredicate = [NSPredicate predicateWithFormat:@"objectId == %@", postId];
    NSArray *object = [[[DEPostManager sharedManager] goingPostWithCommentInformation] filteredArrayUsingPredicate:objectIdPredicate];
    if (object[0])
    {
        id postWithCommentInformation = object[0];
        [[[DEPostManager sharedManager] goingPostWithCommentInformation] removeObject:postWithCommentInformation];
    }
    
}


- (BOOL) checkIfNearEventLocation : (CLLocation *) location
                            Event : (CLLocation *) eventLocation
                        EventName : (NSString *) eventName
{
    
    double distance = [location distanceFromLocation:eventLocation];
    
    if (distance < 600)
    {
        return YES;
    }
    else {
        return NO;
    }
}

- (NSMutableArray *) getPostWithCommentInformation {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // Make sure that there actually is some data stored that we're pulling
    NSMutableArray *postsWithCommentInformation = [[defaults objectForKey:kEventsWithCommentInformation] mutableCopy];
    if (postsWithCommentInformation != nil)
    {
        return postsWithCommentInformation;
    }
    
    return nil;
}

- (void) loadPromptedForCommentEvents {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    DEPostManager *postManager = [DEPostManager sharedManager];

    // Make sure that there actually is some data stored that we're pulling
    NSMutableArray *savedPromptedForCommentEvents = [[defaults objectForKey:kEventsUserPromptedForComment] mutableCopy];
    if (savedPromptedForCommentEvents != nil)
    {
        [postManager setPromptedForCommentEvents: savedPromptedForCommentEvents ];
    }
}

- (void) loadGoingPosts {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    DEPostManager *postManager = [DEPostManager sharedManager];
    
    // Make sure that there actually is some data stored that we're pulling
    NSMutableArray *eventsUserGoingToArray = [[defaults objectForKey:kEventsUserGoingTo] mutableCopy];
    if (eventsUserGoingToArray != nil)
    {
        [postManager setGoingPost: eventsUserGoingToArray ];
    }
}

- (void) loadMaybeGoingPosts {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    DEPostManager *postManager = [DEPostManager sharedManager];
    
    // Make sure that there actually is some data stored that we're pulling
    NSMutableArray *eventsUserMaybeGoingToArray = [[defaults objectForKey:kEventsUserMaybeGoingTo] mutableCopy];
    if (eventsUserMaybeGoingToArray != nil)
    {
        [postManager setMaybeGoingPost: eventsUserMaybeGoingToArray ];
    }
}

- (void) sendTestNotification {
    
    // Perform task here
    // Create a local notification so that way if the app is completely closed it will still notify the user that an event has started
    UILocalNotification *localNotification = [UILocalNotification new];
    double minutes = .1;
    NSDate *nowPlusSevenMinutes = [[NSDate date] dateByAddingTimeInterval:(60 * minutes)];
    [localNotification setFireDate:nowPlusSevenMinutes];
    // Set the user info to contain the event id of the post that the user is at
    localNotification.userInfo = @{ kNOTIFICATION_CENTER_EVENT_USER_AT : @"Test",
                                    kNOTIFICATION_CENTER_LOCAL_NOTIFICATION_FUTURE : @NO };
    localNotification.alertBody = [NSString stringWithFormat:@"So, tell us what you think about\n%@?", @"Test"];
    localNotification.alertAction = [NSString stringWithFormat:@"comment for this event"];
    localNotification.applicationIconBadgeNumber = 0;
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
    NSLog(@"Local Notification Object Set and Scheduled");
}

- (void) application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
    if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive)
    {
        if ([[DEPostManager sharedManager] posts])  // If the user has not loaded the posts yet by pressing the 'Now' or 'Later' buttons
        {
            [DEScreenManager promptForComment:[notification.userInfo objectForKey:kNOTIFICATION_CENTER_EVENT_USER_AT] Post:nil];
        }
        else {
            // Get the corresponding Event to the Event ID and then prompt the user to comment
            [DESyncManager getPostById:[notification.userInfo objectForKey:kNOTIFICATION_CENTER_EVENT_USER_AT] Comment:NO];
            // Comment: NO, signifies that we only want the user to be prompted for the comment, not have them actually comment
        }
    }
    else  {  // Notification has come from being pressed
        [self displayCommentViewWithObjectId:[notification.userInfo objectForKey:kNOTIFICATION_CENTER_EVENT_USER_AT]];
    }
}

- (void) displayCommentViewWithObjectId : (NSString *) objectId {
    // Get the corresponding Event to this eventId
    NSPredicate *objectIdPredicate = [NSPredicate predicateWithFormat:@"objectId == %@", objectId];
    NSArray *object = [[[DEPostManager sharedManager] goingPostWithCommentInformation] filteredArrayUsingPredicate:objectIdPredicate];
    
    if ([object count] != 0)
    {
        PFObject *postObj = object[0];
        DEPost *post = [DEPost getPostFromPFObject:postObj];
        
        // Show the comment view for this particular event
        [DEScreenManager showCommentView:post];
    }
    else {
        [DESyncManager getPostById:objectId Comment:YES];
    }
}

- (void) checkIfLocalNotification : (NSDictionary *) launchOptions {
    UILocalNotification *localNotif = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (localNotif) {
        // Reload the Event that the user had been to
        [DESyncManager getPostById:[localNotif.userInfo objectForKey:kNOTIFICATION_CENTER_EVENT_USER_AT] Comment:YES];
    }
}

// Register the application to allow for local notifications
- (void) registerForNotifications : (UIApplication *) application
{
    
    NSString *version = [UIDevice currentDevice].systemVersion;
    
    if (version.intValue >= 8) {
        UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound;
        UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    }

}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        // Make sure this keeps running in the background
        [[[DELocationManager sharedManager] locationManager] requestAlwaysAuthorization];
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Save the events that the user was already prompted to comment on
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[[DEPostManager sharedManager] promptedForCommentEvents] forKey:kEventsUserPromptedForComment];
    [userDefaults setObject:[[DEPostManager sharedManager] goingPost] forKey:kEventsUserGoingTo];
    [userDefaults setObject:[[DEPostManager sharedManager] maybeGoingPost] forKey:kEventsUserMaybeGoingTo];
    [userDefaults setObject:[[DEPostManager sharedManager] goingPostWithCommentInformation] forKey:kEventsWithCommentInformation];
    [userDefaults synchronize];
}

- (void) saveAllCommentArrays {
    // Save the events that the user was already prompted to comment on
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[[DEPostManager sharedManager] promptedForCommentEvents] forKey:kEventsUserPromptedForComment];
    [userDefaults setObject:[[DEPostManager sharedManager] goingPost] forKey:kEventsUserGoingTo];
    [userDefaults setObject:[[DEPostManager sharedManager] maybeGoingPost] forKey:kEventsUserMaybeGoingTo];
    [userDefaults setObject:[[DEPostManager sharedManager] goingPostWithCommentInformation] forKey:kEventsWithCommentInformation];
    [userDefaults synchronize];
}

- (void) setUserDefaultArraysToEmpty {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:nil forKey:kEventsUserPromptedForComment];
    [userDefaults setObject:nil forKey:kEventsUserGoingTo];
    [userDefaults setObject:nil forKey:kEventsUserMaybeGoingTo];
    [userDefaults setObject:nil forKey:kEventsWithCommentInformation];
    [[DEPostManager sharedManager] setPromptedForCommentEvents:[NSMutableArray new]];
    [[DEPostManager sharedManager] setGoingPost:[NSMutableArray new]];
    [[DEPostManager sharedManager] setMaybeGoingPost:[NSMutableArray new]];
    [[DEPostManager sharedManager] setGoingPostWithCommentInformation:[NSMutableArray new]];
}

- (BOOL) application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                        withSession:[PFFacebookUtils session]];
}

@end
