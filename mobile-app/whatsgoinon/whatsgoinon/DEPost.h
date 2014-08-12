//
//  DEPost.h
//  whatsgoinon
//
//  Created by adeiji on 8/5/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface DEPost : NSObject

@property (strong, nonatomic) NSString *category;
@property (strong, nonatomic) NSDate *startTime;
@property (strong, nonatomic) NSDate *endTime;
@property (strong, nonatomic) PFGeoPoint *location;
@property (strong, nonatomic) NSNumber *postRange;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSNumber *cost;
@property (strong, nonatomic) NSArray *images;
@property (strong, nonatomic) NSString *description;
@property BOOL active;

@end
