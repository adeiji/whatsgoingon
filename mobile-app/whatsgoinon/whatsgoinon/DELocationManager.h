//
//  DELocationManager.h
//  whatsgoinon
//
//  Created by adeiji on 8/6/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "DEScreenManager.h"
#import <Parse/Parse.h>
#import "DEViewComment.h"
#import "Constants.h"
#import "DEAppDelegate.h"

@interface DELocationManager : NSObject <CLLocationManagerDelegate, NSURLConnectionDelegate>
{
    NSTimer *timer;
}

@property (strong, nonatomic) NSString *countryCode;

typedef void (^completionBlock) (NSString *value);
typedef void (^completionHandler) (PFGeoPoint *value);
typedef void (^autocompleteCompletionBlock) (NSArray *values);

- (PFGeoPoint *) geoPoint;
+ (id)sharedManager;

/*
 
 Check to see if the user can comment on the event that the user has selected Going/Maybe on
 
 */
- (BOOL) checkIfCanCommentForEvent : (DEPost *) post;
+ (void) getDistanceInMilesBetweenLocation : (PFGeoPoint *) location1
                               LocationTwo : (PFGeoPoint *) location2
                           CompletionBlock : (completionBlock) callback;

+ (void) getLatLongValueFromAddress : (NSString *) address
                    CompletionBlock : (completionHandler) callback;

+ (void) getAddressFromLatLongValue : (PFGeoPoint *) location
                    CompletionBlock : (completionBlock) callback;

+ (void) getAutocompleteValuesFromString : (NSString *) input
                          DataResultType : (NSString *) type
                         CompletionBlock : (autocompleteCompletionBlock) callback;
/*
 
 Start monitoring to see when the user reaches this event
 post : The post/event that the user has said they're going to
 
 */
- (void) startMonitoringRegionForPost : (DEPost *) post;
- (void) setEventLocation : (NSString *) location;
- (void) getUpdatedLocation;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) PFGeoPoint *currentLocation;
@property (strong, nonatomic) PFGeoPoint *userLocation;
@property (strong, nonatomic) PFGeoPoint *geoPoint;
@property (strong, nonatomic) NSMutableData *responseData;
@property (strong, nonatomic) PFGeoPoint *storedLocation;
@property (strong, nonatomic) DEPost *eventPersonAt;
@property (setter = setCity:, strong, nonatomic) NSString *city;
@property (strong, nonatomic) PFGeoPoint *cityLocation;

@end
