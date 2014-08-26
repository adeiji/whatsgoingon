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
#import "Constants.h"

static float deltaAngle;

@implementation DESelectCategoryView

#define BUTTON_HOME_LOC_X 270
#define BUTTON_HOME_LOC_Y 518
#define NUMBER_OF_SECTIONS 13
#define VIEW_WIDTH 250
#define BUTTON_HEIGHT 40
#define BUTTON_WIDTH 40
#define BUTTON_OUTER_CIRCLE_HEIGHT 60
#define BUTTON_OUTER_CIRCLE_WIDTH 60
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
    UIView *outerView = [[screenManager values] objectForKey:ORB_BUTTON_VIEW];
    
    if (![[screenManager values] objectForKey:ORB_BUTTON_VIEW])
    {
        UIColor *orbColor = [UIColor colorWithRed: 0.161 green: 0.502 blue: 0.725 alpha: 1];
        UIButton *viewCategories = [UIButton new];
        UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
        UIView *outerView = [[UIView alloc] initWithFrame:CGRectMake(320 - 90, 568 - 90, BUTTON_OUTER_CIRCLE_WIDTH, BUTTON_OUTER_CIRCLE_HEIGHT)];
        
        viewCategories = [[UIButton alloc] initWithFrame:CGRectMake((BUTTON_OUTER_CIRCLE_HEIGHT / 2.0) - (BUTTON_WIDTH / 2), (BUTTON_OUTER_CIRCLE_WIDTH / 2.0) - (BUTTON_HEIGHT / 2), BUTTON_WIDTH, BUTTON_HEIGHT)];
        
        // Outer View Group
        {
            [[outerView layer] setBackgroundColor:[UIColor clearColor].CGColor];
            [[outerView layer] setCornerRadius:BUTTON_OUTER_CIRCLE_HEIGHT / 2.0f];
            [[outerView layer] setBorderColor:orbColor.CGColor];
            [[outerView layer] setBorderWidth:2.0f];
        }
        
        // View Categories Button Group
        {
            [[viewCategories layer] setCornerRadius:BUTTON_HEIGHT / 2.0f];
            [viewCategories setBackgroundColor:orbColor];
            [viewCategories addTarget:self action:@selector(displayCategoryWheel:) forControlEvents:UIControlEventTouchUpInside];
            [viewCategories setOpaque:NO];
        }
        [outerView addSubview:viewCategories];
        [window addSubview:outerView];
        
        // Animation
        {
            [UIView animateWithDuration:0.8f delay:0.0f options:UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^{
                
                outerView.transform = CGAffineTransformMakeScale(1.2, 1.2);
                viewCategories.transform = CGAffineTransformMakeScale(.9, .9);
                
            } completion:NULL];
        }
        
        [[screenManager values] setObject:outerView forKey:ORB_BUTTON_VIEW];
    }
    else
    {
        outerView.hidden = NO;
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
        UIView *orbView = [[screenManager values] objectForKey:ORB_BUTTON_VIEW];
        if (CGRectContainsPoint(orbView.frame, point))
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
