//
//  DEPostManager.h
//  whatsgoinon
//
//  Created by adeiji on 8/5/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DEPost.h"
#import "DESyncManager.h"

@interface DEPostManager : NSObject

+ (DEPost *) createPostWithCategory : (NSString *) category
                      StartTime : (NSDate *) startTime
                        EndTime : (NSDate *) endTime
                       Location : (PFGeoPoint *) location
                      PostRange : (NSNumber *) postRange
                          Title : (NSString *) title
                           Cost : (NSNumber *) cost
                         Images : (NSArray *) images
                    Description : (NSString *) description;


// Stores the current post when one post is being viewed, edited or created
@property (strong, nonatomic) DEPost *currentPost;

// Stores all the posts that will be viewed currently
@property (strong, nonatomic) NSArray *posts;

+ (id)sharedManager;

@end
