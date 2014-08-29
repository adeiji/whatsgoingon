//
//  DEEventView.m
//  whatsgoinon
//
//  Created by adeiji on 8/11/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import "DEEventView.h"

@implementation DEEventView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) loadMapViewWithLocation : (PFGeoPoint *) location
{
    // Create a GMSCameraPosition that tells the map to display the
    // coordinate -33.86,151.20 at zoom level 6.
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:location.latitude
                                                            longitude:location.longitude
                                                                 zoom:16];
    _viewMapView.camera = camera;
    _viewMapView.myLocationEnabled = YES;
    _viewMapView.mapType = kGMSTypeNormal;
    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(location.latitude, location.longitude);
    marker.map = _viewMapView;
    
}

- (IBAction)setEventAsGoing:(id)sender
{
    DEPostManager *postManager = [DEPostManager new];
    [[postManager goingPost] addObject:_post];
}

- (IBAction)setEventAsMaybeGoing:(id)sender
{
    DEPostManager *postManager = [DEPostManager new];
    [[postManager maybeGoingPost] addObject:_post];
}

@end
