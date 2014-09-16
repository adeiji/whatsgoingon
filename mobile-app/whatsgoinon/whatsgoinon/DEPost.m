//
//  DEPost.m
//  whatsgoinon
//
//  Created by adeiji on 8/5/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import "Constants.h"
#import "DEPost.h"

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
    post.objectId = object.objectId;
    post.comments = object[PARSE_CLASS_EVENT_COMMENTS];
    post.rating = object[PARSE_CLASS_EVENT_RATING];
    post.address = object[PARSE_CLASS_EVENT_ADDRESS];
    post.quickDescription = object[PARSE_CLASS_EVENT_QUICK_DESCRIPTION];
    post.numberGoing = object[PARSE_CLASS_EVENT_NUMBER_GOING];
    post.comments = object[PARSE_CLASS_EVENT_COMMENTS];
    
    return post;
}

- (NSString *) toString {
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"EEE, MMM d HH:MM a"];
    
    NSString *startTime = [dateFormatter stringFromDate:_startTime];
    NSString *endTime = [dateFormatter stringFromDate:_endTime];
    
    return [NSString stringWithFormat:@"HaxS \nTitle: %@\nDescription: %@\nAddress: %@\nStart Time: %@\nEnd Time: %@\nCost: %@",
            _title,
            _description,
            _address,
            startTime,
            endTime,
            _cost];
}

@end
