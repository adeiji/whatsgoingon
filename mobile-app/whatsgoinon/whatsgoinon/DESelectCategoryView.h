//
//  DEViewCategoriesView.h
//  whatsgoinon
//
//  Created by adeiji on 8/13/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DESector.h"
#import "DERotaryProtocol.h"
#import "DEScreenManager.h"
#import <iCarousel/iCarousel.h>

@interface DESelectCategoryView : UIView <UIGestureRecognizerDelegate, iCarouselDelegate, iCarouselDataSource>
{
    UIView *container;
    BOOL isActive;
    NSArray *categories;
    iCarousel *myCarousel;
}

#pragma mark - Outlets

@property (weak, nonatomic) IBOutlet UILabel *lblCategory;

#pragma mark - Category Functions
- (IBAction)displayCategoryWheel:(id)sender;

#pragma mark - Instance Methods

- (void) renderView;
- (void) loadView;
@end