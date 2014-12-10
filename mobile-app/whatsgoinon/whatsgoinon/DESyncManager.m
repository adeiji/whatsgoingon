//
//  DESyncManager.m
//  whatsgoinon
//
//  Created by adeiji on 8/5/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import "DESyncManager.h"
#import <Parse/Parse.h>
#import "Constants.h"
#import "Reachability.h"

@implementation DESyncManager

// Get all the future values from the server and store this information, then when the user wants to get Now or Later events, they will come from this list rather then be pulled down from the server
+ (void) getAllValues {
    [self checkForInternet];
    
    __block DEPostManager *sharedManager = [DEPostManager sharedManager];
    __block PFQuery *query = [PFQuery queryWithClassName:PARSE_CLASS_NAME_EVENT];
    //Get all the events that are currently active
    NSDate *nowDate = [NSDate date];
    
    [query orderByAscending:PARSE_CLASS_EVENT_START_TIME];
    [query whereKey:PARSE_CLASS_EVENT_ACTIVE equalTo:[NSNumber numberWithBool:true]];
    [query whereKey:PARSE_CLASS_EVENT_START_TIME greaterThan:nowDate];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error)
        {
            //Store the events pulled down from the server
            [sharedManager setPosts:objects];
            [sharedManager setAllEvents:objects];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CENTER_ALL_EVENTS_LOADED object:nil];
            NSLog(@"Notification sent, events loaded");
            [[DEScreenManager sharedManager] stopActivitySpinner];

        }
        else {
            // The find failed, let the customer know
            NSLog(@"Error: %@", [error description]);
        }
    }];

}

+ (void) getAllValuesForNow : (BOOL) now {
    
    [self checkForInternet];
    
    __block DEPostManager *sharedManager = [DEPostManager sharedManager];
    __block PFQuery *query = [PFQuery queryWithClassName:PARSE_CLASS_NAME_EVENT];
    
    //Get all the events that are currently active and less than three hours away to start
    NSDate *date = [NSDate date];
    NSTimeInterval threeHours = (3 * 60 * 60) - 1;
    NSDate *later = [date dateByAddingTimeInterval:threeHours];
    
    [query orderByAscending:PARSE_CLASS_EVENT_START_TIME];
    [query whereKey:PARSE_CLASS_EVENT_ACTIVE equalTo:[NSNumber numberWithBool:true]];
    
    if (now)
    {
        [query whereKey:PARSE_CLASS_EVENT_END_TIME greaterThan:[NSDate date]];
        [query whereKey:PARSE_CLASS_EVENT_START_TIME lessThan:later];
    }
    else
    {
        [query whereKey:PARSE_CLASS_EVENT_START_TIME greaterThan:later];
    }
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error)
        {
            if ([objects count] < 10)
            {
                query = [PFQuery queryWithClassName:PARSE_CLASS_NAME_EVENT];
                [self getValuesForLater:query Objects:objects];
            }
            else {
                //The find succeeded, now do something with it
                [sharedManager setPosts:objects];
                [sharedManager setAllEvents:objects];
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CENTER_ALL_EVENTS_LOADED object:nil];
                NSLog(@"Notification sent, events loaded");
                [[DEScreenManager sharedManager] stopActivitySpinner];
            }
        }
        else {
            // The find failed, let the customer know
            NSLog(@"Error: %@", [error description]);
        }
    }];
}
// Get the values for later if there are not more than 50 in the now events
+ (void) getValuesForLater : (PFQuery *) query
                   Objects : (NSArray *) objects
{
    NSDate *date = [NSDate date];
    NSTimeInterval threeHours = (3 * 60 * 60) - 1;
    NSDate *later = [date dateByAddingTimeInterval:threeHours];
    
    [query setLimit:10];
    [query whereKey:PARSE_CLASS_EVENT_START_TIME greaterThan:later];
    [[DEPostManager sharedManager] setPosts:objects];
    [query orderByAscending:PARSE_CLASS_EVENT_START_TIME];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if ([objects count] == 0)
        {
            [self loadBestEventsInPastWeekWithQuery : query];
        }
        else
        {
            //The find succeeded, now do something with it
            NSMutableArray *array = (NSMutableArray *) [[DEPostManager sharedManager] posts];
            [array addObjectsFromArray:objects];
            [[DEPostManager sharedManager] setPosts:array];
            [[DEPostManager sharedManager] setAllEvents:array];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CENTER_ALL_EVENTS_LOADED object:nil];
            NSLog(@"Notification sent, events loaded");
            [[DEScreenManager sharedManager] stopActivitySpinner];
        }
    }];
    
}


// Pull all the comments for this specific event
+ (NSArray *) getAllCommentsForEventId : (NSString *) objectId
{
    PFQuery *query = [PFQuery queryWithClassName:PARSE_CLASS_NAME_COMMENT];
    [query whereKey:PARSE_CLASS_COMMENT_EVENT_ID equalTo:objectId];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        // Post a notification saying that the comments have been loaded
       if (!error)
       {
           [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CENTER_ALL_COMMENTS_LOADED
                                                               object:nil
                                                             userInfo:@{
                                                                        @"comments": objects
                                                                        }];
           [[DEPostManager sharedManager] setComments:objects];
       }
    }];
    
    return nil;
}

+ (void) loadBestEventsInPastWeekWithQuery : (PFQuery *) query
{
    NSDate *startDate = [NSDate date];
    // Seconds in one week
    NSTimeInterval timeInterval = -60 * 60 * 24 * 7;
    startDate = [startDate dateByAddingTimeInterval:timeInterval];
    
    query = [PFQuery queryWithClassName:PARSE_CLASS_NAME_EVENT];
    [query orderByDescending:PARSE_CLASS_EVENT_NUMBER_GOING];
    [query whereKey:PARSE_CLASS_EVENT_START_TIME greaterThanOrEqualTo:startDate];
    [query whereKey:PARSE_CLASS_EVENT_START_TIME lessThanOrEqualTo:[NSDate date]];
    [query setLimit:10];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error)
        {
            [[DEPostManager sharedManager] setPosts:objects];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CENTER_NO_DATA object:nil];
            
            [[DEScreenManager sharedManager] stopActivitySpinner];
        }
    }];

}

+ (void) getAllValuesNearGeoPoint : (PFGeoPoint *) geoPoint
{
    [[DEScreenManager sharedManager] startActivitySpinner];
    // Let the necessary objects know that the city has just been changed
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CENTER_CITY_CHANGED object:nil];
    CGFloat miles = 25;
    
    __block PFQuery *query = [PFQuery queryWithClassName:PARSE_CLASS_NAME_EVENT];
    
    NSDate *date = [NSDate date];
    NSTimeInterval threeHours = (3 * 60 * 60) - 1;
    NSDate *later = [date dateByAddingTimeInterval:threeHours];
    
    if ([[DEScreenManager sharedManager] isLater])
    {
        [query whereKey:PARSE_CLASS_EVENT_START_TIME greaterThan:later];
    }
    else
    {
        [query whereKey:PARSE_CLASS_EVENT_END_TIME greaterThan:[NSDate date]];
        [query whereKey:PARSE_CLASS_EVENT_START_TIME lessThan:later];
    }
  
    [query setLimit:30];
    [query whereKey:PARSE_CLASS_EVENT_LOCATION nearGeoPoint:geoPoint withinMiles:miles];
    // Get all the objects that are either now or later
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error)
        {
            if ([objects count] < 10)
            {
                query = [PFQuery queryWithClassName:PARSE_CLASS_NAME_EVENT];
                [query whereKey:PARSE_CLASS_EVENT_LOCATION nearGeoPoint:geoPoint withinMiles:miles];
                [self getValuesForLater:query Objects:objects];
            }
            [[DEPostManager sharedManager] setPosts:objects];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CENTER_ALL_EVENTS_LOADED object:nil];
            [[DEScreenManager sharedManager] stopActivitySpinner];
        }
    }];
}

+ (void) checkForInternet
{
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.google.com"];
    
    // Start the notifier, which will case the reachability object to retain itself
    [reach startNotifier];
}

+ (void) saveObjectFromDictionary:(NSDictionary *)dictionary
{
    
}

+ (void) updateObjectWithId:(NSString *)objectId
               UpdateValues:(NSDictionary *)values
             ParseClassName:(NSString *) className;
{
    PFQuery *query = [PFQuery queryWithClassName:className];
    
    [query getObjectInBackgroundWithId:objectId block:^(PFObject *object, NSError *error) {
        for (NSString *key in values) {
            id value = [values objectForKey:key];
            object[key] = value;
        }
        
        [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded)
            {
                NSLog(@"Saved successfully");
            }
            else
            {
                NSLog(@"%@", error.description);
            }
        }];
    }];
}

+ (BOOL) savePost : (DEPost *) post {
    DEPostManager *sharedManager = [DEPostManager sharedManager];
    PFObject *postObject = [PFObject objectWithClassName:PARSE_CLASS_NAME_EVENT];
    
    postObject[PARSE_CLASS_EVENT_TITLE] = post.title;
    postObject[PARSE_CLASS_EVENT_ADDRESS] = post.address;
    postObject[PARSE_CLASS_EVENT_DESCRIPTION] = post.myDescription;
    postObject[PARSE_CLASS_EVENT_START_TIME] = post.startTime;
    postObject[PARSE_CLASS_EVENT_END_TIME] = post.endTime;
    postObject[PARSE_CLASS_EVENT_COST] = post.cost;
    postObject[PARSE_CLASS_EVENT_CATEGORY] = post.category;
    postObject[PARSE_CLASS_EVENT_ACTIVE] = [NSNumber numberWithBool:TRUE];
    postObject[PARSE_CLASS_EVENT_POST_RANGE] = post.postRange;
    postObject[PARSE_CLASS_EVENT_LOCATION] = post.location;
    postObject[PARSE_CLASS_EVENT_IMAGES] = [self getImagesArrayWithArray:post.images];
    postObject[PARSE_CLASS_EVENT_QUICK_DESCRIPTION] = post.quickDescription;
    postObject[PARSE_CLASS_EVENT_NUMBER_GOING] = post.numberGoing;
    postObject[PARSE_CLASS_EVENT_COMMENTS] = post.comments;
    postObject[PARSE_CLASS_EVENT_USERNAME] = [[PFUser currentUser] username];
    
    // If it saved successful return that it was successful and vice versa.
    [postObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded)
        {
            NSLog(@"Post Saved to Parse Server");
            NSMutableArray *array = [NSMutableArray arrayWithArray : [sharedManager posts]];
            [array addObject:postObject];
            
            [sharedManager setPosts:array];
            [self updatePostCountForUser];
        }
    }];
    
    return YES;
}

+ (void) updatePostCountForUser {
    PFQuery *query = [PFUser query];
    [query whereKey:PARSE_CLASS_USER_USERNAME equalTo:[[PFUser currentUser] username]];
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        int postCount = [object[PARSE_CLASS_USER_POST_COUNT] intValue];
        object[PARSE_CLASS_USER_POST_COUNT] = [NSNumber numberWithInt:postCount + 1];
        [object saveInBackground];
    }];
}

+ (void) saveEventAsMiscategorizedWithEventId : (NSString *) objectId
                                     Category : (NSString *) category
{
    PFObject *miscategorizedEventObject = [PFObject objectWithClassName:PARSE_CLASS_NAME_MISCATEGORIZED_EVENT];
    miscategorizedEventObject[PARSE_CLASS_MISCATEGORIZED_EVENT_ID] = objectId;
    miscategorizedEventObject[PARSE_CLASS_MISCATEGORIZED_EVENT_CATEGORY] = category;
    
    [miscategorizedEventObject saveEventually:^(BOOL succeeded, NSError *error){
        if (succeeded)
        {
            NSLog(@"You set the current object as miscategorized successfully");
        }
    }];
}

// Save the comment with the Event's id, and the actual comment, along with the user information

+ (void) saveCommentWithEventId : (NSString *) objectId
                        Comment : (NSString *) comment
                         Rating : (NSInteger) rating
{
    PFObject *commentObject = [PFObject objectWithClassName:PARSE_CLASS_NAME_COMMENT];
    commentObject[PARSE_CLASS_COMMENT_COMMENT] = comment;
    commentObject[PARSE_CLASS_COMMENT_USER] = [PFUser currentUser];
    commentObject[PARSE_CLASS_COMMENT_EVENT_ID] = objectId;
    
    if (rating > 0)
    {
        commentObject[PARSE_CLASS_COMMENT_THUMBS_UP] = [NSNumber numberWithBool:YES];
    }
    else
    {
        commentObject[PARSE_CLASS_COMMENT_THUMBS_UP] = [NSNumber numberWithBool:NO];
    }
    
    [commentObject saveEventually:^(BOOL succeeded, NSError *error) {
       if (succeeded)
       {
           NSLog(@"The comment was saved to the database");
       }
       else
       {
           NSLog(@"Error saving the comment: %@", [error description]);
       }
    }];
}

+ (void) saveReportWithEventId : (NSString * )objectId
                    WhatsWrong : (NSDictionary *) whatsWrong
                         Other : (NSString *) other
{
    
    PFObject *reportObject = [PFObject objectWithClassName:PARSE_CLASS_NAME_REPORT];
    
    reportObject[PARSE_CLASS_REPORT_EVENT_ID] = objectId;
    reportObject[PARSE_CLASS_REPORT_WHATS_WRONG] = whatsWrong;
    reportObject[PARSE_CLASS_REPORT_OTHER] = other;
    
    [reportObject saveEventually:^(BOOL succeeded, NSError *error) {
        if (succeeded)
        {
            NSLog(@"The report was saved to the server");
        }
    }];
}

+ (void) getNumberOfPostByUser : (NSString *) username {
    PFQuery *query = [PFUser query];
    [query whereKey:PARSE_CLASS_USER_USERNAME equalTo:[[PFUser currentUser] username]];
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        NSNumber *postCount = object[PARSE_CLASS_USER_POST_COUNT];
        
        if (postCount == nil)
        {
            postCount = [NSNumber numberWithInt:0];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CENTER_POST_FROM_USER_RETRIEVED object:nil userInfo:@{ kNOTIFICATION_CENTER_USER_INFO_USER_EVENTS_COUNT : postCount  } ];
    }];
}

+ (NSMutableArray *) getImagesArrayWithArray : (NSArray *) imageArray
{
    NSMutableArray *images = [NSMutableArray new];
    
    for (NSData *imageData in imageArray) {
        
        PFFile *imageFile = [PFFile fileWithName:@"post-image" data:imageData];
        
        [images addObject:imageFile];
    }
    
    return images;
}

#warning This should not be here, it needs to be moved to the Screen Manager
// Display the new view controller, but remove all other views from the View Controller stack first.
+ (void) popToRootAndShowViewController : (UIViewController *) viewController
{
    // Successful login
    UINavigationController *navigationController = (UINavigationController *)[[[[UIApplication sharedApplication] delegate] window] rootViewController];
    
    [navigationController popToRootViewControllerAnimated:NO];
    [navigationController pushViewController:viewController animated:YES];
    
    [[viewController navigationController] setNavigationBarHidden:NO];

}

@end
