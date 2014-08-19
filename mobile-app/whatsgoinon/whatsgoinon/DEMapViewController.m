//
//  DEMapViewController.m
//  whatsgoinon
//
//  Created by adeiji on 8/15/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import "DEMapViewController.h"

@interface DEMapViewController ()

@end

@implementation DEMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadMapView];
}

- (void) loadMapView
{
    // Create a GMSCameraPosition that tells the map to display the
    // coordinate -33.86,151.20 at zoom level 6.
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:_location.latitude
                                                            longitude:_location.longitude
                                                                 zoom:16];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.myLocationEnabled = YES;
    self.view = mapView_;
    mapView_.mapType = kGMSTypeHybrid;
    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(_location.latitude, _location.longitude);
    marker.map = mapView_;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
