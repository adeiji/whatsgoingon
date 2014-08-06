//
//  DELocationManager.h
//  whatsgoinon
//
//  Created by adeiji on 8/6/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DELocation.h"
#import <CoreLocation/CoreLocation.h>
#import <Parse/Parse.h>

@interface DELocationManager : NSObject <CLLocationManagerDelegate>

- (PFGeoPoint *) geoPoint;
+ (id)sharedManager;
- (void) startSignificantChangeUpdates;
- (void) stopSignificantChangeUpdates;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) DELocation *currentLocation;
@property (strong, nonatomic) PFGeoPoint *geoPoint;

@end
