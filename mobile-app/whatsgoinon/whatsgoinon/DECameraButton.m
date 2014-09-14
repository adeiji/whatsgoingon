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
            [bezier2Path moveToPoint: CGPointMake(100.8, 43.2)];
            [bezier2Path addLineToPoint: CGPointMake(125.8, 43.2)];
            [bezier2Path addCurveToPoint: CGPointMake(129, 46.4) controlPoint1: CGPointMake(127.5, 43.2) controlPoint2: CGPointMake(129, 44.6)];
            [bezier2Path addLineToPoint: CGPointMake(129, 94.4)];
            [bezier2Path addCurveToPoint: CGPointMake(125.8, 97.6) controlPoint1: CGPointMake(129, 96.1) controlPoint2: CGPointMake(127.6, 97.6)];
            [bezier2Path addLineToPoint: CGPointMake(56.2, 97.6)];
            [bezier2Path addCurveToPoint: CGPointMake(53, 94.4) controlPoint1: CGPointMake(54.5, 97.6) controlPoint2: CGPointMake(53, 96.2)];
            [bezier2Path addLineToPoint: CGPointMake(53, 46.4)];
            [bezier2Path addCurveToPoint: CGPointMake(56.2, 43.2) controlPoint1: CGPointMake(53, 44.7) controlPoint2: CGPointMake(54.4, 43.2)];
            [bezier2Path addLineToPoint: CGPointMake(81.2, 43.2)];
            [color0 setStroke];
            bezier2Path.lineWidth = 1.7;
            [bezier2Path stroke];
            
            
            //// Bezier 4 Drawing
            UIBezierPath* bezier4Path = UIBezierPath.bezierPath;
            [bezier4Path moveToPoint: CGPointMake(112, 69.9)];
            [bezier4Path addCurveToPoint: CGPointMake(90.6, 91.3) controlPoint1: CGPointMake(112.2, 81.8) controlPoint2: CGPointMake(102.5, 91.6)];
            [bezier4Path addCurveToPoint: CGPointMake(70, 70.7) controlPoint1: CGPointMake(79.4, 91.1) controlPoint2: CGPointMake(70.2, 81.9)];
            [bezier4Path addCurveToPoint: CGPointMake(91.4, 49.3) controlPoint1: CGPointMake(69.7, 58.8) controlPoint2: CGPointMake(79.5, 49)];
            [bezier4Path addCurveToPoint: CGPointMake(112, 69.9) controlPoint1: CGPointMake(102.6, 49.5) controlPoint2: CGPointMake(111.8, 58.7)];
            [bezier4Path closePath];
            [color0 setStroke];
            bezier4Path.lineWidth = 1.7;
            [bezier4Path stroke];
            
            
            //// Bezier 6 Drawing
            UIBezierPath* bezier6Path = UIBezierPath.bezierPath;
            [bezier6Path moveToPoint: CGPointMake(100.8, 44)];
            [bezier6Path addLineToPoint: CGPointMake(100.8, 40.8)];
            [bezier6Path addCurveToPoint: CGPointMake(97.6, 37.6) controlPoint1: CGPointMake(100.8, 39.1) controlPoint2: CGPointMake(99.4, 37.6)];
            [bezier6Path addLineToPoint: CGPointMake(84.3, 37.6)];
            [bezier6Path addCurveToPoint: CGPointMake(81.1, 40.8) controlPoint1: CGPointMake(82.6, 37.6) controlPoint2: CGPointMake(81.1, 39)];
            [bezier6Path addLineToPoint: CGPointMake(81.1, 44)];
            [color0 setStroke];
            bezier6Path.lineWidth = 1.7;
            [bezier6Path stroke];
            
            
            //// Bezier 8 Drawing
            UIBezierPath* bezier8Path = UIBezierPath.bezierPath;
            [bezier8Path moveToPoint: CGPointMake(122.7, 52.7)];
            [bezier8Path addLineToPoint: CGPointMake(116.8, 52.7)];
            [bezier8Path addCurveToPoint: CGPointMake(113.6, 49.5) controlPoint1: CGPointMake(115.1, 52.7) controlPoint2: CGPointMake(113.6, 51.3)];
            [bezier8Path addLineToPoint: CGPointMake(113.6, 49.5)];
            [bezier8Path addCurveToPoint: CGPointMake(116.8, 46.3) controlPoint1: CGPointMake(113.6, 47.8) controlPoint2: CGPointMake(115, 46.3)];
            [bezier8Path addLineToPoint: CGPointMake(122.7, 46.3)];
            [bezier8Path addCurveToPoint: CGPointMake(125.9, 49.5) controlPoint1: CGPointMake(124.4, 46.3) controlPoint2: CGPointMake(125.9, 47.7)];
            [bezier8Path addLineToPoint: CGPointMake(125.9, 49.5)];
            [bezier8Path addCurveToPoint: CGPointMake(122.7, 52.7) controlPoint1: CGPointMake(125.8, 51.2) controlPoint2: CGPointMake(124.4, 52.7)];
            [bezier8Path closePath];
            [color0 setStroke];
            bezier8Path.lineWidth = 1.7;
            [bezier8Path stroke];
            
            
            //// Bezier 10 Drawing
            UIBezierPath* bezier10Path = UIBezierPath.bezierPath;
            [bezier10Path moveToPoint: CGPointMake(80.7, 69.9)];
            [bezier10Path addLineToPoint: CGPointMake(100.4, 69.9)];
            [color0 setStroke];
            bezier10Path.lineWidth = 1.7;
            [bezier10Path stroke];
            
            
            //// Bezier 12 Drawing
            UIBezierPath* bezier12Path = UIBezierPath.bezierPath;
            [bezier12Path moveToPoint: CGPointMake(90.6, 80.1)];
            [bezier12Path addLineToPoint: CGPointMake(90.6, 60.5)];
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
