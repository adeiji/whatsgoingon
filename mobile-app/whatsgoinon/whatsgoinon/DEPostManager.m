//
//  DEPostManager.m
//  whatsgoinon
//
//  Created by adeiji on 8/5/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import "DEPostManager.h"
#import "DEPost.h"

@implementation DEPostManager

@synthesize posts = _posts;

+ (id) sharedManager {
    static DEPostManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        _goingPost = [NSMutableArray new];
        _eventsUserAt = [NSMutableArray new];
        _loadedSavedEventIds = [NSMutableArray new];
        _loadedSavedEvents = [NSMutableArray new];
        _currentPost = [DEPost new];
        _promptedForCommentEvents = [NSMutableArray new];
        _goingPostWithCommentInformation = [NSMutableArray new];
        _loadedEvents = [NSMutableArray new];
    }
    return self;
}

+ (DEPost *) createPostWithCategory:(NSString *)category
                          StartTime:(NSDate *)startTime
                            EndTime:(NSDate *)endTime
                           Location:(PFGeoPoint *)location
                          PostRange:(NSNumber *)postRange
                              Title:(NSString *)title
                               Cost:(NSNumber *)cost
                             Images:(NSArray *)images
                        Description:(NSString *)description
                            Address:(NSString *)address
                   QuickDescription:(NSString *)quickDescription
                           Username:(NSString *) username
                          ViewCount:(NSNumber *) viewCount
                      ThumbsUpCount:(NSNumber *) thumbsUpCount
{
    DEPost *post = [DEPost new];
    post.address = address;
    post.category = category;
    post.startTime = startTime;
    post.endTime = endTime;
    post.location = location;
    post.postRange = postRange;
    post.title = title;
    post.cost = cost;
    post.images = images;
    post.myDescription = description;
    post.quickDescription = quickDescription;
    post.numberGoing = [NSNumber numberWithInt:0];
    post.comments = [NSArray new];
    post.username = [[PFUser currentUser] username];
    post.viewCount = viewCount;
    post.thumbsUpCount = thumbsUpCount;
    
    return post;
}

+ (BOOL) isBeforeEvent : (DEPost *) post
{
    // Has already started
    if ([[post startTime] compare:[NSDate date]] == NSOrderedAscending)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

+ (NSNumber *) getDurationOfEvent : (DEPost *) event
{
    NSTimeInterval secondsOfEvent = [[event endTime] timeIntervalSinceDate:[event startTime]];
    
    NSNumber *hours = [NSNumber numberWithDouble:secondsOfEvent / 3600];
    
    return hours;
}

+ (NSString *) getTimeUntilStartOrFinishFromPost : (DEPost *) post
{
    // Event has already started
    if ([[post startTime] compare:[NSDate date]] == NSOrderedAscending)
    {
        // Get the amount of seconds until the end of the event
        NSTimeInterval distanceBetweenDates = [[post endTime] timeIntervalSinceDate:[NSDate date]];
        return [self convertToHoursAndMinutesFromSeconds:distanceBetweenDates];
    }
    else
    {
        // Get the amount of seconds until the end of the event
        NSTimeInterval distanceBetweenDates = [[post startTime] timeIntervalSinceDate:[NSDate date]];
        return [self convertToHoursAndMinutesFromSeconds:distanceBetweenDates];
    }
    return nil;
}


+ (NSString *) convertToHoursAndMinutesFromSeconds : (NSTimeInterval) seconds
{
    if (seconds < 0)
    {
        return @"DONE";
    }
    
    NSInteger secondsInMinute = 60;
    NSInteger minutesUntilEnd = seconds / secondsInMinute;
    NSInteger hours = minutesUntilEnd / 60;
    NSInteger days = hours / 24;
    NSInteger hoursUntilEnd = hours % 24;
    NSInteger minutes = minutesUntilEnd % 60;
    
    if (days != 0)
    {
        return [NSString stringWithFormat:@"%lddays", (long)days];
    }
    else if (hours != 0)
    {
        return [NSString stringWithFormat:@"%ldhr%02ld", (long)hoursUntilEnd, (long)minutes];
    }
    
    return [NSString stringWithFormat:@"%02ldmins", (long)minutes];
}

+ (void) getPostInCategory : (NSString *) category
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNOTIFICATION_CENTER_USER_INFO_USER_PROCESS_NEW object:nil];
    NSArray *events = [[DEPostManager sharedManager] allEvents];
    NSMutableArray *eventsInCategory = [NSMutableArray new];
    NSDictionary *categoryDictionary = @{ kNOTIFICATION_CENTER_USER_INFO_CATEGORY : category,
                                          kNOTIFICATION_CENTER_USER_INFO_USER_PROCESS : kNOTIFICATION_CENTER_USER_INFO_USER_PROCESS_FINISHED_LOADING };
    if (![category isEqualToString:CATEGORY_TRENDING])
    {
        [events enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            DEPost *event = [DEPost getPostFromPFObject:obj];
            
            if ([event.category isEqualToString:category] )
            {
                [eventsInCategory addObject:obj];
            }
            obj[@"loaded"] = @NO;
        }];
    }
    else {  // If this is trending then we want to display all the best events
        [events enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            DEPost *event = [DEPost getPostFromPFObject:obj];
            if ([event.postRange isEqual:@0])
            {
                [eventsInCategory addObject:obj];
            }
            obj[@"loaded"] = @NO;
        }];
        
    }
    
    [self sendNotificationThatTheEventsWereLoaded : eventsInCategory
                               CategoryDictionary : categoryDictionary];

}

+ (void) sendNotificationThatTheEventsWereLoaded : (NSMutableArray *) eventsInCategory
                              CategoryDictionary : (NSDictionary *) categoryDictionary
{
    if ([eventsInCategory count] > 0)
    {
        [[DEPostManager sharedManager] setPosts:eventsInCategory];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CENTER_ALL_EVENTS_LOADED object:nil userInfo:categoryDictionary];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CENTER_NONE_IN_CATEGORY object:nil userInfo:categoryDictionary];
    }
}

- (PFObject *) getPFObjectForEventWithObjectId : (NSString *) objectId
                                     WithArray : (NSArray *) array {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"objectId == %@", objectId];
    // Get the PFObject that corresponds to this post
    PFObject *object = (PFObject *) [[array filteredArrayUsingPredicate:predicate] firstObject];
    
    return object;
}

- (void) deletePFObjectWithObjectId : (NSString *) objectId {
    NSMutableArray *postsCopy = [_posts mutableCopy];
    PFObject *object = [self getPFObjectForEventWithObjectId:objectId
                                                   WithArray:postsCopy];
    [postsCopy removeObject:object];
    _posts = postsCopy;
    [self setAllPostToNotLoaded];
}

- (void) setAllPostToNotLoaded {
    [_posts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        obj[@"loaded"] = @NO;
    }];
}

- (DEPost *) getCurrentPost {
    if (_currentPost == nil)
    {
        _currentPost = [DEPost new];
    }
    
    return _currentPost;
}

@end
