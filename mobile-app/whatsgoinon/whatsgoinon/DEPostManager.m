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
    post.description = description;

    
    return post;
}



@end
