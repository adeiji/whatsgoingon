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

@implementation DEAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    // Connect our app to Parse
    [Parse setApplicationId:@"3USSbS5bzUbOMXvC1bpGiQBx28ANI494v3B1OuYR"
                  clientKey:@"WR9vCDGASNSkgQsFI7AjW7cLAVL4T3m0g9S1mDb0"];
    [PFTwitterUtils initializeWithConsumerKey:@"Pg6HkvcmVVsrfyrWLKswRBisa" consumerSecret:@"xXP4I1IPUEhalMSBdHNaO5zGl1IshaAbyh4FDoTcXwzdSEjDdW"];

    // start of your application:didFinishLaunchingWithOptions // ...
    [TestFlight takeOff:@"7dff8d72-f33d-4eb7-aa3f-632fff9c3f03"];
    
    // Track statistics around application opens
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    [DESyncManager getAllValues];
    [DELocationManager sharedManager];
    [DEScreenManager sharedManager];
    
    return YES;
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

@end
