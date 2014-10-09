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
            [bezier2Path moveToPoint: CGPointMake(104.38, 53.6)];
            [bezier2Path addLineToPoint: CGPointMake(135.96, 53.6)];
            [bezier2Path addCurveToPoint: CGPointMake(140, 57.6) controlPoint1: CGPointMake(138.11, 53.6) controlPoint2: CGPointMake(140, 55.35)];
            [bezier2Path addLineToPoint: CGPointMake(140, 117.6)];
            [bezier2Path addCurveToPoint: CGPointMake(135.96, 121.6) controlPoint1: CGPointMake(140, 119.72) controlPoint2: CGPointMake(138.23, 121.6)];
            [bezier2Path addLineToPoint: CGPointMake(48.04, 121.6)];
            [bezier2Path addCurveToPoint: CGPointMake(44, 117.6) controlPoint1: CGPointMake(45.89, 121.6) controlPoint2: CGPointMake(44, 119.85)];
            [bezier2Path addLineToPoint: CGPointMake(44, 57.6)];
            [bezier2Path addCurveToPoint: CGPointMake(48.04, 53.6) controlPoint1: CGPointMake(44, 55.47) controlPoint2: CGPointMake(45.77, 53.6)];
            [bezier2Path addLineToPoint: CGPointMake(79.62, 53.6)];
            [color0 setStroke];
            bezier2Path.lineWidth = 1.7;
            [bezier2Path stroke];
            
            
            //// Bezier 4 Drawing
            UIBezierPath* bezier4Path = UIBezierPath.bezierPath;
            [bezier4Path moveToPoint: CGPointMake(118.53, 86.97)];
            [bezier4Path addCurveToPoint: CGPointMake(91.49, 113.72) controlPoint1: CGPointMake(118.78, 101.85) controlPoint2: CGPointMake(106.53, 114.1)];
            [bezier4Path addCurveToPoint: CGPointMake(65.47, 87.97) controlPoint1: CGPointMake(77.35, 113.47) controlPoint2: CGPointMake(65.73, 101.97)];
            [bezier4Path addCurveToPoint: CGPointMake(92.51, 61.22) controlPoint1: CGPointMake(65.09, 73.1) controlPoint2: CGPointMake(77.47, 60.85)];
            [bezier4Path addCurveToPoint: CGPointMake(118.53, 86.97) controlPoint1: CGPointMake(106.65, 61.47) controlPoint2: CGPointMake(118.27, 72.97)];
            [bezier4Path closePath];
            [color0 setStroke];
            bezier4Path.lineWidth = 1.7;
            [bezier4Path stroke];
            
            
            //// Bezier 6 Drawing
            UIBezierPath* bezier6Path = UIBezierPath.bezierPath;
            [bezier6Path moveToPoint: CGPointMake(104.38, 54.6)];
            [bezier6Path addLineToPoint: CGPointMake(104.38, 50.6)];
            [bezier6Path addCurveToPoint: CGPointMake(100.34, 46.6) controlPoint1: CGPointMake(104.38, 48.47) controlPoint2: CGPointMake(102.61, 46.6)];
            [bezier6Path addLineToPoint: CGPointMake(83.54, 46.6)];
            [bezier6Path addCurveToPoint: CGPointMake(79.49, 50.6) controlPoint1: CGPointMake(81.39, 46.6) controlPoint2: CGPointMake(79.49, 48.35)];
            [bezier6Path addLineToPoint: CGPointMake(79.49, 54.6)];
            [color0 setStroke];
            bezier6Path.lineWidth = 1.7;
            [bezier6Path stroke];
            
            
            //// Bezier 8 Drawing
            UIBezierPath* bezier8Path = UIBezierPath.bezierPath;
            [bezier8Path moveToPoint: CGPointMake(132.04, 65.47)];
            [bezier8Path addLineToPoint: CGPointMake(124.59, 65.47)];
            [bezier8Path addCurveToPoint: CGPointMake(120.55, 61.47) controlPoint1: CGPointMake(122.44, 65.47) controlPoint2: CGPointMake(120.55, 63.72)];
            [bezier8Path addLineToPoint: CGPointMake(120.55, 61.47)];
            [bezier8Path addCurveToPoint: CGPointMake(124.59, 57.47) controlPoint1: CGPointMake(120.55, 59.35) controlPoint2: CGPointMake(122.32, 57.47)];
            [bezier8Path addLineToPoint: CGPointMake(132.04, 57.47)];
            [bezier8Path addCurveToPoint: CGPointMake(136.08, 61.47) controlPoint1: CGPointMake(134.19, 57.47) controlPoint2: CGPointMake(136.08, 59.22)];
            [bezier8Path addLineToPoint: CGPointMake(136.08, 61.47)];
            [bezier8Path addCurveToPoint: CGPointMake(132.04, 65.47) controlPoint1: CGPointMake(135.96, 63.6) controlPoint2: CGPointMake(134.19, 65.47)];
            [bezier8Path closePath];
            [color0 setStroke];
            bezier8Path.lineWidth = 1.7;
            [bezier8Path stroke];
            
            
            //// Bezier 10 Drawing
            UIBezierPath* bezier10Path = UIBezierPath.bezierPath;
            [bezier10Path moveToPoint: CGPointMake(78.99, 86.97)];
            [bezier10Path addLineToPoint: CGPointMake(103.87, 86.97)];
            [color0 setStroke];
            bezier10Path.lineWidth = 1.7;
            [bezier10Path stroke];
            
            
            //// Bezier 12 Drawing
            UIBezierPath* bezier12Path = UIBezierPath.bezierPath;
            [bezier12Path moveToPoint: CGPointMake(91.49, 99.72)];
            [bezier12Path addLineToPoint: CGPointMake(91.49, 75.22)];
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
