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

@implementation DESelectCategoryView

#define BUTTON_HOME_LOC_X 270
#define BUTTON_HOME_LOC_Y 518
#define NUMBER_OF_SECTIONS 13
#define VIEW_WIDTH 250
#define BUTTON_HEIGHT 30
#define BUTTON_WIDTH 30
#define BUTTON_OUTER_CIRCLE_HEIGHT 40
#define BUTTON_OUTER_CIRCLE_WIDTH 40
#define OUTER_VIEW_X_POS 320 - 60
#define OUTER_VIEW_Y_POS 568 - 60

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
        orbColor = [UIColor colorWithRed: 0.161 green: 0.502 blue: 0.725 alpha: 1];
        UIButton *viewCategories = [UIButton new];
        UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
        UIView *outerView = [[UIView alloc] initWithFrame:CGRectMake(OUTER_VIEW_X_POS, OUTER_VIEW_Y_POS, BUTTON_OUTER_CIRCLE_WIDTH, BUTTON_OUTER_CIRCLE_HEIGHT)];
        
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
        
        // Animation for when orb is simply sitting there
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
    self.btnCategory.hidden = YES;
}

- (void) renderView {
    
    NSMutableDictionary *plistData = [[NSMutableDictionary alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"categories" ofType:@"plist"]];
    
    categories = [plistData allKeys];
    
    myCarousel = [[iCarousel alloc] initWithFrame:CGRectMake(self.frame.size.width - 320, self.frame.size.height - 400, 360, 550)];
    myCarousel.type = iCarouselTypeWheel;
    myCarousel.delegate = self;
    myCarousel.dataSource = self;
    [myCarousel reloadData];
    myCarousel.contentOffset = CGSizeMake(40, -140);
    
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

- (void) showOrbsAnimation
{
    UIView *wheelView = [[[NSBundle mainBundle] loadNibNamed:@"SelectCategoryView" owner:self options:nil] lastObject];
    container = [[UIView alloc] initWithFrame:wheelView.frame];
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"categories" ofType:@"plist"]];
    categories = [dictionary allKeys];
    
    myCarousel = [[iCarousel alloc] initWithFrame:CGRectMake(OUTER_VIEW_X_POS, OUTER_VIEW_Y_POS, BUTTON_WIDTH, BUTTON_HEIGHT)];
    myCarousel.type = iCarouselTypeWheel;
    myCarousel.delegate = self;
    myCarousel.dataSource = self;
    myCarousel.decelerationRate = .88f;
    myCarousel.centerItemWhenSelected = YES;
    myCarousel.ignorePerpendicularSwipes = NO;
    [myCarousel reloadData];
    
    [self addSubview:myCarousel];
    
    {
        [UIView animateWithDuration:.2f animations:^{
        
            myCarousel.transform = CGAffineTransformMakeScale(2.54, 2.52);
            //myCarousel.contentOffset = CGSizeMake(0, -80);
            myCarousel.contentOffset = CGSizeMake(5, -myCarousel.frame.size.height + 15);
            NSLog(@"Carousel Center %@", NSStringFromCGPoint(myCarousel.center));
            [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:.9]];
        } completion:^(BOOL finished) {
            [myCarousel setFrame:CGRectMake(0, 150, 320, 418)];
            myCarousel.type = iCarouselTypeWheel;
            myCarousel.delegate = self;
            myCarousel.dataSource = self;
            [myCarousel reloadData];
            myCarousel.contentOffset = CGSizeMake(50, 4.5);
            NSLog(@"Carousel Center %@", NSStringFromCGPoint(myCarousel.center));
        }];
    }
}

- (IBAction)displayCategoryWheel:(UIButton *)sender {
    
    if (!isActive)
    {
        isActive = true;
        
        [self showOrbsAnimation];
        
        [[_btnCategory layer] setZPosition:1.0f];

        self.btnCategory.hidden = NO;
    }
    else {
        [self hideCategoryScreen];
    }
}

- (void) hideCategoryScreen {
    [myCarousel removeFromSuperview];
    [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]];
    self.btnCategory.hidden = YES;
    
    [self reloadEvents];
    
    isActive = false;
}

- (IBAction)categoryButtonClicked:(id)sender {
    
    [self hideCategoryScreen];
}


- (void) reloadEvents
{
    NSArray *events = [[DEPostManager sharedManager] allEvents];
    NSMutableArray *eventsInCategory = [NSMutableArray new];
    
    if (![category isEqualToString:@"Anything"])
    {
        [events enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            DEPost *event = [DEPost getPostFromPFObject:obj];
            
            if ([event.category isEqualToString:category] || [event.category isEqualToString:@"Anything"])
            {
                [eventsInCategory addObject:obj];
            }
        }];
        
        if ([eventsInCategory count] > 0)
        {
            [[DEPostManager sharedManager] setPosts:eventsInCategory];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CENTER_ALL_EVENTS_LOADED object:nil];
        }
        else
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CENTER_NONE_IN_CATEGORY object:nil];
        }
    }
    else {  // If the user selects everything then pull back every posts
        [[DEPostManager sharedManager] setPosts:[[DEPostManager sharedManager] allEvents]];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CENTER_ALL_EVENTS_LOADED object:nil];
    }
    
}

- (void) wheelDidChangeValue: (int) index {
    [self.btnCategory setTitle:[categories objectAtIndex:index] forState:UIControlStateNormal];
    [[myCarousel itemViewAtIndex:index] setBackgroundColor:orbColor];
}

- (void) carouselDidEndDecelerating:(iCarousel *)carousel
{
    [[carousel itemViewAtIndex:[carousel currentItemIndex]] setBackgroundColor:[UIColor colorWithRed:66.0f/255.0f green:188.0f/255.0f blue:98.0f/255.0f alpha:1.0]];
}


- (void) carouselDidScroll:(iCarousel *)carousel
{
    [[carousel itemViewAtIndex:previousIndex] setBackgroundColor:orbColor];
    [[carousel itemViewAtIndex:[carousel currentItemIndex]] setBackgroundColor:[UIColor colorWithRed:66.0f/255.0f green:188.0f/255.0f blue:98.0f/255.0f alpha:1.0]];
    previousIndex = [carousel currentItemIndex];
}

- (UIView *)carousel:(__unused iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    UILabel *label = nil;
    
    //create new view if no view is available for recycling
    if (view == nil)
    {
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, BUTTON_HEIGHT / 1.8, BUTTON_WIDTH / 1.8)];
        view.contentMode = UIViewContentModeCenter;
        [[view layer] setCornerRadius:view.frame.size.height / 2.0f];
        [view setBackgroundColor:orbColor];

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

- (void) carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    [[carousel itemViewAtIndex:[carousel currentItemIndex]] setBackgroundColor:orbColor];
    [[carousel itemViewAtIndex:index] setBackgroundColor:[UIColor colorWithRed:66.0f/255.0f green:188.0f/255.0f blue:98.0f/255.0f alpha:1.0]];
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
    category = [categories objectAtIndex:carousel.currentItemIndex];
    [self.btnCategory setTitle:categories[carousel.currentItemIndex] forState:UIControlStateNormal];
}


@end
