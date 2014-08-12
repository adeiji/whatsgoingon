//
//  DELocationManager.m
//  whatsgoinon
//
//  Created by adeiji on 8/6/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import "DELocationManager.h"

@implementation DELocationManager

#define GOOGLE_MATRIX_DISTANCE_API @"http://maps.googleapis.com/maps/api/distancematrix/json?origins=%@&destinations=%@&sensor=false&key=AIzaSyDuVa4zdofqE5f7z4wkmi6dw--0HQYm5Ho"

// Do we need to make sure that the user is using location services or not upon application upload?

//it’s recommended that you always call the locationServicesEnabled class method of CLLocationManager before attempting to start either the standard or significant-change location services. If it returns NO and you attempt to start location services anyway, the system prompts the user to confirm whether location services should be re-enabled. Because the user probably disabled location services on purpose, the prompt is likely to be unwelcome.


- (PFGeoPoint *) geoPoint {
    PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLatitude:[_currentLocation.latitude doubleValue] longitude:[_currentLocation.longitude doubleValue]];

    return geoPoint;
}

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    PFGeoPoint *location = [PFGeoPoint new];
    //Get the latitude and longitude values of the current user
    _currentLocation.latitude = [NSNumber numberWithDouble:[[locations objectAtIndex:0] coordinate].latitude];
    _currentLocation.longitude = [NSNumber numberWithDouble:[[locations objectAtIndex:0] coordinate].longitude];

    //Stop updating the location because now it is uneccesary
    [_locationManager stopUpdatingLocation];
}

+ (id)sharedManager {
    static DELocationManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        if (nil == _locationManager)
        {
            _locationManager = [CLLocationManager new];
        }
        
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = 500; //Meters
        
        [_locationManager startUpdatingLocation];
        
        _currentLocation = [DELocation new];
    }
    return self;
}

- (void)startSignificantChangeUpdates
{
    // Create the location manager if this object does not
    // already have one.
    if (nil == _locationManager)
    {
        _locationManager = [[CLLocationManager alloc] init];
    }
    
    _locationManager.delegate = self;
    [_locationManager startMonitoringSignificantLocationChanges];
}

- (void) stopSignificantChangeUpdates {
    [_locationManager stopMonitoringSignificantLocationChanges];
}
// Call the Google Maps API and get the distance between the two points given, but this would be the distance that would actually be traveled as opposed to a straight line between the two points.
+ (NSNumber *) getDistanceInMilesBetweenLocation : (DELocation *) location1
                                     LocationTwo : (DELocation *) location2
{

    NSLog(@"Getting the distance in Miles between location: %@ & location: %@", location1, location2);
    
    NSString *loc1String = [NSString stringWithFormat:@"%@,%@", location1.latitude,location1.longitude];
    NSString *loc2String = [NSString stringWithFormat:@"%@,%@", location2.latitude,location2.longitude];

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:GOOGLE_MATRIX_DISTANCE_API, loc1String, loc2String]]];

    NSOperationQueue *queue = [NSOperationQueue new];
    queue.name = @"Google Matrix Queue";
    queue.maxConcurrentOperationCount = 3;
    
    NSLog(@"Active and pending operations: %@", queue.operations);
    NSLog(@"Count of operations: %lu", (unsigned long) queue.operationCount);
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSLog(@"%@", data);
    }];
    
    return nil;
}


@end
