//
//  DEEventView.m
//  whatsgoinon
//
//  Created by adeiji on 8/11/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import "DEEventView.h"
#import "Constants.h"

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
    _viewMapView.myLocationEnabled = NO;
    _viewMapView.mapType = kGMSTypeNormal;
    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(location.latitude, location.longitude);
    marker.title = [[[DEPostManager sharedManager] currentPost] address];
    marker.snippet = [[DEPostManager sharedManager] distanceFromEvent];
    marker.infoWindowAnchor = CGPointMake(.5, 1.2);
    marker.map = _viewMapView;
    
    [_viewMapView setSelectedMarker:marker];
}

@end
