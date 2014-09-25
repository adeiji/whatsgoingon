//
//  DEEventView.h
//  whatsgoinon
//
//  Created by adeiji on 8/11/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import <Parse/Parse.h>
#import "DEPostManager.h"

@class DEPost;

@interface DEEventView : UIView
{
    GMSMapView *mapView_;
}
#pragma mark - View Outlets

@property (weak, nonatomic) IBOutlet UIImageView *imgMainImage;
@property (weak, nonatomic) IBOutlet UIView *viewStarRating;
@property (weak, nonatomic) IBOutlet GMSMapView *viewMapView;
@property (weak, nonatomic) IBOutlet UILabel *lblCost;
@property (weak, nonatomic) IBOutlet UILabel *lblNumberOfPeopleGoing;
@property (weak, nonatomic) IBOutlet UILabel *lblTimeUntilStartOrEndOfEvent;
@property (weak, nonatomic) IBOutlet UIButton *btnGoing;
@property (weak, nonatomic) IBOutlet UITextView *txtDetails;
@property (weak, nonatomic) IBOutlet UIButton *btnMaybe;
@property (weak, nonatomic) IBOutlet UIScrollView *detailsView;
@property (strong, nonatomic) DEPost *post;

- (void) loadMapViewWithLocation : (PFGeoPoint *) location;

@end
