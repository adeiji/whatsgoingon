//
//  DEBackButton.m
//  whatsgoinon
//
//  Created by adeiji on 8/28/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import "DEBackButton.h"

@implementation DEBackButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    //// Color Declarations
    UIColor* color0 = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
    
    //// Layer_1
    {
    }
    
    
    //// Events_1
    {
        //// Bezier 2 Drawing
        UIBezierPath* bezier2Path = UIBezierPath.bezierPath;
        [bezier2Path moveToPoint: CGPointMake(27.1, 37)];
        [bezier2Path addLineToPoint: CGPointMake(12.4, 23.6)];
        [bezier2Path addLineToPoint: CGPointMake(27.1, 10.2)];
        [color0 setStroke];
        bezier2Path.lineWidth = 2;
        [bezier2Path stroke];
    }



}

@end
