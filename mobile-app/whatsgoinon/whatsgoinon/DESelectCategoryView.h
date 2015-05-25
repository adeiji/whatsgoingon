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
#import "DEOrbButton.h"
#import "DEPostManager.h"
#import "DETutorialCategory.h"

@interface DESelectCategoryView : UIView <UIGestureRecognizerDelegate, iCarouselDelegate, iCarouselDataSource>
{
    UIView *container;
    BOOL isActive;
    NSArray *categories;
    iCarousel *myCarousel;
    UIColor *orbColor;
    NSString *category;
    NSInteger previousIndex;
    
    double BUTTON_HOME_LOC_X;
    double BUTTON_HOME_LOC_Y;
    double NUMBER_OF_SECTIONS;
    double VIEW_WIDTH;
    double BUTTON_HEIGHT;
    double BUTTON_WIDTH;
    double BUTTON_OUTER_CIRCLE_HEIGHT;
    double BUTTON_OUTER_CIRCLE_WIDTH;
    double OUTER_VIEW_X_POS;
    double OUTER_VIEW_Y_POS;
}

#pragma mark - Outlets

@property (weak, nonatomic) IBOutlet UIButton *btnCategory;
@property (strong, nonatomic) UIButton *orbView;
@property (weak, nonatomic) IBOutlet UILabel *lblMood;
@property (strong, nonatomic) UIView *outerView;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet DETutorialCategory *tutorialView;

#pragma mark - Category Functions
- (IBAction)displayCategoryWheel:(id)sender;
- (IBAction)categoryButtonClicked:(id)sender;


#pragma mark - Instance Methods

- (void) renderView;
- (void) loadView;
@end
