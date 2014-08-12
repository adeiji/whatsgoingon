//
//  DELocationManager.h
//  whatsgoinon
//
//  Created by adeiji on 8/6/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <Parse/Parse.h>

@interface DELocationManager : NSObject <CLLocationManagerDelegate, NSURLConnectionDelegate>


typedef void (^completionBlock) (NSString *distance);

- (PFGeoPoint *) geoPoint;
+ (id)sharedManager;
- (void) startSignificantChangeUpdates;
- (void) stopSignificantChangeUpdates;
+ (void) getDistanceInMilesBetweenLocation : (PFGeoPoint *) location1
                               LocationTwo : (PFGeoPoint *) location2
                           CompletionBlock : (completionBlock) callback;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) PFGeoPoint *currentLocation;
@property (strong, nonatomic) PFGeoPoint *geoPoint;
@property (strong, nonatomic) NSMutableData *responseData;

@end
