//
//  DELocationManager.m
//  whatsgoinon
//
//  Created by adeiji on 8/6/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import "DELocationManager.h"

@implementation DELocationManager

#define GOOGLE_MATRIX_DISTANCE_API @"https://maps.googleapis.com/maps/api/distancematrix/json?origins=%@&destinations=%@&sensor=false&units=imperial&key=AIzaSyDuVa4zdofqE5f7z4wkmi6dw--0HQYm5Ho"
#define GOOGLE_GEOLOCATION_API_GET_COORDINATES @"https://maps.googleapis.com/maps/api/geocode/json?address=%@&key=AIzaSyD478Y5RvbosbO4s34uRaukMwiPkBxJi5A"
#define GOOGLE_GEOLOCATION_API_GET_ADDRESS @"https://maps.googleapis.com/maps/api/geocode/json?latlng=%@&key=AIzaSyD478Y5RvbosbO4s34uRaukMwiPkBxJi5A"
#define GOOGLE_PLACES_AUTOCOMPLETE @"https://maps.googleapis.com/maps/api/place/autocomplete/json?input=%@&types=%@&components=country:us&key=AIzaSyD478Y5RvbosbO4s34uRaukMwiPkBxJi5A"

// Do we need to make sure that the user is using location services or not upon application upload?

//it’s recommended that you always call the locationServicesEnabled class method of CLLocationManager before attempting to start either the standard or significant-change location services. If it returns NO and you attempt to start location services anyway, the system prompts the user to confirm whether location services should be re-enabled. Because the user probably disabled location services on purpose, the prompt is likely to be unwelcome.

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    //Get the latitude and longitude values of the current user
    _currentLocation.latitude = [[locations objectAtIndex:0] coordinate].latitude;
    _currentLocation.longitude = [[locations objectAtIndex:0] coordinate].longitude;

    //Stop updating the location because now it is uneccesary
    [_locationManager stopUpdatingLocation];
}

- (PFGeoPoint *) geoPoint {
    return _currentLocation;
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
        
        _currentLocation = [PFGeoPoint new];
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

+ (void) getLatLongValueFromAddress:(NSString *)address CompletionBlock:(completionHandler)callback {
    NSLog(@"The address to get the lat/long value is: %@", address);
    address = [address stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:GOOGLE_GEOLOCATION_API_GET_COORDINATES, address]]];
    
    NSOperationQueue *queue = [NSOperationQueue new];
    queue.name = @"Google Geolocation Queue";
    queue.maxConcurrentOperationCount = 3;
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSError *error;
        NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        PFGeoPoint *location = [PFGeoPoint new];
        location.latitude = [jsonData[@"results"][0][@"geometry"][@"location"][@"lat"] doubleValue];
        location.longitude = [jsonData[@"results"][0][@"geometry"][@"location"][@"lng"] doubleValue];
        
        NSLog(@"%@", location);
        dispatch_async(dispatch_get_main_queue(), ^{
            // Make sure that we call this method on the main thread so that it updates properly as supposed to
            callback(location);
        });
    }];
}

// Call the Google Maps API and get the distance between the two points given, but this would be the distance that would actually be traveled as opposed to a straight line between the two points.
+ (void) getDistanceInMilesBetweenLocation : (PFGeoPoint *) location1
                                     LocationTwo : (PFGeoPoint *) location2
                                 CompletionBlock : (completionBlock)callback
{
    NSLog(@"Getting the distance in Miles between location: %@ & location: %@", location1, location2);
    
    NSString *loc1String = [NSString stringWithFormat:@"%f,%f", location1.latitude, location1.longitude];
    NSString *loc2String = [NSString stringWithFormat:@"%f,%f", location2.latitude,location2.longitude];

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:GOOGLE_MATRIX_DISTANCE_API, loc1String, loc2String]]];

    NSOperationQueue *queue = [NSOperationQueue new];
    queue.name = @"Google Matrix Queue";
    queue.maxConcurrentOperationCount = 3;
    
    NSLog(@"Active and pending operations: %@", queue.operations);
    NSLog(@"Count of operations: %lu", (unsigned long) queue.operationCount);
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSError *error;
        NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        NSString *distance = jsonData[@"rows"][0][@"elements"][0][@"distance"][@"text"];
        NSLog(@"Distance from location1 to location2 is %@", jsonData[@"rows"][0][@"elements"][0][@"distance"][@"text"]);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Make sure that we call this method on the main thread so that it updates properly as supposed to
            callback(distance);
        });
    }];
}

+ (void) getAddressFromLatLongValue:(PFGeoPoint *)location CompletionBlock:(completionBlock)callback {
    NSLog(@"The lat/long value to get the address is: %@", location);
    
    NSString *latLong = [NSString stringWithFormat:@"%f,%f", location.latitude, location.longitude];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:GOOGLE_GEOLOCATION_API_GET_ADDRESS, latLong]]];
    
    NSOperationQueue *queue = [NSOperationQueue new];
    queue.name = @"Google Geolocation Queue";
    queue.maxConcurrentOperationCount = 3;
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSError *error;
        NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        NSString *addressNumber = jsonData[@"results"][0][@"address_components"][0][@"short_name"];
        NSString *street = jsonData[@"results"][0][@"address_components"][1][@"short_name"];
        NSString *address = [NSString stringWithFormat:@"%@ %@", addressNumber, street];
        
        NSLog(@"%@", address);
        dispatch_async(dispatch_get_main_queue(), ^{
            // Make sure that we call this method on the main thread so that it updates properly as supposed to
            callback(address);
        });
    }];

}

+ (void) getAutocompleteValuesFromString : (NSString *) input
                          DataResultType : (NSString *) type
                         CompletionBlock : (autocompleteCompletionBlock) callback {
    input = [input stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:GOOGLE_PLACES_AUTOCOMPLETE, input, type]]];
    
    NSOperationQueue *queue = [NSOperationQueue new];
    queue.name = @"Google Places Queue";
    queue.maxConcurrentOperationCount = 3;
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSError *error;
        NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        NSArray *predictions = jsonData[@"predictions"];
        NSMutableArray *values = [NSMutableArray new];
        
        for (NSDictionary *dictionary in predictions) {
            NSArray *terms = [dictionary objectForKey:@"terms"];
            // Get everything from the address except the unnecessary end pieces
            NSString *location = [dictionary objectForKey:@"description"];

//            for (int i = 1; i < [terms count] -1; i ++)
//            {
//               // location = [NSString stringWithFormat:@"%@ %@", location, terms[i][@"value"]];
//            }
            
            [values addObject:location];
        };
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Make sure that we call this method on the main thread so that it updates properly as supposed to
            callback(values);
        });
    }];
    
}


@end
