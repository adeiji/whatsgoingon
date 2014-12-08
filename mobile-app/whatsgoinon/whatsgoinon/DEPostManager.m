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
        #warning - This needs to be stored to memory before closing
        _goingPost = [NSMutableArray new];
        _currentPost = [DEPost new];
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
    return nil;
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

- (DEPost *) getCurrentPost {
    if (_currentPost == nil)
    {
        _currentPost = [DEPost new];
    }
    
    return _currentPost;
}

@end
