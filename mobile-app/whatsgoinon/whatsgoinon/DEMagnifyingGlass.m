//
//  DEMagnifyingGlass.m
//  whatsgoinon
//
//  Created by adeiji on 8/26/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import "DEMagnifyingGlass.h"

@implementation DEMagnifyingGlass

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
        //// Bezier 2 Drawing
        UIBezierPath* bezier2Path = UIBezierPath.bezierPath;
        [bezier2Path moveToPoint: CGPointMake(21.8, 11.08)];
        [bezier2Path addCurveToPoint: CGPointMake(14.55, 17.87) controlPoint1: CGPointMake(21.8, 14.83) controlPoint2: CGPointMake(18.55, 17.87)];
        [bezier2Path addCurveToPoint: CGPointMake(9.17, 15.64) controlPoint1: CGPointMake(12.42, 17.87) controlPoint2: CGPointMake(10.5, 17.01)];
        [bezier2Path addCurveToPoint: CGPointMake(7.29, 11.08) controlPoint1: CGPointMake(8, 14.43) controlPoint2: CGPointMake(7.29, 12.83)];
        [bezier2Path addCurveToPoint: CGPointMake(14.55, 4.3) controlPoint1: CGPointMake(7.29, 7.34) controlPoint2: CGPointMake(10.54, 4.3)];
        [bezier2Path addCurveToPoint: CGPointMake(21.8, 11.08) controlPoint1: CGPointMake(18.55, 4.3) controlPoint2: CGPointMake(21.8, 7.34)];
        [bezier2Path closePath];
        [color0 setStroke];
        bezier2Path.lineWidth = 2;
        [bezier2Path stroke];
        
        
        //// Group 3
        {
            //// Group 4
            {
                //// Bezier 4 Drawing
                UIBezierPath* bezier4Path = UIBezierPath.bezierPath;
                [bezier4Path moveToPoint: CGPointMake(8.76, 15.09)];
                [bezier4Path addCurveToPoint: CGPointMake(3.9, 20.03) controlPoint1: CGPointMake(7.14, 16.74) controlPoint2: CGPointMake(5.52, 18.38)];
                [bezier4Path addCurveToPoint: CGPointMake(2.7, 21.26) controlPoint1: CGPointMake(3.5, 20.44) controlPoint2: CGPointMake(3.1, 20.84)];
                [bezier4Path addCurveToPoint: CGPointMake(2.7, 22.55) controlPoint1: CGPointMake(2.34, 21.62) controlPoint2: CGPointMake(2.32, 22.19)];
                [bezier4Path addCurveToPoint: CGPointMake(4.04, 22.55) controlPoint1: CGPointMake(3.06, 22.89) controlPoint2: CGPointMake(3.68, 22.91)];
                [bezier4Path addCurveToPoint: CGPointMake(8.9, 17.6) controlPoint1: CGPointMake(5.66, 20.9) controlPoint2: CGPointMake(7.28, 19.25)];
                [bezier4Path addCurveToPoint: CGPointMake(10.1, 16.38) controlPoint1: CGPointMake(9.3, 17.2) controlPoint2: CGPointMake(9.7, 16.79)];
                [bezier4Path addCurveToPoint: CGPointMake(10.1, 15.09) controlPoint1: CGPointMake(10.46, 16.02) controlPoint2: CGPointMake(10.48, 15.45)];
                [bezier4Path addCurveToPoint: CGPointMake(8.76, 15.09) controlPoint1: CGPointMake(9.74, 14.75) controlPoint2: CGPointMake(9.12, 14.73)];
                [bezier4Path addLineToPoint: CGPointMake(8.76, 15.09)];
                [bezier4Path closePath];
                bezier4Path.miterLimit = 4;
                
                [color0 setFill];
                [bezier4Path fill];
            }
        }
    }
}


@end
