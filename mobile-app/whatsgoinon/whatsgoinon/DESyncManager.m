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

static PFQuery *globalQuery;

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

        }
        else {
            // The find failed, let the customer know
            NSLog(@"Error: %@", [error description]);
        }
    }];
}

/*
 
 Get one post by its Id and then display the comment view if Comment is set to YES, otherwise, prompt the user to comment
 
 */
+ (void) getPostById:(NSString *)eventId
             Process:(NSString *) process
{
    PFQuery *query = [PFQuery queryWithClassName:PARSE_CLASS_NAME_EVENT];
    [query whereKey:PARSE_CLASS_EVENT_OBJECT_ID equalTo:eventId];
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
       if (!error)
       {
           DEPost *post = [DEPost getPostFromPFObject:object];
           if ([process isEqualToString:SHOW_COMMENT_VIEW])
           {
               [DEScreenManager showCommentView:post];
               [[DELocationManager sharedManager] stopMonitoringRegionForPost:post];
           }
           else if ([process isEqualToString:PROMPT_COMMENT_FOR_EVENT]) {
               [DEScreenManager promptForComment:post.objectId Post:post];
               [[DELocationManager sharedManager] stopMonitoringRegionForPost:post];
           }
           else if ([process isEqualToString:SEE_IF_CAN_COMMENT])
           {
               if (([[NSDate date] compare:post.startTime] == NSOrderedDescending)  && ([[NSDate date] compare:post.endTime] == NSOrderedAscending))
               {
                   // Prompt for the comment and then stop monitoring for the region
                   [DEScreenManager promptForComment:post.objectId Post:post];
                   [[DELocationManager sharedManager] stopMonitoringRegionForPost:post];
               }
               else if ([[NSDate date] compare:post.endTime] == NSOrderedAscending) // User is early
               {
                   [DEScreenManager createPromptUserCommentNotification:post TimeToShow:post.startTime isFuture:YES];
               }
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
    static int objectsCount = 0;
    
    PFQuery *query = [DESyncManager getBasePFQueryForNow:now];

    globalQuery = query;
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
    if (miles < 5)
    {
        miles ++;
    }
    else {
        miles += 5;
    }
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error)
        {
            objectsCount += [objects count];
            BOOL isNewProcess = NO;
            if (miles == 1)
            {
                isNewProcess = YES;
            }
            // Check to see if we need to store this data and finish loading
            [DESyncManager addEventsToAlreadyRetrievedEvents : objects PostsArray:postsArray ProcessStatus:kNOTIFICATION_CENTER_USER_INFO_USER_PROCESS_STILL_LOADING isNewProcess:isNewProcess];
            if (miles < 35)
            {
                [DESyncManager getAllValuesWithinMilesForNow:now PostsArray:postsArray Location:location];
            }
            else {
                if (([[[DEPostManager sharedManager] posts] count] < 10 && now) || ([[[DEPostManager sharedManager] posts] count] == 0 && !now))
                {
                    [self getAllValuesForLaterNearbyWithQuery : blockQuery
                                                      Location:location
                                                  isNewProcess:NO];
                }
                else {
                    [DESyncManager addEventsToAlreadyRetrievedEvents : objects
                                                           PostsArray:postsArray
                                                        ProcessStatus:kNOTIFICATION_CENTER_USER_INFO_USER_PROCESS_FINISHED_LOADING isNewProcess:isNewProcess];
                    
                    __block int counter = 0;
                    [postsArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        PFObject *event = (PFObject *) obj;
                        event[TRENDING_ORDER] = [NSNumber numberWithInt:counter];
                        counter ++;
                    }];
                }
                // Set the miles to zero so that the next time the events are loaded we load them from all to 25 miles distance
                miles = 0;
                [[DEScreenManager sharedManager] hideIndicatorIsPosting:NO];
            }

        }
        else {
            // The find failed, let the customer know
            NSLog(@"Error: %@", [error description]);
        }
    }];
}


+ (void) getAllValuesForLaterNearbyWithQuery : (PFQuery *) query
                                    Location : (PFGeoPoint *) location
                                isNewProcess : (BOOL) isNewProcess
{
    
    // Get any values that are later
    query = [PFQuery queryWithClassName:PARSE_CLASS_NAME_EVENT];
    
    NSLog(@"Latitude - %f - Longitude %f retrieving events for", [[DELocationManager sharedManager] currentLocation].latitude, [[DELocationManager sharedManager] currentLocation].longitude );
    
    // Make sure that the values for later are only those within thirty miles of the location the user is checking for
    [query whereKey:PARSE_CLASS_EVENT_LOCATION nearGeoPoint:[[DELocationManager sharedManager] currentLocation] withinMiles:30];

    [self getValuesForLater:query
                    Objects:[[DEPostManager sharedManager] posts]
              ProcessStatus:kNOTIFICATION_CENTER_USER_INFO_USER_PROCESS_FINISHED_LOADING
                   Location:location
     isNewProcess:isNewProcess];

}


+ (PFQuery *) getBasePFQueryForNow : (BOOL) now {
    PFQuery *query = [PFQuery queryWithClassName:PARSE_CLASS_NAME_EVENT];
    
    //Get all the events that are currently active and less than three hours away to start
    NSDate *date = [NSDate date];
    NSTimeInterval threeHours = (3 * 60 * 60) - 1;
    NSDate *later = [date dateByAddingTimeInterval:threeHours];
    
    [query whereKey:PARSE_CLASS_EVENT_ACTIVE equalTo:[NSNumber numberWithBool:true]];
    [query orderByDescending:PARSE_CLASS_EVENT_THUMBS_UP_COUNT];
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
                                        Location:[[DELocationManager sharedManager]  currentLocation]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [NSTimer scheduledTimerWithTimeInterval:8 target:self selector:@selector(takingTooLongToConnect) userInfo:nil repeats:NO];
    });

}
// Show a view that shows that it's taken too long to connect to the server
+ (void) takingTooLongToConnect {
    
    if (![[DEPostManager sharedManager] posts])
    {
        UIViewController *viewController = (UIViewController *) [DEScreenManager getMainNavigationController].topViewController;
        if ([viewController isKindOfClass:[DEViewEventsViewController class]])
        {
            DEViewEventsViewController *eventViewController = (DEViewEventsViewController *) viewController;
            
            UIView *tooLongToConnectView = [[[NSBundle mainBundle] loadNibNamed:@"viewTooLongToConnect" owner:viewController options:nil] firstObject];
            
            [[tooLongToConnectView subviews] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                if ([obj isKindOfClass:[UIButton class]])
                {
                    UIButton *button = (UIButton *) obj;
                    [[button layer] setCornerRadius:BUTTON_CORNER_RADIUS];
                }
            }];
            
            [eventViewController.view addSubview:tooLongToConnectView];
            [DEAnimationManager animateView:tooLongToConnectView WithInsets:UIEdgeInsetsZero WithSelector:nil];
        }
    }
}

// Store the events that we just recieved from Parse and notify the app
+ (void) addEventsToAlreadyRetrievedEvents : (NSArray *) objects
                                PostsArray : (NSMutableArray *) postsArray
                             ProcessStatus : (NSString *) process
                              isNewProcess : (BOOL) isNewProcess
{
    DEPostManager *sharedManager = [DEPostManager sharedManager];
    [postsArray addObjectsFromArray:objects];
    // Add all the events loaded to an array and store so that we don't pull these events down again
    [objects enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [[[DEPostManager sharedManager] loadedEvents] addObject:[obj objectId]];
    }];
    
    [sharedManager setPosts:postsArray];
    [sharedManager setAllEvents:postsArray];
    
    if (isNewProcess)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CENTER_ALL_EVENTS_LOADED object:nil userInfo:@{ kNOTIFICATION_CENTER_USER_INFO_USER_PROCESS : process,
                kNOTIFICATION_CENTER_USER_INFO_CATEGORY : CATEGORY_TRENDING
        }];
    }
    NSLog(@"Notification sent, events loaded");
}


+ (void) getAllSavedEvents {
    
    PFQuery *query = [PFQuery queryWithClassName:PARSE_CLASS_NAME_EVENT];
    [query whereKey:PARSE_CLASS_EVENT_ACTIVE equalTo:[NSNumber numberWithBool:true]];
    NSMutableArray *eventsToGetFromServerIds = [NSMutableArray new];
    
    NSMutableArray *allSavedEvents = [[[DEPostManager sharedManager] goingPost] mutableCopy];
    [allSavedEvents addObjectsFromArray:[[DEPostManager sharedManager] maybeGoingPost]];
    
    for (NSString *eventId in allSavedEvents) {
        if (![[[DEPostManager sharedManager] loadedSavedEventIds] containsObject:eventId])
        {
            [[[DEPostManager sharedManager] loadedSavedEventIds] addObject:eventId];
            [eventsToGetFromServerIds addObject:eventId];
        }
    }
    
    if ([eventsToGetFromServerIds count] != 0)
    {
        // Get all the events where the end time ended at the least an hour before the current time
        [query whereKey:PARSE_CLASS_EVENT_END_TIME greaterThan:[NSDate dateWithTimeIntervalSinceNow:-60 * 60]];
        [query whereKey:PARSE_CLASS_EVENT_OBJECT_ID containedIn:eventsToGetFromServerIds];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
           if (!error)
           {
               // If there are no saved events that are earlier than now
               if ([objects count] != 0)
               {
                   [[[DEPostManager sharedManager] loadedSavedEvents] addObjectsFromArray:objects];
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
                  Location : (PFGeoPoint *) location
              isNewProcess : (BOOL) isNewProcess
{
    NSDate *date = [NSDate date];
    NSTimeInterval threeHours = (3 * 60 * 60) - 1;
    NSDate *later = [date dateByAddingTimeInterval:threeHours];
    NSDate *latestDate = [date dateByAddingTimeInterval:(60 * 60 * 24 * 3)];
    __block BOOL blkIsNewProcess = isNewProcess;
    [query setLimit:10];
    [query whereKey:PARSE_CLASS_EVENT_START_TIME greaterThan:later];
    [query whereKey:PARSE_CLASS_EVENT_START_TIME lessThan:latestDate];
    [query orderByAscending:PARSE_CLASS_EVENT_START_TIME];
    [query whereKey:PARSE_CLASS_EVENT_LOCATION nearGeoPoint:location withinMiles:30];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if ([objects count] == 0  && [myObjects count] == 0)
        {
            [self loadEpicEvents:NO];
        }
        else
        {
            //The find succeeded, now do something with it
            NSMutableArray *array = (NSMutableArray *) [[DEPostManager sharedManager] posts];
            [DESyncManager addEventsToAlreadyRetrievedEvents:objects PostsArray:array ProcessStatus:kNOTIFICATION_CENTER_USER_INFO_USER_PROCESS_FINISHED_LOADING isNewProcess:blkIsNewProcess];
            
            if (!blkIsNewProcess)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LATER_EVENTS_ADDED object:nil];
            }
            
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
    [query whereKey:PARSE_CLASS_EVENT_ACTIVE equalTo:[NSNumber numberWithBool:true]];
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
            if (!error)
            {
                NSLog(@"Saved successfully");
            }
            else
            {
                NSLog(@"Oh snap, something happened! - %@", error.description);
            }
        }];
    }];
}

+ (void) updatePFObject : (PFObject *) postObject
     WithValuesFromPost : (DEPost *) post {
    postObject = [self getPFObjectWithValuesFromPost:post PFObject:postObject];
    [postObject setObject:@NO forKey:@"loaded"];
    [postObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"happsnap.objectupdated");
        }
        else {
            NSLog(@"happsnap.updatefailedforobject");
        }
    }];
}

+ (void) deletePostWithId : (NSString *) objectId {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"objectId == %@", objectId];
    PFObject *object = (PFObject *) [[[[DEPostManager sharedManager] posts] filteredArrayUsingPredicate:predicate] firstObject];
    [object setObject:@NO forKey:@"loaded"];
    [object setObject:[NSNumber numberWithBool:false] forKey:PARSE_CLASS_EVENT_ACTIVE];
    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error)
        {
            NSLog(@"happsnap.objectupdatedtonotactive - %@", objectId);
        }
        else {
            NSLog(@"happsnap.objectupdatetonotactivefailedwithid - %@", objectId);
        }
    }];
}

+ (void) getPFObjectForEventObjectIdAndUpdate:(NSString *)objectId
                                 WithPost : (DEPost *) post{
    
    PFQuery *query = [PFQuery queryWithClassName:PARSE_CLASS_NAME_EVENT];
    [query whereKey:PARSE_CLASS_EVENT_OBJECT_ID equalTo:objectId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
       if (!error)
       {
           PFObject *object = [objects firstObject];
           // Update the object with the new values
           [DESyncManager updatePFObject:object WithValuesFromPost:post];
       }
    }];
}

+ (PFObject *) getPFObjectWithValuesFromPost : (DEPost *) post
                              PFObject : (PFObject *) postObject
{
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
    postObject[PARSE_CLASS_EVENT_THUMBS_UP_COUNT] = post.thumbsUpCount;
    postObject[PARSE_CLASS_EVENT_WEBSITE] = post.website;
    postObject[PARSE_CLASS_EVENT_STATUS] = PARSE_CLASS_EVENT_STATUS_POSTED;
    
    return postObject;
}


+ (BOOL) savePost : (DEPost *) post {
    DEPostManager *sharedManager = [DEPostManager sharedManager];
    PFObject *postObject = [PFObject objectWithClassName:PARSE_CLASS_NAME_EVENT];
    postObject = [self getPFObjectWithValuesFromPost:post PFObject:postObject];

    // If it saved successful return that it was successful and vice versa.
    [postObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded)
        {
            NSLog(@"Post Saved to Parse Server");
            NSMutableArray *array = [NSMutableArray arrayWithArray : [sharedManager posts]];
            [array addObject:postObject];
            
            [sharedManager setPosts:array];
            [self updatePostCountForUser];
            [[DEScreenManager sharedManager] hideIndicatorIsPosting:YES];
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
    if ([PFUser currentUser])
    {
        commentObject[PARSE_CLASS_COMMENT_USER] = [PFUser currentUser];
    }
    
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
        
        UIImage *image = [UIImage imageWithData:imageData];
        CGFloat width = [image size].width;
        CGFloat height = [image size].height;
        
        PFFile *imageFile = [PFFile fileWithName:[NSString stringWithFormat:@"post-image%@%f%@%f", IMAGE_DIMENSION_WIDTH, width, IMAGE_DIMENSION_HEIGHT, height] data:imageData];
        
        [images addObject:imageFile];
    }
    
    return images;
}

+ (void) saveUpdatedPFObjectToServer : (PFObject *) post {
    
    [post saveEventually:^(BOOL succeeded, NSError *error) {
        if (succeeded)
        {
            NSLog(@"The post object was saved successfuly: %@", post.objectId);
        }
        else {
            NSLog(@"Error saving the post object: %@", [error description]);
        }
    }];
}

+ (void) getEventsPostedByUser:(NSString *)username {
    [globalQuery cancel];
    PFQuery *query = [PFQuery queryWithClassName:PARSE_CLASS_NAME_EVENT];

    [query whereKey:PARSE_CLASS_EVENT_USERNAME equalTo:username];
    [query whereKey:PARSE_CLASS_EVENT_ACTIVE equalTo:[NSNumber numberWithBool:true]];
    [query whereKey:PARSE_CLASS_EVENT_END_TIME greaterThan:[NSDate date]];
    [query setLimit:15];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error)
            {
                [[DEPostManager sharedManager] setPosts:objects];
                // Notify that events have just been loaded from the server
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CENTER_USERS_EVENTS_LOADED object:nil userInfo:@{ kNOTIFICATION_CENTER_USER_INFO_USER_PROCESS : kNOTIFICATION_CENTER_USER_INFO_USER_PROCESS_FINISHED_LOADING, kNOTIFICATION_CENTER_USER_INFO_CATEGORY : NOTIFICATION_CENTER_USER_INFO_POSOTED_BY_ME }];
            }
    }];
}


@end
