//
//  DEAppDelegate.h
//  whatsgoinon
//
//  Created by adeiji on 8/4/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DELocationManager.h"
#import "DESyncManager.h"
#import "DEScreenManager.h"
#import "DEUserManager.h"

@interface DEAppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>
{
    NSTimer *timer;
    NSMutableDictionary *analytics;
    NSMutableArray *analyticsArray;
    UIBackgroundTaskIdentifier bgTask;
}

- (void) loadPromptedForCommentEvents;
- (void) loadGoingPosts;
- (void) loadMaybeGoingPosts;
- (void) setUserDefaultArraysToEmpty;
- (void) saveAllCommentArrays;
- (NSMutableArray *) loadAnalyticsArray;
- (void) createPromptUserCommentNotification : (NSString *) postId
                                       Title : (NSString *) postTitle
                                  TimeToShow : (NSDate *) dateToShow
                                    isFuture : (BOOL) future;

@property (strong, nonatomic) UIWindow *window;

@end
