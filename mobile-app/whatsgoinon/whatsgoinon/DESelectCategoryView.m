//
//  DEViewCategoriesView.m
//  whatsgoinon
//
//  Created by adeiji on 8/13/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import "DESelectCategoryView.h"
#import <QuartzCore/QuartzCore.h>
#import <POP.h>

static float deltaAngle;

@implementation DESelectCategoryView

#define BUTTON_HOME_LOC_X 270
#define BUTTON_HOME_LOC_Y 518
#define NUMBER_OF_SECTIONS 13
#define VIEW_WIDTH 250
#define BUTTON_HEIGHT 50
#define BUTTON_WIDTH 50
#define BLUE_ORB_IMAGE @""

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void) loadView {
    
    DEScreenManager *screenManager = [DEScreenManager sharedManager];
    DEOrbButton *viewCategories = [[screenManager values] objectForKey:@"viewCategoriesButton"];
    
    if (![[screenManager values] objectForKey:@"viewCategoriesButton"])
    {
        UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
        
        viewCategories = [[DEOrbButton alloc] initWithFrame:CGRectMake(320 - 60, 568 - 60, BUTTON_WIDTH, BUTTON_HEIGHT)];
        [viewCategories setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:BLUE_ORB_IMAGE]]];
        [viewCategories addTarget:self action:@selector(displayCategoryWheel:) forControlEvents:UIControlEventTouchUpInside];
        [viewCategories setOpaque:NO];
        [window addSubview:viewCategories];
        [[screenManager values] setObject:viewCategories forKey:@"viewCategoriesButton"];
    }
    else
    {
        viewCategories.hidden = NO;
    }
    
    isActive = false;
    self.lblCategory.hidden = YES;
}

- (void) renderView {
    
    UIView *wheelView = [[[NSBundle mainBundle] loadNibNamed:@"SelectCategoryView" owner:self options:nil] lastObject];
    container = [[UIView alloc] initWithFrame:wheelView.frame];
    
    categories = [NSArray arrayWithObjects:@"Featured", @"Under 21", @"Party", @"Classy", @"Over 21", @"Crazy", @"Funny", @"Music", @"Environmental", @"Ridiculous", @"Dancing", @"Nerdy", @"Pricy", nil];
    
    myCarousel = [[iCarousel alloc] initWithFrame:CGRectMake(self.frame.size.width - 320, self.frame.size.height - 400, 320, 500)];
    myCarousel.type = iCarouselTypeWheel;
    myCarousel.delegate = self;
    myCarousel.dataSource = self;
    [myCarousel reloadData];
    myCarousel.contentOffset = CGSizeMake(130, -50);
    
    [self addSubview:myCarousel];
}

- (BOOL) gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return NO;
}

- (BOOL) pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    
    if (isActive)
    {
        DEScreenManager *screenManager = [DEScreenManager sharedManager];
        UIButton *viewCategories = [[screenManager values] objectForKey:@"viewCategoriesButton"];
        if (CGRectContainsPoint(viewCategories.frame, point))
        {
            return NO;
        }
        
        return YES;
    }
    {
        return NO;
    }
}

- (IBAction)displayCategoryWheel:(UIButton *)sender {
    
    if (!isActive)
    {
        isActive = true;
        
        [self renderView];
        [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:.9]];

        [[sender layer ]setZPosition:20];
        self.lblCategory.hidden = NO;
    }
    else {
        [myCarousel removeFromSuperview];
        [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]];
        self.lblCategory.hidden = YES;
        
        isActive = false;
    }
}

- (void) wheelDidChangeValue: (int) index {
    
    self.lblCategory.text = [categories objectAtIndex:index];
}



- (UIView *)carousel:(__unused iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    UILabel *label = nil;
    
    //create new view if no view is available for recycling
    if (view == nil)
    {
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, BUTTON_HEIGHT, BUTTON_WIDTH)];
        view.contentMode = UIViewContentModeCenter;
        
        [view setBackgroundColor:[UIColor blueColor]];

    }
    else
    {
        //get a reference to the label in the recycled view
        label = (UILabel *)[view viewWithTag:1];
    }
    
    //set item label
    //remember to always set any properties of your carousel item
    //views outside of the `if (view == nil) {...}` check otherwise
    //you'll get weird issues with carousel item content appearing
    //in the wrong place in the carousel
    label.text = categories[(NSUInteger)index] ;
    
    return view;
}

- (NSInteger)numberOfItemsInCarousel:(__unused iCarousel *)carousel
{
    return (NSInteger)[categories count];
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    if (option == iCarouselOptionSpacing)
    {
        return value * 2;
    }
    return value;
}

- (void) carouselCurrentItemIndexDidChange:(iCarousel *)carousel {
    self.lblCategory.text = categories[carousel.currentItemIndex];
}


@end
