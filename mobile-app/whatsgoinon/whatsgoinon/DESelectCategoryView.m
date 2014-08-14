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
#define BUTTON_HEIGHT 40
#define BUTTON_WIDTH 40

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void) loadView {
    
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    
    UIButton *viewCategories = [[UIButton alloc] initWithFrame:CGRectMake(320 - 60, 568 - 60, BUTTON_WIDTH, BUTTON_HEIGHT)];
    [viewCategories setBackgroundColor:[UIColor blueColor]];
    [viewCategories addTarget:self action:@selector(displayCategoryWheel:) forControlEvents:UIControlEventTouchUpInside];
    [window addSubview:viewCategories];
    
    DEScreenManager *screenManager = [DEScreenManager sharedManager];
    [[screenManager values] setObject:viewCategories forKey:@"viewCategoriesButton"];
    
    isActive = false;
    self.lblCategory.hidden = YES;
}

- (void) addButtonsToView {
    CGFloat angleSize = 2*M_PI/NUMBER_OF_SECTIONS;
    
    // Set all the buttons location to the same location on the screen
    for (int i = 0; i < NUMBER_OF_SECTIONS; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(container.frame.size.width / 2,container.frame.size.height / 2, VIEW_WIDTH, BUTTON_HEIGHT)];
        
        [[view layer] setAnchorPoint:CGPointMake(1.0f, 0.5f)];
        [[view layer] setPosition:CGPointMake(container.bounds.size.width/2, container.bounds.size.height/2.0)];
        
        [view setTransform:CGAffineTransformMakeRotation(angleSize * i)];
        
        view.tag = i;
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [button setBackgroundColor:[UIColor blueColor]];
        [view addSubview:button];
        [container addSubview:view];
    }
}

- (void) renderView {
    
    UIView *wheelView = [[[NSBundle mainBundle] loadNibNamed:@"SelectCategoryView" owner:self options:nil] lastObject];
    container = [[UIView alloc] initWithFrame:wheelView.frame];

    CGRect frame = container.frame;
    int xPos = 320 - (container.frame.size.width / 2);
    int yPos = 568 - (container.frame.size.height / 2);
    frame.origin.x = xPos;
    frame.origin.y = yPos;
    container.frame = frame;
    
    // Add all the different category buttons to the view
    [self addButtonsToView];
    
    container.userInteractionEnabled = NO;
    [self addSubview:container];
    
    // 8 - Initialize the sectors of the wheel
    _sectors = [NSMutableArray arrayWithCapacity:NUMBER_OF_SECTIONS];
    if (NUMBER_OF_SECTIONS % 2 == 0) {
        [self buildSectorsEven];
    } else {
        [self buildSectorsOdd];
    }
    
    //Add the gesture recognizer to the view
    _panGestureRecognizer = [[UIPanGestureRecognizer alloc] init];
    _panGestureRecognizer.delegate = self;
    [self addGestureRecognizer:_panGestureRecognizer];
    
    // Initialize the categories
    categories = [NSArray arrayWithObjects:@"Featured", @"Under 21", @"Party", @"Classy", @"Over 21", @"Crazy", @"Funny", @"Music", @"Environmental", @"Ridiculous", @"Dancing", @"Nerdy", @"Pricy", nil];
    
    // Upload the label that contains the name of the category
    [self wheelDidChangeValue:self.currentSector];
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


- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    // 1 - Get touch position
    CGPoint touchPoint = [[touches anyObject] locationInView:self];
    
    // 2 - Calculate distance from center
    float dx = touchPoint.x - container.center.x;
    float dy = touchPoint.y - container.center.y;
    // 3 - Calculate arctangent value
    deltaAngle = atan2(dy,dx);
    // 4 - Save current transform
    _startTransform = container.transform;
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    // logs the rotation of the container each time the user drags their finger
    CGFloat radians = atan2f(container.transform.b, container.transform.a);
    NSLog(@"rad is %f", radians);
    
    // Get the touch position
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    
    // 1.1 - Get the distance from the center
    float dist = [self calculateDistanceFromCenter:touchPoint];
    // 1.2 - Filter out touches too close to the center
    if (dist < 40 )
    {
        // forcing a tap to be on the ferrule
        NSLog(@"ignoring tap (%f,%f)", touchPoint.x, touchPoint.y);
    }
    else {
        // Calculate distance from center
        float dx = touchPoint.x - container.center.x;
        float dy = touchPoint.y - container.center.y;
        float ang = atan2(dy, dx);
        float angleDifference = deltaAngle - ang;
        container.transform = CGAffineTransformRotate(_startTransform, -angleDifference);
        
        [self wheelDidChangeValue:self.currentSector];
    }

    
    
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
//    CGPoint velocity = [[touches anyObject] velocityInView:self];
    
    // 1 - Get current container rotation in radians
    CGFloat radians = atan2f(container.transform.b, container.transform.a);
    // 2 - Initialize new value
    CGFloat newVal = 0.0;
    // 3 - Iterate through all the sectors
    for (DESector *s in _sectors) {
        // 4 - Check for anomaly (occurs with even number of sectors)
        if (s.minValue > 0 && s.maxValue < 0) {
            if (s.maxValue > radians || s.minValue < radians) {
                // 5 - Find the quadrant (positive or negative)
                if (radians > 0) {
                    newVal = radians - M_PI;
                } else {
                    newVal = M_PI + radians;
                }
                _currentSector = s.sector;
            }
        }
        // 6 - All non-anomalous cases
        else if (radians > s.minValue && radians < s.maxValue) {
            newVal = radians - s.midValue;
            _currentSector = s.sector;
        }
    }
    // 7 - Set up animation for final rotation
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    CGAffineTransform t = CGAffineTransformRotate(container.transform, -newVal);
    container.transform = t;
    [UIView commitAnimations];
    
    [self wheelDidChangeValue:self.currentSector];

}


- (float) calculateDistanceFromCenter:(CGPoint)point {
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    float dx = point.x - center.x;
    float dy = point.y - center.y;
    return sqrt(dx*dx + dy*dy);
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
        [container removeFromSuperview];
        [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]];
        self.lblCategory.hidden = YES;
        
        isActive = false;
    }
}

- (void) buildSectorsOdd {
	// 1 - Define sector length
    CGFloat fanWidth = M_PI*2/NUMBER_OF_SECTIONS;
	// 2 - Set initial midpoint
    CGFloat mid = 0;
	// 3 - Iterate through all sectors
    for (int i = 0; i < NUMBER_OF_SECTIONS; i++) {
        DESector *sector = [[DESector alloc] init];
		// 4 - Set sector values
        sector.midValue = mid;
        sector.minValue = mid - (fanWidth/2);
        sector.maxValue = mid + (fanWidth/2);
        sector.sector = i;
        mid -= fanWidth;
        if (sector.minValue < - M_PI) {
            mid = -mid;
            mid -= fanWidth;
        }
		// 5 - Add sector to array
        [_sectors addObject:sector];
		NSLog(@"cl is %@", sector);
    }
}

- (void) buildSectorsEven {
    // 1 - Define sector length
    CGFloat fanWidth = M_PI*2/NUMBER_OF_SECTIONS;
    // 2 - Set initial midpoint
    CGFloat mid = 0;
    // 3 - Iterate through all sectors
    for (int i = 0; i < NUMBER_OF_SECTIONS; i++) {
        DESector *sector = [[DESector alloc] init];
        // 4 - Set sector values
        sector.midValue = mid;
        sector.minValue = mid - (fanWidth/2);
        sector.maxValue = mid + (fanWidth/2);
        sector.sector = i;
        if (sector.maxValue-fanWidth < - M_PI) {
            mid = M_PI;
            sector.midValue = mid;
            sector.minValue = fabsf(sector.maxValue);
            
        }
        mid -= fanWidth;
        NSLog(@"cl is %@", sector);
        // 5 - Add sector to array
        [_sectors addObject:sector];
    }
}

- (void) wheelDidChangeValue: (int) index {
    
    self.lblCategory.text = [categories objectAtIndex:index];
}

@end
