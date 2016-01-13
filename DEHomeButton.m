//
//  DEHomeButton.m
//  whatsgoinon
//
//  Created by adeiji on 9/9/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import "DEHomeButton.h"

@implementation DEHomeButton

- (void) drawRect:(CGRect)rect
{
    //// Color Declarations
    UIColor* color0 = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
    
    //// Layer_1
    {
        //// Group 3
        {
            //// Bezier 2 Drawing
            UIBezierPath* bezier2Path = UIBezierPath.bezierPath;
            [bezier2Path moveToPoint: CGPointMake(10.61, 16.76)];
            [bezier2Path addLineToPoint: CGPointMake(10.61, 31.47)];
            [bezier2Path addCurveToPoint: CGPointMake(12.35, 33.29) controlPoint1: CGPointMake(10.61, 32.46) controlPoint2: CGPointMake(11.37, 33.29)];
            [bezier2Path addLineToPoint: CGPointMake(18.19, 33.29)];
            [color0 setStroke];
            bezier2Path.lineWidth = 0.5;
            [bezier2Path stroke];
            
            
            //// Bezier 4 Drawing
            UIBezierPath* bezier4Path = UIBezierPath.bezierPath;
            [bezier4Path moveToPoint: CGPointMake(30.63, 16.84)];
            [bezier4Path addLineToPoint: CGPointMake(30.63, 31.55)];
            [bezier4Path addCurveToPoint: CGPointMake(28.88, 33.37) controlPoint1: CGPointMake(30.63, 32.54) controlPoint2: CGPointMake(29.87, 33.37)];
            [bezier4Path addLineToPoint: CGPointMake(24.18, 33.37)];
            [color0 setStroke];
            bezier4Path.lineWidth = 0.5;
            [bezier4Path stroke];
            
            
            //// Bezier 6 Drawing
            UIBezierPath* bezier6Path = UIBezierPath.bezierPath;
            [bezier6Path moveToPoint: CGPointMake(24.18, 33.55)];
            [bezier6Path addLineToPoint: CGPointMake(24.18, 21.84)];
            [bezier6Path addLineToPoint: CGPointMake(18.19, 21.84)];
            [bezier6Path addLineToPoint: CGPointMake(18.19, 33.55)];
            [color0 setStroke];
            bezier6Path.lineWidth = 0.5;
            [bezier6Path stroke];
            
            
            //// Bezier 8 Drawing
            UIBezierPath* bezier8Path = UIBezierPath.bezierPath;
            [bezier8Path moveToPoint: CGPointMake(10.61, 17.14)];
            [bezier8Path addLineToPoint: CGPointMake(7.12, 17.14)];
            [bezier8Path addCurveToPoint: CGPointMake(6.74, 15.93) controlPoint1: CGPointMake(6.51, 17.14) controlPoint2: CGPointMake(6.29, 16.31)];
            [bezier8Path addLineToPoint: CGPointMake(20.31, 5.61)];
            [bezier8Path addCurveToPoint: CGPointMake(21.07, 5.61) controlPoint1: CGPointMake(20.54, 5.46) controlPoint2: CGPointMake(20.84, 5.46)];
            [bezier8Path addLineToPoint: CGPointMake(24.94, 8.57)];
            [color0 setStroke];
            bezier8Path.lineWidth = 0.5;
            [bezier8Path stroke];
            
            
            //// Bezier 10 Drawing
            UIBezierPath* bezier10Path = UIBezierPath.bezierPath;
            [bezier10Path moveToPoint: CGPointMake(29.26, 11.91)];
            [bezier10Path addLineToPoint: CGPointMake(34.49, 15.93)];
            [bezier10Path addCurveToPoint: CGPointMake(34.11, 17.14) controlPoint1: CGPointMake(34.95, 16.31) controlPoint2: CGPointMake(34.72, 17.14)];
            [bezier10Path addLineToPoint: CGPointMake(30.63, 17.14)];
            [color0 setStroke];
            bezier10Path.lineWidth = 0.5;
            [bezier10Path stroke];
            
            
            //// Bezier 12 Drawing
            UIBezierPath* bezier12Path = UIBezierPath.bezierPath;
            [bezier12Path moveToPoint: CGPointMake(25.01, 8.87)];
            [bezier12Path addLineToPoint: CGPointMake(25.01, 7.13)];
            [bezier12Path addCurveToPoint: CGPointMake(26.08, 5.99) controlPoint1: CGPointMake(25.01, 6.52) controlPoint2: CGPointMake(25.47, 5.99)];
            [bezier12Path addLineToPoint: CGPointMake(28.28, 5.99)];
            [bezier12Path addCurveToPoint: CGPointMake(29.34, 7.13) controlPoint1: CGPointMake(28.88, 5.99) controlPoint2: CGPointMake(29.34, 6.52)];
            [bezier12Path addLineToPoint: CGPointMake(29.34, 12.21)];
            [color0 setStroke];
            bezier12Path.lineWidth = 0.5;
            [bezier12Path stroke];
            
            
            //// Bezier 14 Drawing
            UIBezierPath* bezier14Path = UIBezierPath.bezierPath;
            [bezier14Path moveToPoint: CGPointMake(17.58, 33.37)];
            [bezier14Path addLineToPoint: CGPointMake(18.57, 33.37)];
            [color0 setStroke];
            bezier14Path.lineWidth = 0.5;
            [bezier14Path stroke];
            
            
            //// Bezier 16 Drawing
            UIBezierPath* bezier16Path = UIBezierPath.bezierPath;
            [bezier16Path moveToPoint: CGPointMake(23.8, 33.37)];
            [bezier16Path addLineToPoint: CGPointMake(24.79, 33.37)];
            [color0 setStroke];
            bezier16Path.lineWidth = 0.5;
            [bezier16Path stroke];
        }
    }
}

@end
