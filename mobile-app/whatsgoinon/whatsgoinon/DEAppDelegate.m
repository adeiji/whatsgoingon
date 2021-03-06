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
#import <Google/Analytics.h>

@implementation DEAppDelegate

static NSString *const kEventsUserPromptedForComment = @"com.happsnap.eventsUserPromptedForComment";

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self setUpParseWithLaunchOptions:launchOptions];
    [GMSServices provideAPIKey:@"AIzaSyAChpei4sacCZDpzE4boq1lhftbBteTYak"];
    [[DELocationManager sharedManager] loadPreviousLocation];
    
    if (![launchOptions objectForKey:UIApplicationLaunchOptionsLocationKey])
    {
        [[[DELocationManager sharedManager] locationManager] startUpdatingLocation];
        [[DELocationManager sharedManager] startLocationUpdateTimer];
    }
    else {
        [[DELocationManager sharedManager] locationManager];
    }
    
    [self registerForNotifications:application];
    [DEScreenManager sharedManager];

    [[UITextField appearance] setKeyboardAppearance:UIKeyboardAppearanceDark];

    [self loadPromptedForCommentArray];
    [self checkIfLocalNotification:launchOptions];
    
    // Application is launched because of a significant location change
    if ([launchOptions objectForKey:UIApplicationLaunchOptionsLocationKey])
    {
        
    }
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setDefaultTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];

    [self configureGoogleAnalytics];
    
    #if DEBUG

    #endif
    return YES;
}



- (void) loadPromptedForCommentArray {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *array = [userDefaults objectForKey:kEventsUserPromptedForComment];
    
    if (array)
    {
        [[DEPostManager sharedManager] setPromptedForComment:array];
    }

}


- (void) setUpParseWithLaunchOptions : (NSDictionary *) launchOptions {
    // Connect our app to Parse
    // Allow the parse local data store
    [ParseCrashReporting enable];
    
    // Parse Keys - Live
    
//    #if DEBUG
//        [Parse setApplicationId:@"3USSbS5bzUbOMXvC1bpGiQBx28ANI494v3B1OuYR"
//                      clientKey:@"WR9vCDGASNSkgQsFI7AjW7cLAVL4T3m0g9S1mDb0"];
//    #else
        [Parse setApplicationId:@"YUXdFW3MDiu17bHCaKGKpbpde5XQ1eWEHN8n5jRT"
                      clientKey:@"7cNFD6SyCYqlbeH460CRYMEmaMPmtoSuehQPSGAX"];
//    #endif

    [PFTwitterUtils initializeWithConsumerKey:@"TFcHVbGMjgBiXuSUpE16untPd" consumerSecret:@"alxo7PP08tyyG2mR3QFm8n8XHdJBcTzGw1u7BKW7A13AaeCWe8"];
    [PFFacebookUtils initializeFacebook];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
}

- (void) sendTestNotification {
    
    // Perform task here
    // Create a local notification so that way if the app is completely closed it will still notify the user that an event has started
    UILocalNotification *localNotification = [UILocalNotification new];
    double minutes = .1;
    NSDate *nowPlusSevenMinutes = [[NSDate date] dateByAddingTimeInterval:(60 * minutes)];
    [localNotification setFireDate:nowPlusSevenMinutes];
    // Set the user info to contain the event id of the post that the user is at
    localNotification.userInfo = @{ kNOTIFICATION_CENTER_EVENT_USER_AT : @"FbsY4rV1Vq",
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
        [DESyncManager getPostById:[notification.userInfo objectForKey:kNOTIFICATION_CENTER_EVENT_USER_AT] Process:PROMPT_COMMENT_FOR_EVENT];
    }
    else  {  // Notification has come from being pressed
        [DESyncManager getPostById:[notification.userInfo objectForKey:kNOTIFICATION_CENTER_EVENT_USER_AT] Process:SHOW_COMMENT_VIEW];
    }

}

- (void) checkIfLocalNotification : (NSDictionary *) launchOptions {
    UILocalNotification *localNotif = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (localNotif) {
        if (![[[DEPostManager sharedManager] promptedForComment] containsObject:localNotif.userInfo[kNOTIFICATION_CENTER_EVENT_USER_AT]])
        {
            // Reload the Event that the user had been to
            [DESyncManager getPostById:[localNotif.userInfo objectForKey:kNOTIFICATION_CENTER_EVENT_USER_AT] Process:SHOW_COMMENT_VIEW];
        }
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
    [[[DELocationManager sharedManager] locationManager] stopMonitoringSignificantLocationChanges];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:nil forKey:EPIC_EVENTS_SCREEN_PROMPTED];
    [defaults setObject:nil forKey:kUSER_DEFAULTS_PROMPTED_FOR_LOGIN];
    [defaults synchronize];

}

- (void) setUserArraysToEmpty {
    [[DEPostManager sharedManager] setGoingPost:[NSMutableArray new]];
    [[DEPostManager sharedManager] setMaybeGoingPost:[NSMutableArray new]];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [[DEPostManager sharedManager] setPromptedForComment:[NSMutableArray new]];
    [userDefaults setObject:[[DEPostManager sharedManager] promptedForComment] forKey:kEventsUserPromptedForComment];
    [userDefaults synchronize];
    
}

- (BOOL) application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                        withSession:[PFFacebookUtils session]];
}

-(void) configureGoogleAnalytics
{
    // Configure tracker from GoogleService-Info.plist.
    NSError *configureError;
    [[GGLContext sharedInstance] configureWithError:&configureError];
    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
    
    // Optional: configure GAI options.
    GAI *gai = [GAI sharedInstance];
    gai.trackUncaughtExceptions = YES;  // report uncaught exceptions
    gai.logger.logLevel = kGAILogLevelVerbose;  // remove before app release
}

@end
