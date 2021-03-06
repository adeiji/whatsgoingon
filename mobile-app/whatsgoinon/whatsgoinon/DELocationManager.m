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
#define GOOGLE_GEOLOCATION_API_GET_COORDINATES @"https://maps.googleapis.com/maps/api/geocode/json?address=%@&components=country:%@&key=AIzaSyD478Y5RvbosbO4s34uRaukMwiPkBxJi5A"
#define GOOGLE_GEOLOCATION_API_GET_COORDINATES_TEMP @"https://maps.googleapis.com/maps/api/geocode/json?address=%@&key=AIzaSyD478Y5RvbosbO4s34uRaukMwiPkBxJi5A"
#define GOOGLE_GEOLOCATION_API_GET_ADDRESS @"https://maps.googleapis.com/maps/api/geocode/json?latlng=%@&key=AIzaSyD478Y5RvbosbO4s34uRaukMwiPkBxJi5A"
#define GOOGLE_PLACES_AUTOCOMPLETE @"https://maps.googleapis.com/maps/api/place/autocomplete/json?input=%@&components=country:us&key=AIzaSyD478Y5RvbosbO4s34uRaukMwiPkBxJi5A"
#define GOOGLE_PLACES_DETAILS @"https://maps.googleapis.com/maps/api/place/details/json?placeid=%@&key=AIzaSyD478Y5RvbosbO4s34uRaukMwiPkBxJi5A"


static const NSString *GOOGLE_API_RESULTS = @"results";
static const NSString *GOOGLE_API_RESULT = @"result";
static const NSString *GOOGLE_API_ADDRESS_COMPONENTS = @"address_components";
static const NSString *GOOGLE_API_SHORT_NAME = @"short_name";
static NSString *const kPreviousLocation = @"com.happsnap.previousLocation";
static const NSString *LATITUDE = @"lat";
static const NSString *LONGITUDE = @"long";

// Do we need to make sure that the user is using location services or not upon application upload?

//it’s recommended that you always call the locationServicesEnabled class method of CLLocationManager before attempting to start either the standard or significant-change location services. If it returns NO and you attempt to start location services anyway, the system prompts the user to confirm whether location services should be re-enabled. Because the user probably dis-abled location services on purpose, the prompt is likely to be unwelcome.

#pragma mark - Location Services Delegate Methods

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
//    _currentLocation = [PFGeoPoint new];
    //Get the latitude and longitude values of the current user
    _currentLocation.latitude = [[locations objectAtIndex:0] coordinate].latitude;
    _currentLocation.longitude = [[locations objectAtIndex:0] coordinate].longitude;

    // If the application is open then we know we'll be getting regular updates everytime the user presses What's Going On Now or Later
    [_locationManager stopUpdatingLocation];
    [self saveLocation:[locations objectAtIndex:0]];
    
    NSLog(@"Location Updated");
}

- (void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Error getting location: %@", [error description]);
    
    NSDictionary *dimensions = @{
                                 @"Error" : [error description],
                                 };
    
    // Send the dimensions to Parse along with the 'read' event
    [PFAnalytics trackEvent:@"error" dimensions:dimensions];
}


#pragma mark - Region Monitoring

- (void) stopAllRegionMonitoringForFinishedEvents {

    for (CLRegion *region in [_locationManager monitoredRegions]) {
        [DESyncManager checkEventForIfMonitoringNecessaryEventId:region];
    }
}

- (void) stopMonitoringRegionForPost : (DEPost * ) post {
    [[_locationManager monitoredRegions] enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        CLCircularRegion *region = (CLCircularRegion *) obj;
        if ([post.objectId isEqualToString:region.identifier])
        {
            [_locationManager stopMonitoringForRegion:region];
        }
    }];
}

- (void) locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    NSLog(@"State of region determined");
}

- (void) locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    
    if ([CLLocationManager isMonitoringAvailableForClass:[CLRegion class]] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways))
    {
        // Get the post that matches the regions id and then see if they can comment for it
        [DESyncManager getPostById:region.identifier Process:SEE_IF_CAN_COMMENT];
    }
    
    [self saveLocation:manager.location];
}

- (void) saveLocation : (CLLocation *) location {

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *locationDictionary = @{ LATITUDE : [NSNumber numberWithDouble:location.coordinate.latitude],
                                          LONGITUDE : [NSNumber numberWithDouble:location.coordinate.longitude]
                                          };
    
    [userDefaults setObject:locationDictionary forKey:kPreviousLocation];
}

// If the location has not been updated already with the most recent one, we get the location the user was last at when they closed the app
- (void) loadPreviousLocation {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *locationDictionary = [userDefaults objectForKey:kPreviousLocation];
    
    if (!_currentLocation)
    {
        if (locationDictionary)
        {
            PFGeoPoint *currentLocation = [PFGeoPoint new];
            NSNumber *latitude = [locationDictionary objectForKey:LATITUDE];
            NSNumber *longitude = [locationDictionary objectForKey:LONGITUDE];
            currentLocation.latitude = latitude.doubleValue;
            currentLocation.longitude = longitude.doubleValue;
            _currentLocation = currentLocation;
        }
        else {
            _currentLocation = [PFGeoPoint new];
        }
    }
}

- (void) locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
    NSLog(@"Starting to monitor region with identifier: %@", region.identifier );
}


- (void) locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error {
    NSLog(@"Error monitoring region: %@", [error description]);
}

- (void) locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    for (UILocalNotification *notification in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
        if ([notification.userInfo[kNOTIFICATION_CENTER_EVENT_USER_AT] isEqualToString:region.identifier] && [notification.userInfo[kNOTIFICATION_CENTER_LOCAL_NOTIFICATION_FUTURE] isEqual:@YES])
        {
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
        }
    }
}

#pragma mark - Location Update and Commenting

// Update the users location every 1 minute
- (void) startLocationUpdateTimer {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSTimer *locationUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:60 * 1 target:self selector:@selector(getUpdatedLocation) userInfo:nil repeats:YES];
        
        [locationUpdateTimer fire];
    });
}

- (void) getUpdatedLocation {
    [_locationManager startUpdatingLocation];
}

- (void) locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse)
    {

    }
}

/*
 
 Check to see if the user is eligible to comment for this event
 
 */

- (BOOL) checkIfCanCommentForEvent : (DEPost *) post
{
    // Perform task here
    CLLocationDegrees latitude = post.location.latitude;
    CLLocationDegrees longitude = post.location.longitude;
    CLLocation *currentLocation = [[CLLocation alloc] initWithLatitude:_currentLocation.latitude longitude:_currentLocation.longitude];
    CLLocation *eventLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    CLLocationDistance distance = [currentLocation distanceFromLocation:eventLocation];
    NSLog(@"Distance to event: %f", distance);
    // Check to see if the event is currently going on, or finished within the hour
    NSDate *later = [post.endTime dateByAddingTimeInterval:(60 * 60)];
    
    // Check to make sure that the event has already started and that it ended within the past hour
    if (([post.startTime compare:[NSDate date]] == NSOrderedAscending) && ([later compare:[NSDate date]] == NSOrderedDescending))
    {
        if (distance < DISTANCE_TO_EVENT_FOR_COMMENTING)
        {
            [self promptUserForCommentPost:post TimeToShow:[NSDate new] isFuture:NO];
            return YES;
        }
    }
    else if (distance < DISTANCE_TO_EVENT_FOR_COMMENTING && ([post.endTime compare:[NSDate date]] == NSOrderedDescending))  // If the user is simply early
    {
        [self promptUserForCommentPost:post TimeToShow:[post.startTime dateByAddingTimeInterval:(60 * 15)] isFuture:YES];
        [self startMonitoringRegionForPost:post MonitorExit:YES];
        return NO;
    }
    
    return NO;
}

- (void) promptUserForCommentPost : (DEPost *) post
                       TimeToShow : (NSDate *) date
                         isFuture : (BOOL) future
{
    [DEScreenManager createPromptUserCommentNotification:post TimeToShow:date isFuture:future];
}

/*
 
 Start monitoring for the current post location
 post : The event that we're creating the location region for
 
 */
- (void) startMonitoringRegionForPost : (DEPost *) post
                          MonitorExit : (BOOL) onExit
{
    CLLocationCoordinate2D locCoordinate = CLLocationCoordinate2DMake(post.location.latitude, post.location.longitude);
    CLCircularRegion *region = [[CLCircularRegion alloc] initWithCenter:locCoordinate radius:DISTANCE_TO_EVENT_FOR_COMMENTING identifier:post.objectId];
        
    // Ensure that when the user enters this specific region the app is notified, and woken up if necessary
    [region setNotifyOnEntry:YES];
    [region setNotifyOnExit:onExit];
    [_locationManager startMonitoringForRegion:region];
}

- (void) setEventLocation : (NSString *) location
{
    [DELocationManager getLatLongValueFromAddress:location CompletionBlock:^(PFGeoPoint *value) {
        _placeLocation = value;
    }];
}

/*
 
 Set the city to the newly selected city
 
 */
- (void) setCity:(NSString *)city
{
    _city = city;
    [DELocationManager getLatLongValueFromAddress:city CompletionBlock:^(PFGeoPoint *value) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNOTIFICATION_CENTER_USER_INFO_USER_PROCESS_NEW object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNOTIFICATION_CENTER_IS_CITY_CHANGE object:nil];
        NSMutableArray *postsArray = [NSMutableArray new];
        
        DEScreenManager *manager = [DEScreenManager sharedManager];
        [DESyncManager getAllValuesWithinMilesForNow:!manager.isLater
                                          PostsArray:postsArray
                                            Location:value];
        
    }];
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
        
        // If there on iOS 7, than the requestWhenInUseAuthorization will crash the app
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [self.locationManager requestAlwaysAuthorization];
        }
        
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }
    return self;
}


#pragma mark - API Calls - Google / Apple

+ (void) getLatLongValueFromAddress:(NSString *)address CompletionBlock:(completionHandler)callback {
//    NSLog(@"The address to get the lat/long value is: %@", address);
    address = [address stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSString *urlRequestAsString = [NSString stringWithFormat:GOOGLE_GEOLOCATION_API_GET_COORDINATES_TEMP, address];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlRequestAsString]];
    
    NSOperationQueue *queue = [NSOperationQueue new];
    queue.name = @"Google Geolocation Queue";
    queue.maxConcurrentOperationCount = 3;
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSError *error;
        NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        if (![jsonData[@"status"] isEqualToString:PLACES_API_NO_RESULTS])
        {
            PFGeoPoint *location = [PFGeoPoint new];
            location.latitude =  [jsonData[@"results"][0][@"geometry"][@"location"][@"lat"] doubleValue];
            location.longitude = [jsonData[@"results"][0][@"geometry"][@"location"][@"lng"] doubleValue];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // Make sure that we call this method on the main thread so that it updates properly as supposed to
                callback(location);
            });
        }
        else {
            callback(nil);
        }
    }];
}

// Call the Google Maps API and get the distance between the two points given, but this would be the distance that would actually be traveled as opposed to a straight line between the two points.
+ (void) getDistanceInMilesBetweenLocation : (PFGeoPoint *) location1
                                     LocationTwo : (PFGeoPoint *) location2
                                 CompletionBlock : (completionBlock)callback
{
//    NSLog(@"Getting the distance in Miles between location: %@ & location: %@", location1, location2);
    
    NSString *loc1String = [NSString stringWithFormat:@"%f,%f", location1.latitude, location1.longitude];
    NSString *loc2String = [NSString stringWithFormat:@"%f,%f", location2.latitude,location2.longitude];

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:GOOGLE_MATRIX_DISTANCE_API, loc1String, loc2String]]];

    NSOperationQueue *queue = [NSOperationQueue new];
    queue.name = @"Google Matrix Queue";
    queue.maxConcurrentOperationCount = 3;
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSError *error;
        NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        NSString *distance = jsonData[@"rows"][0][@"elements"][0][@"distance"][@"text"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Make sure that we call this method on the main thread so that it updates properly as supposed to
            callback(distance);
        });
    }];
}

+ (void) getStateFromLatLongValue:(PFGeoPoint *)location CompletionBlock:(stateCompletionBlock) callback {
    
    NSString *latLong = [NSString stringWithFormat:@"%f,%f", location.latitude, location.longitude];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:GOOGLE_GEOLOCATION_API_GET_ADDRESS, latLong]]];
    
    NSOperationQueue *queue = [NSOperationQueue new];
    queue.name = @"Google Geolocation Queue";
    queue.maxConcurrentOperationCount = 3;
    NSMutableDictionary *result = [NSMutableDictionary new];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSError *error;
        if (data != nil)
        {
            NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            
            if (![jsonData[@"status"] isEqualToString:@"ZERO_RESULTS"])
            {
                for (id addressComponent in jsonData[GOOGLE_API_RESULTS][0][GOOGLE_API_ADDRESS_COMPONENTS]) {
                    for (id type in addressComponent[@"types"]) {
                        if ([type isEqualToString:@"administrative_area_level_1"]) {
                            result[@"state"] = addressComponent[@"long_name"];
                            break;
                        }
                        else if ([type isEqualToString:@"administrative_area_level_2"]) {
                            result[@"city"] = addressComponent[@"long_name"];
                            break;
                        }
                    }
                }
                
                if (result)
                {
                    callback(result);
                }
            }
        }
    }];
}

+ (void) getAddressFromLatLongValue:(PFGeoPoint *)location CompletionBlock:(completionBlock)callback {
    
    NSString *latLong = [NSString stringWithFormat:@"%f,%f", location.latitude, location.longitude];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:GOOGLE_GEOLOCATION_API_GET_ADDRESS, latLong]]];
    
    NSOperationQueue *queue = [NSOperationQueue new];
    queue.name = @"Google Geolocation Queue";
    queue.maxConcurrentOperationCount = 3;
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSError *error;
        if (data != nil)
        {
            NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            
            if (![jsonData[@"status"] isEqualToString:@"ZERO_RESULTS"])
            {
                NSString *addressNumber = jsonData[GOOGLE_API_RESULTS][0][GOOGLE_API_ADDRESS_COMPONENTS][0][GOOGLE_API_SHORT_NAME];
                NSString *street = jsonData[GOOGLE_API_RESULTS][0][GOOGLE_API_ADDRESS_COMPONENTS][1][GOOGLE_API_SHORT_NAME];
                NSString *city = jsonData[GOOGLE_API_RESULTS][0][GOOGLE_API_ADDRESS_COMPONENTS][3][GOOGLE_API_SHORT_NAME];
                NSArray *stateComponents = jsonData[GOOGLE_API_RESULTS][0][GOOGLE_API_ADDRESS_COMPONENTS];
                int zipLocationInArray = (int) [stateComponents count] - 2;
                NSString *state = stateComponents[zipLocationInArray][GOOGLE_API_SHORT_NAME];
                NSString *address = [NSString stringWithFormat:@"%@ %@, %@, %@", addressNumber, street, city, state];
                NSArray *countryCodeComponents = jsonData[GOOGLE_API_RESULTS][0][GOOGLE_API_ADDRESS_COMPONENTS];
                NSString *countryCode = [countryCodeComponents lastObject][GOOGLE_API_SHORT_NAME];
                [[DELocationManager sharedManager] setCountryCode:countryCode];
                NSLog(@"The address to get the lat long values is verified: %@", address);
                dispatch_async(dispatch_get_main_queue(), ^{
                    // Make sure that we call this method on the main thread so that it updates properly as supposed to
                    callback(address);
                });
            }
        }
    }];
}

+ (void) getAddressFromPlace:(NSString *) placeId CompletionBlock:(completionBlock)callback {
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:GOOGLE_PLACES_DETAILS, placeId]]];
    
    NSOperationQueue *queue = [NSOperationQueue new];
    queue.name = @"Google Geolocation Queue";
    queue.maxConcurrentOperationCount = 3;
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSError *error;
        if (data != nil)
        {
            NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            
            if (![jsonData[@"status"] isEqualToString:@"ZERO_RESULTS"])
            {
                NSString *address = jsonData[GOOGLE_API_RESULT][@"formatted_address"];
                NSRange rangeOfLastComma = [address rangeOfString:@"," options:NSBackwardsSearch];
                address = [address substringToIndex:rangeOfLastComma.location];
                NSArray *countryCodeComponents = jsonData[GOOGLE_API_RESULTS][0][GOOGLE_API_ADDRESS_COMPONENTS];
                NSString *countryCode = [countryCodeComponents lastObject][GOOGLE_API_SHORT_NAME];
                [[DELocationManager sharedManager] setCountryCode:countryCode];
                NSLog(@"The address to get the lat long values is verified: %@", address);
                dispatch_async(dispatch_get_main_queue(), ^{
                    // Make sure that we call this method on the main thread so that it updates properly as supposed to
                    callback(address);
                });
            }
        }
    }];
}

+ (void) getAutocompleteValuesFromString : (NSString *) input
                          DataResultType : (NSString *) type
                         CompletionBlock : (autocompleteCompletionBlock) callback {
    input = [input stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:GOOGLE_PLACES_AUTOCOMPLETE, input]]];
    
    NSOperationQueue *queue = [NSOperationQueue new];
    queue.name = @"Google Places Queue";
    queue.maxConcurrentOperationCount = 3;
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSError *error;
        if (!connectionError)
        {
            NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            if (jsonData[@"predictions"])
            {
                NSArray *predictions = jsonData[@"predictions"];
                NSMutableArray *values = [NSMutableArray new];
                
                for (NSDictionary *dictionary in predictions) {
                    // At times when entering the values are returned together for example. Val 1 will equal 8785 when the street number has not begun being entered, but it will also be 8785 Hawk St, if the user has begun entering the address
                    NSString *fullAddress = [dictionary objectForKey:@"description"];
                    NSRange range = [fullAddress rangeOfString:@"," options:NSBackwardsSearch];
                    NSString *address;
                    if (range.location != 0)
                    {
                        address = [fullAddress substringToIndex:range.location];
                    }
                    else {
                        address = fullAddress;
                    }
                    
                    if (dictionary[@"place_id"])
                    {
                        [values addObject:@{ @"name"    : address,
                                             @"place_id": dictionary[@"place_id"]}];
                    }
                    else {
                        [values addObject:@{ @"name"    : address }];
                    }
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    // Make sure that we call this method on the main thread so that it updates properly as supposed to
                    callback(values);
                });
            }
        }
    }];
}


@end
