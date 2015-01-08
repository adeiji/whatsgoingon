//
//  DEPost.h
//  whatsgoinon
//
//  Created by adeiji on 8/5/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "DELocationManager.h"

@interface DEPost : NSObject

@property (strong, nonatomic) NSString *category;
@property (strong, nonatomic) NSDate *startTime;
@property (strong, nonatomic) NSDate *endTime;
@property (strong, nonatomic) PFGeoPoint *location;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSNumber *postRange;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSNumber *cost;
@property (strong, nonatomic) NSArray *images;
@property (strong, nonatomic) NSString *myDescription;
@property (strong, nonatomic) NSString *objectId;
@property (strong, nonatomic) NSArray *comments;
@property (strong, nonatomic) NSNumber *rating;
@property (strong, nonatomic) NSString *quickDescription;
@property (strong, nonatomic) NSNumber *numberGoing;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *website;
@property (strong, nonatomic) NSNumber *viewCount;
@property (strong, nonatomic) NSNumber *thumbsUpCount;
@property BOOL active;

+ (DEPost *) getPostFromPFObject : (PFObject *) object;
- (NSString *) toString;

@end
