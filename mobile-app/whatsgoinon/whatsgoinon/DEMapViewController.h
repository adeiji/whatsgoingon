//
//  DEMapViewController.h
//  whatsgoinon
//
//  Created by adeiji on 8/15/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import <Parse/Parse.h>

@interface DEMapViewController : UIViewController
{
    GMSMapView *mapView_;
}

@property (strong, nonatomic) PFGeoPoint *location;


@end
