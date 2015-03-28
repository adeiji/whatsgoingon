//
//  DEPostManager.m
//  whatsgoinon
//
//  Created by adeiji on 8/5/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import "DEPostManager.h"
#import "DEPost.h"
#import "DEAppDelegate.h"

@implementation DEPostManager

@synthesize posts = _posts;

static NSString *CATEGORY_ANYTHING = @"Anything";
static NSString *ARCHIVE_FILE = @"archive";
static NSString *kGoingPostForNoAccount = @"goingPostForNoAccount";
static NSString *kMaybeGoingPostForNoAccount = @"maybeGoingPostForNoAccount";

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
        _maybeGoingPost = [NSMutableArray new];
        _loadedSavedEventIds = [NSMutableArray new];
        _loadedSavedEvents = [NSMutableArray new];
        _currentPost = [DEPost new];
        _loadedEvents = [NSMutableArray new];
        _promptedForComment = [NSMutableArray new];
        _goingPostForNoAccount = [NSMutableArray new];
        _maybeGoingPostForNoAccount = [NSMutableArray new];
        [self loadNoAccountInformation];
    }
    return self;
}

- (void) saveNoAccountInformation {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:_goingPostForNoAccount forKey:kGoingPostForNoAccount];
    [userDefaults setObject:_maybeGoingPostForNoAccount forKey:kMaybeGoingPostForNoAccount];
    [userDefaults synchronize];
}

- (void) loadNoAccountInformation {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *goingPostForNoAccount = [[userDefaults objectForKey:kGoingPostForNoAccount] mutableCopy];
    NSMutableArray *maybeGoingPostForNoAccount = [[userDefaults objectForKey:kMaybeGoingPostForNoAccount] mutableCopy];
    
    if (goingPostForNoAccount)
    {
        _goingPostForNoAccount = goingPostForNoAccount;
    }
    if (maybeGoingPostForNoAccount)
    {
        _maybeGoingPostForNoAccount = maybeGoingPostForNoAccount;
    }
    
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
        // Get the amount of seconds until the start of the event
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
    if (![category isEqualToString:CATEGORY_TRENDING] && ![category isEqualToString:CATEGORY_ANYTHING])
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
    else if ([category isEqualToString:CATEGORY_TRENDING]) {  // If this is trending then we want to display all the best events
        
        [events sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            PFObject *post1 = (PFObject *) obj1;
            PFObject *post2 = (PFObject *) obj2;

            return [post1[TRENDING_ORDER] compare:post2[TRENDING_ORDER]];
        }];

        
        [events enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            DEPost *event = [DEPost getPostFromPFObject:obj];
            if ([event.postRange isEqual:@0])
            {
                [eventsInCategory addObject:obj];
            }
            obj[@"loaded"] = @NO;
        }];
    }
    else if ([category isEqualToString:CATEGORY_ANYTHING])
    {
        [events sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            PFObject *post1 = (PFObject *) obj1;
            PFObject *post2 = (PFObject *) obj2;

            NSDate *startTimePost1 = post1[PARSE_CLASS_EVENT_START_TIME];
            NSDate *startTimePost2 = post2[PARSE_CLASS_EVENT_START_TIME];
            
            return [startTimePost1 compare:startTimePost2];
        }];

        [events enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            obj[@"loaded"] = @NO;
            [eventsInCategory addObject:obj];
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
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CENTER_ORB_CLICKED object:nil userInfo:categoryDictionary];
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
