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

- (id) init
{
    if ([super init] == self)
    {
        _images = [NSMutableArray new];
        _cost = [NSNumber new];
        _numberGoing = [NSNumber numberWithInt:0];
        _comments = [NSArray new];
        _viewCount = [NSNumber numberWithInt:0];
        _thumbsUpCount = [NSNumber numberWithInt:0];
    }
    
    return self;
}

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
    post.myDescription = object[PARSE_CLASS_EVENT_DESCRIPTION];
    post.objectId = object.objectId;
    post.comments = object[PARSE_CLASS_EVENT_COMMENTS];
    post.rating = object[PARSE_CLASS_EVENT_RATING];
    post.address = object[PARSE_CLASS_EVENT_ADDRESS];
    post.quickDescription = object[PARSE_CLASS_EVENT_QUICK_DESCRIPTION];
    post.numberGoing = object[PARSE_CLASS_EVENT_NUMBER_GOING];
    post.comments = object[PARSE_CLASS_EVENT_COMMENTS];
    post.username = object[PARSE_CLASS_EVENT_USERNAME];
    post.viewCount = object[PARSE_CLASS_EVENT_VIEW_COUNT];
    post.thumbsUpCount = object[PARSE_CLASS_EVENT_THUMBS_UP_COUNT];
    
    return post;
}

- (NSString *) toString {
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"EEE, MMM d HH:MM a"];
    
    NSString *startTime = [dateFormatter stringFromDate:_startTime];
    NSString *endTime = [dateFormatter stringFromDate:_endTime];
    
    return [NSString stringWithFormat:@"HaxS \nTitle: %@\nDescription: %@\nAddress: %@\nStart Time: %@\nEnd Time: %@\nCost: %@",
            _title,
            _myDescription,
            _address,
            startTime,
            endTime,
            _cost];
}

- (id) copyWithZone:(NSZone *)zone {
    id copy = [[[self class] alloc] init];
    
    if (copy)
    {
        [copy setCategory:[_category copyWithZone:zone]];
        [copy setStartTime:[_startTime copyWithZone:zone]];
        [copy setEndTime:[_category copyWithZone:zone]];
        [copy setLocation:[_location copyWithZone:zone]];
        [copy setAddress:[_address copyWithZone:zone]];
        [copy setPostRange:[_postRange copyWithZone:zone]];
        [copy setTitle:[_title copyWithZone:zone]];
        [copy setCost:[_cost copyWithZone:zone]];
        [copy setImages:[_images copyWithZone:zone]];
        [copy setMyDescription:[_myDescription copyWithZone:zone]];
        [copy setObjectId:[_objectId copyWithZone:zone]];
        [copy setComments:[_comments copyWithZone:zone]];
        [copy setRating:[_rating copyWithZone:zone]];
        [copy setQuickDescription:[_quickDescription copyWithZone:zone]];
        [copy setNumberGoing:[_numberGoing copyWithZone:zone]];
        [copy setUsername:[_username copyWithZone:zone]];
        [copy setWebsite:[_website copyWithZone:zone]];
        [copy setViewCount:[_viewCount copyWithZone:zone]];
        [copy setThumbsUpCount:[_thumbsUpCount copyWithZone:zone]];
    }
    
    return copy;
}

@end
