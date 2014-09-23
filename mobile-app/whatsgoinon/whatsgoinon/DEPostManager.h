//
//  DEPostManager.h
//  whatsgoinon
//
//  Created by adeiji on 8/5/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "DESyncManager.h"

@class DEPost;

@interface DEPostManager : NSObject

+ (DEPost *) createPostWithCategory : (NSString *) category
                      StartTime : (NSDate *) startTime
                        EndTime : (NSDate *) endTime
                       Location : (PFGeoPoint *) location
                      PostRange : (NSNumber *) postRange
                          Title : (NSString *) title
                           Cost : (NSNumber *) cost
                         Images : (NSArray *) images
                    Description : (NSString *) description
                        Address : (NSString *) address
                   QuickDescription : (NSString *) quickDescription;

+ (NSString *) getTimeUntilStartOrFinishFromPost : (DEPost *) post;
+ (BOOL) isBeforeEvent : (DEPost *) post;
+ (NSNumber *) getDurationOfEvent : (DEPost *) event;


// Stores the current post when one post is being viewed, edited or created
@property (strong, nonatomic) DEPost *currentPost;

// Stores all the posts that will be viewed currently
@property (strong, nonatomic) NSArray *posts;
// Stores all the post that you are going to for sure
@property (strong, nonatomic) NSMutableArray *goingPost;
@property (strong, nonatomic) NSMutableArray *maybeGoingPost;
@property (strong, nonatomic) NSArray *allEvents;
+ (id)sharedManager;

@end
