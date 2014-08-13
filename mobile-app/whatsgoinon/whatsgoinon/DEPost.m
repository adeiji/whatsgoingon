//
//  DEPost.m
//  whatsgoinon
//
//  Created by adeiji on 8/5/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import "DEPost.h"
#import "Constants.h"

@implementation DEPost

+ (DEPost *) getPostFromPFObject:(PFObject *)object {
 
    DEPost *post = [DEPost new];
    
    post.category = object[PARSE_CLASS_EVENT_CATEGORY];
    post.startTime = object[PARSE_CLASS_EVENT_START_TIME];
    post.endTime = object[PARSE_CLASS_EVENT_END_TIME];
    post.location = object[PARSE_CLASS_EVENT_LOCATION];
    post.postRange = object[PARSE_CLASS_EVENT_POST_RANGE];
    post.cost = object[PARSE_CLASS_EVENT_COST];
    post.images = object[PARSE_CLASS_EVENT_IMAGES];
    post.active = object[PARSE_CLASS_EVENT_ACTIVE];
    post.title = object[PARSE_CLASS_EVENT_TITLE];
    post.description = object[PARSE_CLASS_EVENT_DESCRIPTION];
    
    return post;
}

@end
