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
#define GOOGLE_PLACES_AUTOCOMPLETE @"https://maps.googleapis.com/maps/api/place/autocomplete/json?input=%@&types=%@&components=country:us&key=AIzaSyD478Y5RvbosbO4s34uRaukMwiPkBxJi5A"

// Do we need to make sure that the user is using location services or not upon application upload?

//it’s recommended that you always call the locationServicesEnabled class method of CLLocationManager before attempting to start either the standard or significant-change location services. If it returns NO and you attempt to start location services anyway, the system prompts the user to confirm whether location services should be re-enabled. Because the user probably disabled location services on purpose, the prompt is likely to be unwelcome.

#pragma mark - Location Services Delegate Methods

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
    //Get the latitude and longitude values of the current user
    _currentLocation.latitude = [[locations objectAtIndex:0] coordinate].latitude;
    _currentLocation.longitude = [[locations objectAtIndex:0] coordinate].longitude;

    // If the application is open then we know we'll be getting regular updates everytime the user presses What's Going On Now or Later
    if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive)
    {
        [_locationManager stopUpdatingLocation];
    }
    
    NSLog(@"Location Updated");
    
    NSArray *goingPosts = [self getGoingPostEventObjects];
    [self checkForCommenting : goingPosts];
}

/*
 
 Handle any errors that happen from the location manager
 
 */

- (void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSDictionary *dimensions = @{
                                 @"Error" : [error description],
                                };
    
    // Send the dimensions to Parse along with the 'read' event
    [PFAnalytics trackEvent:@"error" dimensions:dimensions];
}

- (void) locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorized || status == kCLAuthorizationStatusAuthorizedWhenInUse)
    {
        [_locationManager startMonitoringSignificantLocationChanges];
    }
}

- (void) checkForCommenting : (NSArray *) goingPosts {
    // Perform task here
    
    for (DEPost *post in goingPosts) {
        // Check to make sure that the user has already been prompted to comment for this
        if (![[[DEPostManager sharedManager] promptedForCommentEvents] containsObject:post.objectId])
        {
            if ([self checkIfCanCommentForEvent:post])
            {
                break;
            }
        }
    }
}

/*
 
 Get the actual events that correspond to the saved Post Ids stored in the Post Manager
 
 */
- (NSArray *) getGoingPostEventObjects {
    NSMutableArray *goingPosts = [NSMutableArray new];
    NSMutableArray *goingPFObjectPosts = [NSMutableArray new];
    
    // Get all the actual posts that are set as is going by this user and convert them to DEPost objects and then store them in a local array
    for (PFObject *post in [[DEPostManager sharedManager] posts]) {
        for (NSString *postId in [[DEPostManager sharedManager] goingPost]) {
            if ([postId isEqualToString:post.objectId])
            {
                [goingPosts addObject:[DEPost getPostFromPFObject:post]];
                [goingPFObjectPosts addObject:post];
            }
        }
    }
    
    return goingPosts;
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
        if (distance < 200)
        {
            [self promptUserForCommentPost:post TimeToShow:[NSDate new] isFuture:NO];
            return YES;
        }
    }
    else if (distance < 200 && ([post.endTime compare:[NSDate date]] == NSOrderedDescending))  // If the user is simply early
    {
        [self promptUserForCommentPost:post TimeToShow:[post.startTime dateByAddingTimeInterval:(60 * 15)] isFuture:YES];
    }
    
    return NO;
}

- (void) promptUserForCommentPost : (DEPost *) post
                       TimeToShow : (NSDate *) date
                         isFuture : (BOOL) future
{
    [DEScreenManager createPromptUserCommentNotification:post TimeToShow:date isFuture:future];
    [[[DEPostManager sharedManager] promptedForCommentEvents] addObject:post.objectId];
    [_locationManager stopUpdatingLocation];
}

- (void) updateLocation {
#warning Make sure to uncomment when going to Fabian
//    [_locationManager startUpdatingLocation];
}



/*
 
 Start monitoring for the current post location
 post : The event that we're creating the location region for
 
 */
- (void) startMonitoringRegionForPost : (DEPost *) post {
    
    CLLocationCoordinate2D locCoordinate = CLLocationCoordinate2DMake(post.location.latitude, post.location.longitude);
    CLCircularRegion *region = [[CLCircularRegion alloc] initWithCenter:locCoordinate radius:500 identifier:post.objectId];
    
    // Ensure that when the user enters this specific region the app is notified, and woken up if necessary
    [region setNotifyOnEntry:YES];
    [_locationManager startMonitoringForRegion:region];
    [_locationManager startMonitoringSignificantLocationChanges];
}
// The user entered the location of an event that he said he was going to or maybe going to
- (void) locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    NSArray *goingPosts = [self getGoingPostEventObjects];
    
    // Check to see if this event that the user is at has already started
    
    for (DEPost *post in goingPosts) {
        if ([post.objectId isEqualToString:region.identifier])
        {
            // Check to see if this event has started.  If the start time of the event is less than the current time
            if (([post.startTime compare:[NSDate new]] == NSOrderedAscending) &&  ([post.endTime compare:[NSDate new]] == NSOrderedDescending) )
            {
                [DEScreenManager createPromptUserCommentNotification:post TimeToShow:[NSDate new] isFuture:NO];
                [[[DEPostManager sharedManager] promptedForCommentEvents] addObject:post.objectId];
                
                break;
            }
        }
    }
}

- (void) promptUserForFeedback
{
    [DEScreenManager showCommentView : _eventPersonAt];

}

- (void) startTimerForFeedback
{
    timer = [NSTimer scheduledTimerWithTimeInterval:180 target:self selector:@selector(promptUserForFeedback) userInfo:nil repeats:NO];
    
    [timer fire];
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
        
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [_locationManager startMonitoringSignificantLocationChanges];
        _currentLocation = [PFGeoPoint new];
        
        // If there on iOS 7, than the requestWhenInUseAuthorization will crash the app
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [self.locationManager requestAlwaysAuthorization];
        }
        
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
//        NSLog(@"Distance from location1 to location2 is %@", jsonData[@"rows"][0][@"elements"][0][@"distance"][@"text"]);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Make sure that we call this method on the main thread so that it updates properly as supposed to
            callback(distance);
        });
    }];
}

+ (void) getAddressFromLatLongValue:(PFGeoPoint *)location CompletionBlock:(completionBlock)callback {
//    NSLog(@"The lat/long value to get the address is: %@", location);
    
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
                NSString *addressNumber = jsonData[@"results"][0][@"address_components"][0][@"short_name"];
                NSString *street = jsonData[@"results"][0][@"address_components"][1][@"short_name"];
                NSString *city = jsonData[@"results"][0][@"address_components"][3][@"short_name"];
                NSString *state = jsonData[@"results"][0][@"address_components"][5][@"short_name"];
                NSString *address = [NSString stringWithFormat:@"%@ %@, %@, %@", addressNumber, street, city, state];
                NSString *countryCode = jsonData[@"results"][0][@"address_components"][6][@"short_name"];
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
            // At times when entering the values are returned together for example. Val 1 will equal 8785 when the street number has not begun being entered, but it will also be 8785 Hawk St, if the user has begun entering the address
            NSString *fullAddress = [dictionary objectForKey:@"description"];
            NSRange range = [fullAddress rangeOfString:@"," options:NSBackwardsSearch];
            NSString *address = [fullAddress substringToIndex:range.location];
            [values addObject:address];
        };
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Make sure that we call this method on the main thread so that it updates properly as supposed to
            callback(values);
        });
    }];
}


@end
