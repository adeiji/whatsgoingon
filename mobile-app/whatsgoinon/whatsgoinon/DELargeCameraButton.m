//
//  DELargeCameraButton.m
//  whatsgoinon
//
//  Created by adeiji on 9/11/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import "DELargeCameraButton.h"

@implementation DELargeCameraButton

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
    // Drawing code
    //// Color Declarations
    UIColor* color0 = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
    
    //// Artboard_2
    {
        //// Bezier 2 Drawing
        UIBezierPath* bezier2Path = UIBezierPath.bezierPath;
        [bezier2Path moveToPoint: CGPointMake(51.3, 29.87)];
        [bezier2Path addLineToPoint: CGPointMake(66.11, 29.87)];
        [bezier2Path addCurveToPoint: CGPointMake(68, 31.73) controlPoint1: CGPointMake(67.11, 29.87) controlPoint2: CGPointMake(68, 30.68)];
        [bezier2Path addLineToPoint: CGPointMake(68, 59.73)];
        [bezier2Path addCurveToPoint: CGPointMake(66.11, 61.6) controlPoint1: CGPointMake(68, 60.72) controlPoint2: CGPointMake(67.17, 61.6)];
        [bezier2Path addLineToPoint: CGPointMake(24.89, 61.6)];
        [bezier2Path addCurveToPoint: CGPointMake(23, 59.73) controlPoint1: CGPointMake(23.89, 61.6) controlPoint2: CGPointMake(23, 60.78)];
        [bezier2Path addLineToPoint: CGPointMake(23, 31.73)];
        [bezier2Path addCurveToPoint: CGPointMake(24.89, 29.87) controlPoint1: CGPointMake(23, 30.74) controlPoint2: CGPointMake(23.83, 29.87)];
        [bezier2Path addLineToPoint: CGPointMake(39.7, 29.87)];
        [color0 setStroke];
        bezier2Path.lineWidth = 1.7;
        [bezier2Path stroke];
        
        
        //// Bezier 4 Drawing
        UIBezierPath* bezier4Path = UIBezierPath.bezierPath;
        [bezier4Path moveToPoint: CGPointMake(57.93, 45.44)];
        [bezier4Path addCurveToPoint: CGPointMake(45.26, 57.92) controlPoint1: CGPointMake(58.05, 52.38) controlPoint2: CGPointMake(52.31, 58.1)];
        [bezier4Path addCurveToPoint: CGPointMake(33.07, 45.91) controlPoint1: CGPointMake(38.63, 57.81) controlPoint2: CGPointMake(33.18, 52.44)];
        [bezier4Path addCurveToPoint: CGPointMake(45.74, 33.42) controlPoint1: CGPointMake(32.89, 38.97) controlPoint2: CGPointMake(38.69, 33.25)];
        [bezier4Path addCurveToPoint: CGPointMake(57.93, 45.44) controlPoint1: CGPointMake(52.37, 33.54) controlPoint2: CGPointMake(57.82, 38.91)];
        [bezier4Path closePath];
        [color0 setStroke];
        bezier4Path.lineWidth = 1.7;
        [bezier4Path stroke];
        
        
        //// Bezier 6 Drawing
        UIBezierPath* bezier6Path = UIBezierPath.bezierPath;
        [bezier6Path moveToPoint: CGPointMake(51.3, 30.33)];
        [bezier6Path addLineToPoint: CGPointMake(51.3, 28.47)];
        [bezier6Path addCurveToPoint: CGPointMake(49.41, 26.6) controlPoint1: CGPointMake(51.3, 27.47) controlPoint2: CGPointMake(50.47, 26.6)];
        [bezier6Path addLineToPoint: CGPointMake(41.53, 26.6)];
        [bezier6Path addCurveToPoint: CGPointMake(39.64, 28.47) controlPoint1: CGPointMake(40.53, 26.6) controlPoint2: CGPointMake(39.64, 27.42)];
        [bezier6Path addLineToPoint: CGPointMake(39.64, 30.33)];
        [color0 setStroke];
        bezier6Path.lineWidth = 1.7;
        [bezier6Path stroke];
        
        
        //// Bezier 8 Drawing
        UIBezierPath* bezier8Path = UIBezierPath.bezierPath;
        [bezier8Path moveToPoint: CGPointMake(64.27, 35.41)];
        [bezier8Path addLineToPoint: CGPointMake(60.78, 35.41)];
        [bezier8Path addCurveToPoint: CGPointMake(58.88, 33.54) controlPoint1: CGPointMake(59.77, 35.41) controlPoint2: CGPointMake(58.88, 34.59)];
        [bezier8Path addLineToPoint: CGPointMake(58.88, 33.54)];
        [bezier8Path addCurveToPoint: CGPointMake(60.78, 31.67) controlPoint1: CGPointMake(58.88, 32.55) controlPoint2: CGPointMake(59.71, 31.67)];
        [bezier8Path addLineToPoint: CGPointMake(64.27, 31.67)];
        [bezier8Path addCurveToPoint: CGPointMake(66.16, 33.54) controlPoint1: CGPointMake(65.28, 31.67) controlPoint2: CGPointMake(66.16, 32.49)];
        [bezier8Path addLineToPoint: CGPointMake(66.16, 33.54)];
        [bezier8Path addCurveToPoint: CGPointMake(64.27, 35.41) controlPoint1: CGPointMake(66.11, 34.53) controlPoint2: CGPointMake(65.28, 35.41)];
        [bezier8Path closePath];
        [color0 setStroke];
        bezier8Path.lineWidth = 1.7;
        [bezier8Path stroke];
        
        
        //// Bezier 10 Drawing
        UIBezierPath* bezier10Path = UIBezierPath.bezierPath;
        [bezier10Path moveToPoint: CGPointMake(39.4, 45.44)];
        [bezier10Path addLineToPoint: CGPointMake(51.07, 45.44)];
        [color0 setStroke];
        bezier10Path.lineWidth = 1.7;
        [bezier10Path stroke];
        
        
        //// Bezier 12 Drawing
        UIBezierPath* bezier12Path = UIBezierPath.bezierPath;
        [bezier12Path moveToPoint: CGPointMake(45.26, 51.39)];
        [bezier12Path addLineToPoint: CGPointMake(45.26, 39.96)];
        [color0 setStroke];
        bezier12Path.lineWidth = 1.7;
        [bezier12Path stroke];
    }

}


@end
