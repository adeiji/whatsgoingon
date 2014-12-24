//
//  DEAppDelegate.m
//  whatsgoinon
//
//  Created by adeiji on 8/4/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import "DEAppDelegate.h"
#import <Parse/Parse.h>
#import "TestFlight.h"
#import <FacebookSDK/FacebookSDK.h>
#import <GoogleMaps/GoogleMaps.h>

@implementation DEAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    // Connect our app to Parse
    [Parse setApplicationId:@"3USSbS5bzUbOMXvC1bpGiQBx28ANI494v3B1OuYR"
                  clientKey:@"WR9vCDGASNSkgQsFI7AjW7cLAVL4T3m0g9S1mDb0"];
    [PFTwitterUtils initializeWithConsumerKey:@"TFcHVbGMjgBiXuSUpE16untPd" consumerSecret:@"alxo7PP08tyyG2mR3QFm8n8XHdJBcTzGw1u7BKW7A13AaeCWe8"];
    [PFFacebookUtils initializeFacebook];
    // start of your application:didFinishLaunchingWithOptions // ...
    [TestFlight takeOff:@"7dff8d72-f33d-4eb7-aa3f-632fff9c3f03"];
    [GMSServices provideAPIKey:@"AIzaSyAChpei4sacCZDpzE4boq1lhftbBteTYak"];
    
    // Track statistics around application opens
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    DELocationManager *locManager = [DELocationManager sharedManager];
    [locManager startTimer];
    [DEScreenManager sharedManager];
    
    [[UITextField appearance] setKeyboardAppearance:UIKeyboardAppearanceDark];

    [self checkIfLocalNotification:launchOptions];
    
    return YES;
}

- (void) application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
    if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive)
    {

        [DEScreenManager promptForComment:[notification.userInfo objectForKey:kNOTIFICATION_CENTER_EVENT_USER_AT] Post:nil];
    }
    else {
        // Get the corresponding Event to this eventId
        NSPredicate *objectIdPredicate = [NSPredicate predicateWithFormat:@"objectId == %@", [notification.userInfo objectForKey:kNOTIFICATION_CENTER_EVENT_USER_AT]];
        PFObject *postObj = [[[DEPostManager sharedManager] posts] filteredArrayUsingPredicate:objectIdPredicate][0];
        DEPost *post = [DEPost getPostFromPFObject:postObj];
        
        // Show the comment view for this particular event
        [DEScreenManager showCommentView:post];
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
    
    // iOS 8
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeAlert;
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];

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
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL) application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                        withSession:[PFFacebookUtils session]];
}

@end
