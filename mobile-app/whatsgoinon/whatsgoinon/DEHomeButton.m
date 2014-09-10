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
            [bezier2Path moveToPoint: CGPointMake(9.19, 16.36)];
            [bezier2Path addLineToPoint: CGPointMake(9.19, 33.15)];
            [bezier2Path addCurveToPoint: CGPointMake(11.18, 35.23) controlPoint1: CGPointMake(9.19, 34.28) controlPoint2: CGPointMake(10.06, 35.23)];
            [bezier2Path addLineToPoint: CGPointMake(17.85, 35.23)];
            [color0 setStroke];
            bezier2Path.lineWidth = 1.5;
            [bezier2Path stroke];
            
            
            //// Bezier 4 Drawing
            UIBezierPath* bezier4Path = UIBezierPath.bezierPath;
            [bezier4Path moveToPoint: CGPointMake(32.04, 16.44)];
            [bezier4Path addLineToPoint: CGPointMake(32.04, 33.24)];
            [bezier4Path addCurveToPoint: CGPointMake(30.05, 35.32) controlPoint1: CGPointMake(32.04, 34.36) controlPoint2: CGPointMake(31.18, 35.32)];
            [bezier4Path addLineToPoint: CGPointMake(24.69, 35.32)];
            [color0 setStroke];
            bezier4Path.lineWidth = 1.5;
            [bezier4Path stroke];
            
            
            //// Bezier 6 Drawing
            UIBezierPath* bezier6Path = UIBezierPath.bezierPath;
            [bezier6Path moveToPoint: CGPointMake(24.69, 35.75)];
            [bezier6Path addLineToPoint: CGPointMake(24.69, 22.16)];
            [bezier6Path addLineToPoint: CGPointMake(17.85, 22.16)];
            [bezier6Path addLineToPoint: CGPointMake(17.85, 35.75)];
            [color0 setStroke];
            bezier6Path.lineWidth = 1.5;
            [bezier6Path stroke];
            
            
            //// Bezier 8 Drawing
            UIBezierPath* bezier8Path = UIBezierPath.bezierPath;
            [bezier8Path moveToPoint: CGPointMake(9.19, 16.79)];
            [bezier8Path addLineToPoint: CGPointMake(5.21, 16.79)];
            [bezier8Path addCurveToPoint: CGPointMake(4.77, 15.4) controlPoint1: CGPointMake(4.51, 16.79) controlPoint2: CGPointMake(4.25, 15.84)];
            [bezier8Path addLineToPoint: CGPointMake(20.27, 3.63)];
            [bezier8Path addCurveToPoint: CGPointMake(21.14, 3.63) controlPoint1: CGPointMake(20.53, 3.46) controlPoint2: CGPointMake(20.88, 3.46)];
            [bezier8Path addLineToPoint: CGPointMake(25.55, 7.01)];
            [color0 setStroke];
            bezier8Path.lineWidth = 1.5;
            [bezier8Path stroke];
            
            
            //// Bezier 10 Drawing
            UIBezierPath* bezier10Path = UIBezierPath.bezierPath;
            [bezier10Path moveToPoint: CGPointMake(30.49, 10.82)];
            [bezier10Path addLineToPoint: CGPointMake(36.46, 15.4)];
            [bezier10Path addCurveToPoint: CGPointMake(36.03, 16.79) controlPoint1: CGPointMake(36.98, 15.84) controlPoint2: CGPointMake(36.72, 16.79)];
            [bezier10Path addLineToPoint: CGPointMake(32.04, 16.79)];
            [color0 setStroke];
            bezier10Path.lineWidth = 1.5;
            [bezier10Path stroke];
            
            
            //// Bezier 12 Drawing
            UIBezierPath* bezier12Path = UIBezierPath.bezierPath;
            [bezier12Path moveToPoint: CGPointMake(25.64, 7.35)];
            [bezier12Path addLineToPoint: CGPointMake(25.64, 5.36)];
            [bezier12Path addCurveToPoint: CGPointMake(26.85, 4.06) controlPoint1: CGPointMake(25.64, 4.67) controlPoint2: CGPointMake(26.16, 4.06)];
            [bezier12Path addLineToPoint: CGPointMake(29.36, 4.06)];
            [bezier12Path addCurveToPoint: CGPointMake(30.57, 5.36) controlPoint1: CGPointMake(30.05, 4.06) controlPoint2: CGPointMake(30.57, 4.67)];
            [bezier12Path addLineToPoint: CGPointMake(30.57, 11.16)];
            [color0 setStroke];
            bezier12Path.lineWidth = 1.5;
            [bezier12Path stroke];
            
            
            //// Bezier 14 Drawing
            UIBezierPath* bezier14Path = UIBezierPath.bezierPath;
            [bezier14Path moveToPoint: CGPointMake(17.15, 35.32)];
            [bezier14Path addLineToPoint: CGPointMake(18.28, 35.32)];
            [color0 setStroke];
            bezier14Path.lineWidth = 1.5;
            [bezier14Path stroke];
            
            
            //// Bezier 16 Drawing
            UIBezierPath* bezier16Path = UIBezierPath.bezierPath;
            [bezier16Path moveToPoint: CGPointMake(24.25, 35.32)];
            [bezier16Path addLineToPoint: CGPointMake(25.38, 35.32)];
            [color0 setStroke];
            bezier16Path.lineWidth = 1.5;
            [bezier16Path stroke];
        }
    }


}

@end
