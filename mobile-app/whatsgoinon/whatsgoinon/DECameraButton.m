//
//  DECameraButton.m
//  whatsgoinon
//
//  Created by adeiji on 9/9/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import "DECameraButton.h"

@implementation DECameraButton

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
    if (self.tag == LARGE)
    {
        //// Color Declarations
        UIColor* color0 = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];

        //// Artboard_2
        {
            //// Bezier 2 Drawing
            UIBezierPath* bezier2Path = UIBezierPath.bezierPath;
            [bezier2Path moveToPoint: CGPointMake(102.03, 61.73)];
            [bezier2Path addLineToPoint: CGPointMake(125.05, 61.73)];
            [bezier2Path addCurveToPoint: CGPointMake(128, 64.67) controlPoint1: CGPointMake(126.62, 61.73) controlPoint2: CGPointMake(128, 63.02)];
            [bezier2Path addLineToPoint: CGPointMake(128, 108.67)];
            [bezier2Path addCurveToPoint: CGPointMake(125.05, 111.6) controlPoint1: CGPointMake(128, 110.22) controlPoint2: CGPointMake(126.71, 111.6)];
            [bezier2Path addLineToPoint: CGPointMake(60.95, 111.6)];
            [bezier2Path addCurveToPoint: CGPointMake(58, 108.67) controlPoint1: CGPointMake(59.38, 111.6) controlPoint2: CGPointMake(58, 110.32)];
            [bezier2Path addLineToPoint: CGPointMake(58, 64.67)];
            [bezier2Path addCurveToPoint: CGPointMake(60.95, 61.73) controlPoint1: CGPointMake(58, 63.11) controlPoint2: CGPointMake(59.29, 61.73)];
            [bezier2Path addLineToPoint: CGPointMake(83.97, 61.73)];
            [color0 setStroke];
            bezier2Path.lineWidth = 1.7;
            [bezier2Path stroke];
            
            
            //// Bezier 4 Drawing
            UIBezierPath* bezier4Path = UIBezierPath.bezierPath;
            [bezier4Path moveToPoint: CGPointMake(112.34, 86.21)];
            [bezier4Path addCurveToPoint: CGPointMake(92.63, 105.82) controlPoint1: CGPointMake(112.53, 97.12) controlPoint2: CGPointMake(103.59, 106.1)];
            [bezier4Path addCurveToPoint: CGPointMake(73.66, 86.94) controlPoint1: CGPointMake(82.32, 105.64) controlPoint2: CGPointMake(73.84, 97.21)];
            [bezier4Path addCurveToPoint: CGPointMake(93.37, 67.32) controlPoint1: CGPointMake(73.38, 76.03) controlPoint2: CGPointMake(82.41, 67.05)];
            [bezier4Path addCurveToPoint: CGPointMake(112.34, 86.21) controlPoint1: CGPointMake(103.68, 67.51) controlPoint2: CGPointMake(112.16, 75.94)];
            [bezier4Path closePath];
            [color0 setStroke];
            bezier4Path.lineWidth = 1.7;
            [bezier4Path stroke];
            
            
            //// Bezier 6 Drawing
            UIBezierPath* bezier6Path = UIBezierPath.bezierPath;
            [bezier6Path moveToPoint: CGPointMake(102.03, 62.47)];
            [bezier6Path addLineToPoint: CGPointMake(102.03, 59.53)];
            [bezier6Path addCurveToPoint: CGPointMake(99.08, 56.6) controlPoint1: CGPointMake(102.03, 57.97) controlPoint2: CGPointMake(100.74, 56.6)];
            [bezier6Path addLineToPoint: CGPointMake(86.83, 56.6)];
            [bezier6Path addCurveToPoint: CGPointMake(83.88, 59.53) controlPoint1: CGPointMake(85.26, 56.6) controlPoint2: CGPointMake(83.88, 57.88)];
            [bezier6Path addLineToPoint: CGPointMake(83.88, 62.47)];
            [color0 setStroke];
            bezier6Path.lineWidth = 1.7;
            [bezier6Path stroke];
            
            
            //// Bezier 8 Drawing
            UIBezierPath* bezier8Path = UIBezierPath.bezierPath;
            [bezier8Path moveToPoint: CGPointMake(122.2, 70.44)];
            [bezier8Path addLineToPoint: CGPointMake(116.76, 70.44)];
            [bezier8Path addCurveToPoint: CGPointMake(113.82, 67.51) controlPoint1: CGPointMake(115.2, 70.44) controlPoint2: CGPointMake(113.82, 69.16)];
            [bezier8Path addLineToPoint: CGPointMake(113.82, 67.51)];
            [bezier8Path addCurveToPoint: CGPointMake(116.76, 64.57) controlPoint1: CGPointMake(113.82, 65.95) controlPoint2: CGPointMake(115.11, 64.57)];
            [bezier8Path addLineToPoint: CGPointMake(122.2, 64.57)];
            [bezier8Path addCurveToPoint: CGPointMake(125.14, 67.51) controlPoint1: CGPointMake(123.76, 64.57) controlPoint2: CGPointMake(125.14, 65.86)];
            [bezier8Path addLineToPoint: CGPointMake(125.14, 67.51)];
            [bezier8Path addCurveToPoint: CGPointMake(122.2, 70.44) controlPoint1: CGPointMake(125.05, 69.07) controlPoint2: CGPointMake(123.76, 70.44)];
            [bezier8Path closePath];
            [color0 setStroke];
            bezier8Path.lineWidth = 1.7;
            [bezier8Path stroke];
            
            
            //// Bezier 10 Drawing
            UIBezierPath* bezier10Path = UIBezierPath.bezierPath;
            [bezier10Path moveToPoint: CGPointMake(83.51, 86.21)];
            [bezier10Path addLineToPoint: CGPointMake(101.66, 86.21)];
            [color0 setStroke];
            bezier10Path.lineWidth = 1.7;
            [bezier10Path stroke];
            
            
            //// Bezier 12 Drawing
            UIBezierPath* bezier12Path = UIBezierPath.bezierPath;
            [bezier12Path moveToPoint: CGPointMake(92.63, 95.56)];
            [bezier12Path addLineToPoint: CGPointMake(92.63, 77.59)];
            [color0 setStroke];
            bezier12Path.lineWidth = 1.7;
            [bezier12Path stroke];
        }

    }
    else
    {
        //// Color Declarations
        UIColor* color0 = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
        
        //// Artboard_2
        {
            //// Bezier 2 Drawing
            UIBezierPath* bezier2Path = UIBezierPath.bezierPath;
            [bezier2Path moveToPoint: CGPointMake(32.45, 4.24)];
            [bezier2Path addLineToPoint: CGPointMake(48.89, 4.24)];
            [bezier2Path addCurveToPoint: CGPointMake(51, 6.32) controlPoint1: CGPointMake(50.01, 4.24) controlPoint2: CGPointMake(51, 5.15)];
            [bezier2Path addLineToPoint: CGPointMake(51, 37.52)];
            [bezier2Path addCurveToPoint: CGPointMake(48.89, 39.6) controlPoint1: CGPointMake(51, 38.62) controlPoint2: CGPointMake(50.08, 39.6)];
            [bezier2Path addLineToPoint: CGPointMake(3.11, 39.6)];
            [bezier2Path addCurveToPoint: CGPointMake(1, 37.52) controlPoint1: CGPointMake(1.99, 39.6) controlPoint2: CGPointMake(1, 38.69)];
            [bezier2Path addLineToPoint: CGPointMake(1, 6.32)];
            [bezier2Path addCurveToPoint: CGPointMake(3.11, 4.24) controlPoint1: CGPointMake(1, 5.21) controlPoint2: CGPointMake(1.92, 4.24)];
            [bezier2Path addLineToPoint: CGPointMake(19.55, 4.24)];
            [color0 setStroke];
            bezier2Path.lineWidth = 1.7;
            [bezier2Path stroke];
            
            
            //// Bezier 4 Drawing
            UIBezierPath* bezier4Path = UIBezierPath.bezierPath;
            [bezier4Path moveToPoint: CGPointMake(39.82, 21.59)];
            [bezier4Path addCurveToPoint: CGPointMake(25.74, 35.51) controlPoint1: CGPointMake(39.95, 29.33) controlPoint2: CGPointMake(33.57, 35.7)];
            [bezier4Path addCurveToPoint: CGPointMake(12.18, 22.12) controlPoint1: CGPointMake(18.37, 35.37) controlPoint2: CGPointMake(12.32, 29.4)];
            [bezier4Path addCurveToPoint: CGPointMake(26.26, 8.2) controlPoint1: CGPointMake(11.99, 14.38) controlPoint2: CGPointMake(18.43, 8.01)];
            [bezier4Path addCurveToPoint: CGPointMake(39.82, 21.59) controlPoint1: CGPointMake(33.63, 8.33) controlPoint2: CGPointMake(39.68, 14.31)];
            [bezier4Path closePath];
            [color0 setStroke];
            bezier4Path.lineWidth = 1.7;
            [bezier4Path stroke];
            
            
            //// Bezier 6 Drawing
            UIBezierPath* bezier6Path = UIBezierPath.bezierPath;
            [bezier6Path moveToPoint: CGPointMake(32.45, 4.76)];
            [bezier6Path addLineToPoint: CGPointMake(32.45, 2.68)];
            [bezier6Path addCurveToPoint: CGPointMake(30.34, 0.6) controlPoint1: CGPointMake(32.45, 1.57) controlPoint2: CGPointMake(31.53, 0.6)];
            [bezier6Path addLineToPoint: CGPointMake(21.59, 0.6)];
            [bezier6Path addCurveToPoint: CGPointMake(19.49, 2.68) controlPoint1: CGPointMake(20.47, 0.6) controlPoint2: CGPointMake(19.49, 1.51)];
            [bezier6Path addLineToPoint: CGPointMake(19.49, 4.76)];
            [color0 setStroke];
            bezier6Path.lineWidth = 1.7;
            [bezier6Path stroke];
            
            
            //// Bezier 8 Drawing
            UIBezierPath* bezier8Path = UIBezierPath.bezierPath;
            [bezier8Path moveToPoint: CGPointMake(46.86, 10.41)];
            [bezier8Path addLineToPoint: CGPointMake(42.97, 10.41)];
            [bezier8Path addCurveToPoint: CGPointMake(40.87, 8.33) controlPoint1: CGPointMake(41.86, 10.41) controlPoint2: CGPointMake(40.87, 9.5)];
            [bezier8Path addLineToPoint: CGPointMake(40.87, 8.33)];
            [bezier8Path addCurveToPoint: CGPointMake(42.97, 6.25) controlPoint1: CGPointMake(40.87, 7.23) controlPoint2: CGPointMake(41.79, 6.25)];
            [bezier8Path addLineToPoint: CGPointMake(46.86, 6.25)];
            [bezier8Path addCurveToPoint: CGPointMake(48.96, 8.33) controlPoint1: CGPointMake(47.97, 6.25) controlPoint2: CGPointMake(48.96, 7.16)];
            [bezier8Path addLineToPoint: CGPointMake(48.96, 8.33)];
            [bezier8Path addCurveToPoint: CGPointMake(46.86, 10.41) controlPoint1: CGPointMake(48.89, 9.44) controlPoint2: CGPointMake(47.97, 10.41)];
            [bezier8Path closePath];
            [color0 setStroke];
            bezier8Path.lineWidth = 1.7;
            [bezier8Path stroke];
            
            
            //// Bezier 10 Drawing
            UIBezierPath* bezier10Path = UIBezierPath.bezierPath;
            [bezier10Path moveToPoint: CGPointMake(19.22, 21.59)];
            [bezier10Path addLineToPoint: CGPointMake(32.18, 21.59)];
            [color0 setStroke];
            bezier10Path.lineWidth = 1.7;
            [bezier10Path stroke];
            
            
            //// Bezier 12 Drawing
            UIBezierPath* bezier12Path = UIBezierPath.bezierPath;
            [bezier12Path moveToPoint: CGPointMake(25.74, 28.22)];
            [bezier12Path addLineToPoint: CGPointMake(25.74, 15.48)];
            [color0 setStroke];
            bezier12Path.lineWidth = 1.7;
            [bezier12Path stroke];
        }

    }
}


@end
