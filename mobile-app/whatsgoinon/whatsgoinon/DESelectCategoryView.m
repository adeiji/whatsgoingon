//
//  DE_orbViewView.m
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

#define NUMBER_OF_SECTIONS 13
#define VIEW_WIDTH 250
#define BUTTON_HEIGHT 30
#define BUTTON_WIDTH 30
#define BUTTON_OUTER_CIRCLE_HEIGHT 40
#define BUTTON_OUTER_CIRCLE_WIDTH 40

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

- (void) setButtonConstants {
    BUTTON_HOME_LOC_X = [[UIScreen mainScreen] bounds].size.width - 50;
    BUTTON_HOME_LOC_Y = [[UIScreen mainScreen] bounds].size.height - 50;
    OUTER_VIEW_X_POS = [[UIScreen mainScreen] bounds].size.width - 60;
    OUTER_VIEW_Y_POS = [[UIScreen mainScreen] bounds].size.height - 60;
}

- (void) loadView {
    [self setButtonConstants];
    
    orbColor = [UIColor colorWithRed: 66.0f/255.0f green:188.0f/255.0f blue:98.0f/255.0f alpha: 1];
    _orbView = [UIButton new];
    _outerView = [[UIView alloc] initWithFrame:CGRectMake(OUTER_VIEW_X_POS, OUTER_VIEW_Y_POS, BUTTON_OUTER_CIRCLE_WIDTH, BUTTON_OUTER_CIRCLE_HEIGHT)];
    
    _orbView = [[UIButton alloc] initWithFrame:CGRectMake((BUTTON_OUTER_CIRCLE_HEIGHT / 2.0) - (BUTTON_WIDTH / 2), (BUTTON_OUTER_CIRCLE_WIDTH / 2.0) - (BUTTON_HEIGHT / 2), BUTTON_WIDTH, BUTTON_HEIGHT)];
    
    // Outer View Group
    {
        [[_outerView layer] setBackgroundColor:[UIColor clearColor].CGColor];
        [[_outerView layer] setCornerRadius:BUTTON_OUTER_CIRCLE_HEIGHT / 2.0f];
        [[_outerView layer] setBorderColor:orbColor.CGColor];
        [[_outerView layer] setBorderWidth:2.0f];
    }
    
    // View Categories Button Group
    {
        [[_orbView layer] setCornerRadius:BUTTON_HEIGHT / 2.0f];
        [_orbView setBackgroundColor:orbColor];
        [_orbView addTarget:self action:@selector(displayCategoryWheel:) forControlEvents:UIControlEventTouchUpInside];
        [_orbView setOpaque:NO];
    }
    [_outerView addSubview:_orbView];
    [[self superview] addSubview:_outerView];
    
    // Animation for when orb is simply sitting there
    {
        [UIView animateWithDuration:0.8f delay:0.0f options:UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^{
            
            _outerView.transform = CGAffineTransformMakeScale(1.2, 1.2);
            _orbView.transform = CGAffineTransformMakeScale(.9, .9);
            
        } completion:NULL];
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
        if (CGRectContainsPoint(_orbView.frame, point))
        {
            return NO;
        }
        
        return YES;
    }
    {
        return NO;
    }
}

// Load all the categories from the categories.plist file and then order them by name

- (void) loadCategories {
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"categories" ofType:@"plist"]];
    categories = [dictionary allKeys];
    categories = [categories sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    
}

- (void) showOrbsAnimation
{
    UIView *wheelView = [[[NSBundle mainBundle] loadNibNamed:@"SelectCategoryView" owner:self options:nil] lastObject];
    container = [[UIView alloc] initWithFrame:wheelView.frame];
    
    [self loadCategories];
    
    if (!myCarousel)
    {
        myCarousel = [[iCarousel alloc] initWithFrame:CGRectMake(OUTER_VIEW_X_POS, OUTER_VIEW_Y_POS, BUTTON_WIDTH, BUTTON_HEIGHT)];
        myCarousel.type = iCarouselTypeWheel;
        myCarousel.delegate = self;
        myCarousel.dataSource = self;
        [myCarousel scrollToItemAtIndex:(NSInteger)[categories indexOfObject:CATEGORY_TRENDING] animated:NO];
    }
    myCarousel.type = iCarouselTypeWheel;
    myCarousel.delegate = self;
    myCarousel.dataSource = self;
    myCarousel.decelerationRate = .88f;
    myCarousel.centerItemWhenSelected = YES;
    myCarousel.ignorePerpendicularSwipes = NO;
    [myCarousel reloadData];
    
    [self addSubview:myCarousel];
    
    // This carosaul starts basically from a simple point and then expands into where it will be when the user starts scrolling
    {
        [UIView animateWithDuration:.2f animations:^{
            myCarousel.transform = CGAffineTransformMakeScale(2.54, 2.52);
            //myCarousel.contentOffset = CGSizeMake(0, -80);
            myCarousel.contentOffset = CGSizeMake(5, -myCarousel.frame.size.height + 15);
            NSLog(@"Carousel Center %@", NSStringFromCGPoint(myCarousel.center));
            [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:.9]];
        } completion:^(BOOL finished) {
//            [myCarousel setFrame:CGRectMake(0, 150, 320, 418)];
            double xPos = [[UIScreen mainScreen] bounds].size.width - 320;
            double yPos = [[UIScreen mainScreen] bounds].size.height - 418;
            [myCarousel setFrame:CGRectMake(xPos, yPos, 320, 418)];
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
    // Sort through all the posts and get the ones in this specific category
    [DEPostManager getPostInCategory : category];
}

- (void) wheelDidChangeValue: (int) index {
    [self.btnCategory setTitle:[categories objectAtIndex:index] forState:UIControlStateNormal];
    [[myCarousel itemViewAtIndex:index] setBackgroundColor:[HPStyleKit blueColor]];
}

- (void) carouselDidEndDecelerating:(iCarousel *)carousel
{
    [[carousel itemViewAtIndex:[carousel currentItemIndex]] setBackgroundColor:[HPStyleKit blueColor]];
}


- (void) carouselDidScroll:(iCarousel *)carousel
{
    [[carousel itemViewAtIndex:previousIndex] setBackgroundColor:orbColor];
    [[carousel itemViewAtIndex:[carousel currentItemIndex]] setBackgroundColor:[HPStyleKit blueColor]];
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
        
        // If this is the first item on the view
        if (index == [carousel currentItemIndex])
        {
            [view setBackgroundColor:[HPStyleKit blueColor]];
        }

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
    [[carousel itemViewAtIndex:index] setBackgroundColor:[HPStyleKit blueColor]];
    
    if (index == [carousel currentItemIndex])
    {
        [self categoryButtonClicked:nil];
    }
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
