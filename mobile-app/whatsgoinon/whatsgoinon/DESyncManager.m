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

/*
 
 Get one post by its Id and then display the comment view
 
 */
+ (void) getPostById:(NSString *)eventId
             Comment:(BOOL) comment
{
    PFQuery *query = [PFQuery queryWithClassName:PARSE_CLASS_NAME_EVENT];
    [query whereKey:PARSE_CLASS_EVENT_OBJECT_ID equalTo:eventId];
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
       if (!error)
       {
           DEPost *post = [DEPost getPostFromPFObject:object];
           if (comment)
           {
               [DEScreenManager showCommentView:post];
           }
       }
    }];
}

/*
 
 Get all the values that are posted at a specific miles distance from the user
 
 */
+ (void) getAllValuesWithinMilesForNow : (BOOL) now
                            PostsArray : (NSMutableArray *) postsArray
                              Location : (PFGeoPoint *) location
{
    static double miles = 0;
    PFQuery *query = [DESyncManager getBasePFQueryForNow:now];

    // If the miles is set to 0 that means the range is all, which means basically 30 miles and in, so we want to grab all events basically that are set to all
    if (miles > 0)
    {
        [query whereKey:PARSE_CLASS_EVENT_LOCATION nearGeoPoint:location withinMiles:miles];
        [query whereKey:PARSE_CLASS_EVENT_POST_RANGE equalTo:[NSNumber numberWithDouble:miles]];
    }
    else {  // Get post within thirty miles
        [query whereKey:PARSE_CLASS_EVENT_LOCATION nearGeoPoint:location withinMiles:30];
        [query whereKey:PARSE_CLASS_EVENT_POST_RANGE equalTo:[NSNumber numberWithDouble:miles]];
    }
    
    __block PFQuery *blockQuery = query;
    // Update the amount of miles so that we get the next set of posts
    miles += 5;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error)
        {
            // Check to see if we need to store this data and finish loading
            [DESyncManager addEventsToAlreadyRetrievedEvents : objects PostsArray:postsArray ProcessStatus:kNOTIFICATION_CENTER_USER_INFO_USER_PROCESS_STILL_LOADING];
            if (miles < 30)
            {
                [DESyncManager getAllValuesWithinMilesForNow:now PostsArray:postsArray Location:location];
            }
            else {
                if (([[[DEPostManager sharedManager] posts] count] < 10 && now) || ([[[DEPostManager sharedManager] posts] count] == 0 && !now))
                {
                    [self getAllValuesForLaterNearbyWithQuery : blockQuery];
                }
                else {
                    [DESyncManager addEventsToAlreadyRetrievedEvents : objects
                                                           PostsArray:postsArray
                                                        ProcessStatus:kNOTIFICATION_CENTER_USER_INFO_USER_PROCESS_FINISHED_LOADING];
                }
                // Set the miles to zero so that the next time the events are loaded we load them from all to 25 miles distance
                miles = 0;
            }

        }
        else {
            // The find failed, let the customer know
            NSLog(@"Error: %@", [error description]);
        }
    }];
}


+ (void) getAllValuesForLaterNearbyWithQuery : (PFQuery *) query {
    
    // Get any values that are later
    query = [PFQuery queryWithClassName:PARSE_CLASS_NAME_EVENT];
    // Make sure that the values for later are only those within thirty miles of the location the user is checking for
    [query whereKey:PARSE_CLASS_EVENT_LOCATION nearGeoPoint:[[DELocationManager sharedManager] userLocation] withinMiles:30];
    [self getValuesForLater:query
                    Objects:[[DEPostManager sharedManager] posts]
              ProcessStatus:kNOTIFICATION_CENTER_USER_INFO_USER_PROCESS_FINISHED_LOADING];
}


+ (PFQuery *) getBasePFQueryForNow : (BOOL) now {
    PFQuery *query = [PFQuery queryWithClassName:PARSE_CLASS_NAME_EVENT];
    
    //Get all the events that are currently active and less than three hours away to start
    NSDate *date = [NSDate date];
    NSTimeInterval threeHours = (3 * 60 * 60) - 1;
    NSDate *later = [date dateByAddingTimeInterval:threeHours];
    
    [query orderByDescending:PARSE_CLASS_EVENT_NUMBER_GOING];
    [query orderByDescending:PARSE_CLASS_EVENT_VIEW_COUNT];
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
    
    return query;
}

+ (void) getAllValuesForNow : (BOOL) now {
    
    [self checkForInternet];
    NSMutableArray *postsArray = [NSMutableArray new];

    [[NSNotificationCenter defaultCenter] postNotificationName:kNOTIFICATION_CENTER_USER_INFO_USER_PROCESS_NEW object:nil];
    
    [DESyncManager getAllValuesWithinMilesForNow:now
                                      PostsArray:postsArray
                                        Location:[[DELocationManager sharedManager] userLocation]];

}
// Store the events that we just recieved from Parse and notify the app
+ (void) addEventsToAlreadyRetrievedEvents : (NSArray *) objects
                                PostsArray : (NSMutableArray *) postsArray
                             ProcessStatus : (NSString *) process
{
    DEPostManager *sharedManager = [DEPostManager sharedManager];
    [postsArray addObjectsFromArray:objects];
    [sharedManager setPosts:postsArray];
    [sharedManager setAllEvents:postsArray];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CENTER_ALL_EVENTS_LOADED object:nil userInfo:@{ kNOTIFICATION_CENTER_USER_INFO_USER_PROCESS : process,
            kNOTIFICATION_CENTER_USER_INFO_CATEGORY : CATEGORY_TRENDING
    }];
    NSLog(@"Notification sent, events loaded");
    [[DEScreenManager sharedManager] stopActivitySpinner];
}


+ (void) getAllSavedEvents {
    
    PFQuery *query = [PFQuery queryWithClassName:PARSE_CLASS_NAME_EVENT];
    NSMutableArray *eventsToGetFromServerIds = [NSMutableArray new];
    for (NSString *eventId in [[DEPostManager sharedManager] goingPost]) {
        if (![[[DEPostManager sharedManager] loadedSavedEventIds] containsObject:eventId])
        {
            [[[DEPostManager sharedManager] loadedSavedEventIds] addObject:eventId];
            [eventsToGetFromServerIds addObject:eventId];
        }
    }
    
    if ([eventsToGetFromServerIds count] != 0)
    {
        [query whereKey:PARSE_CLASS_EVENT_END_TIME greaterThan:[NSDate new]];
        [query whereKey:PARSE_CLASS_EVENT_OBJECT_ID containedIn:eventsToGetFromServerIds];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
           if (!error)
           {
               
               NSMutableArray *array = [objects mutableCopy];
               
               for (PFObject *obj in array) {
                   if ([(NSDate *) obj[PARSE_CLASS_EVENT_END_TIME] compare:[NSDate dateWithTimeInterval:(60 * 60) sinceDate:[NSDate new]]] == NSOrderedAscending)
                    {
                        [array removeObject:obj];
                    }
               }
               // If there are no saved events that are earlier than now
               if ([array count] != 0)
               {
                   [[[DEPostManager sharedManager] loadedSavedEvents] addObjectsFromArray:array];
                   // Post notification showing that all the user events have been loaded
                   [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CENTER_SAVED_EVENTS_LOADED object:nil userInfo:@{  }];
               }
               else {   // Post that there are no saved events
                   [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CENTER_NO_SAVED_EVENTS object:nil];
               }
               
           }
        }];
    }
    else if ([[[DEPostManager sharedManager] loadedSavedEvents] count] != 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CENTER_SAVED_EVENTS_LOADED object:nil userInfo:@{  }];
    }
    else {
        // If there are no events that are saved for the user than we let the app know that
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CENTER_NO_SAVED_EVENTS object:nil];
    }
}

// Get the values for later if there are not more than 50 in the now events
+ (void) getValuesForLater : (PFQuery *) query
                   Objects : (NSArray *) myObjects
             ProcessStatus : (NSString *) processStatus
{
    NSDate *date = [NSDate date];
    NSTimeInterval threeHours = (3 * 60 * 60) - 1;
    NSDate *later = [date dateByAddingTimeInterval:threeHours];
    
    [query setLimit:10];
    [query whereKey:PARSE_CLASS_EVENT_START_TIME greaterThan:later];
    [query orderByAscending:PARSE_CLASS_EVENT_START_TIME];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if ([objects count] == 0  && [myObjects count] == 0)
        {
            [self loadEpicEvents:NO];
        }
        else
        {
            //The find succeeded, now do something with it
            NSMutableArray *array = (NSMutableArray *) [[DEPostManager sharedManager] posts];
            [DESyncManager addEventsToAlreadyRetrievedEvents:objects PostsArray:array ProcessStatus:kNOTIFICATION_CENTER_USER_INFO_USER_PROCESS_FINISHED_LOADING];
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

+ (void) loadEpicEvents : (BOOL) epicEvents
{
    NSDate *startDate = [NSDate date];
    // Seconds in one week
    NSTimeInterval timeInterval = -60 * 60 * 24 * 7;
    startDate = [startDate dateByAddingTimeInterval:timeInterval];
    
    PFQuery *query = [PFQuery queryWithClassName:PARSE_CLASS_NAME_EVENT];
    [query orderByDescending:PARSE_CLASS_EVENT_NUMBER_GOING];
    [query whereKey:PARSE_CLASS_EVENT_START_TIME greaterThanOrEqualTo:startDate];
    [query whereKey:PARSE_CLASS_EVENT_START_TIME lessThanOrEqualTo:[NSDate date]];
    [query setLimit:10];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error)
        {
            [[DEPostManager sharedManager] setPosts:objects];
            if (!epicEvents)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CENTER_NO_DATA object:nil];
            }
            else {
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CENTER_PAST_EPIC_EVENTS_LOADED object:nil userInfo:@{ kNOTIFICATION_CENTER_USER_INFO_IS_EPIC_EVENTS : [NSNumber numberWithBool:YES] }];
            }
            
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
    postObject[PARSE_CLASS_EVENT_VIEW_COUNT] = post.viewCount;
    
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
        [object saveEventually];
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
    [query whereKey:PARSE_CLASS_USER_USERNAME equalTo:username];
    
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

+ (void) updateViewCountForPost : (PFObject *) post {
    
    [post saveEventually:^(BOOL succeeded, NSError *error) {
        if (succeeded)
        {
            NSLog(@"Saved the View Count for object: %@", post);
        }
        else {
            NSLog(@"Error saving the view count: %@", [error description]);
        }
    }];
    
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
