//
//  DEViewLocation.m
//  whatsgoinon
//
//  Created by adeiji on 9/10/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import "DEViewLocation.h"

@implementation DEViewLocation

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    //// Color Declarations
    UIColor* color4 = [UIColor colorWithRed: 0.222 green: 0.699 blue: 0.312 alpha: 1];
    
    {
        //// Bezier 2 Drawing
        UIBezierPath* bezier2Path = UIBezierPath.bezierPath;
        [bezier2Path moveToPoint: CGPointMake(14.64, 14.8)];
        [bezier2Path addCurveToPoint: CGPointMake(19.3, 8.04) controlPoint1: CGPointMake(17.37, 13.73) controlPoint2: CGPointMake(19.3, 11.11)];
        [bezier2Path addCurveToPoint: CGPointMake(12, 0.8) controlPoint1: CGPointMake(19.3, 4.04) controlPoint2: CGPointMake(16.03, 0.8)];
        [bezier2Path addCurveToPoint: CGPointMake(4.7, 8.04) controlPoint1: CGPointMake(7.97, 0.8) controlPoint2: CGPointMake(4.7, 4.04)];
        [bezier2Path addCurveToPoint: CGPointMake(9.36, 14.8) controlPoint1: CGPointMake(4.7, 11.11) controlPoint2: CGPointMake(6.63, 13.73)];
        bezier2Path.miterLimit = 4;
        
        [color4 setFill];
        [bezier2Path fill];
        
        
        //// Bezier 4 Drawing
        UIBezierPath* bezier4Path = UIBezierPath.bezierPath;
        [bezier4Path moveToPoint: CGPointMake(9.36, 14.62)];
        [bezier4Path addLineToPoint: CGPointMake(12.04, 22.4)];
        [bezier4Path addLineToPoint: CGPointMake(14.64, 14.62)];
        bezier4Path.miterLimit = 4;
        
        [color4 setFill];
        [bezier4Path fill];
    }

}


@end
