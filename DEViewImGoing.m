//
//  DEViewImGoing.m
//  whatsgoinon
//
//  Created by adeiji on 9/10/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import "DEViewImGoing.h"

@implementation DEViewImGoing

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
    UIColor* color1 = [UIColor colorWithRed: 0.075 green: 0.606 blue: 0.915 alpha: 1];
    UIColor* color0 = [UIColor colorWithRed: 0.427 green: 0.427 blue: 0.427 alpha: 1];
    
    //// Layer_2
    {
        //// Bezier 2 Drawing
        UIBezierPath* bezier2Path = UIBezierPath.bezierPath;
        [bezier2Path moveToPoint: CGPointMake(9.44, 21.5)];
        [bezier2Path addLineToPoint: CGPointMake(9.08, 21.5)];
        bezier2Path.miterLimit = 4;
        
        [color0 setFill];
        [bezier2Path fill];
        
        
        //// Bezier 4 Drawing
        UIBezierPath* bezier4Path = UIBezierPath.bezierPath;
        [bezier4Path moveToPoint: CGPointMake(13.22, 17.02)];
        [bezier4Path addLineToPoint: CGPointMake(12.92, 17.02)];
        bezier4Path.miterLimit = 4;
        
        [color0 setFill];
        [bezier4Path fill];
        
        
        //// Bezier 6 Drawing
        
        
        //// Bezier 8 Drawing
        UIBezierPath* bezier8Path = UIBezierPath.bezierPath;
        [bezier8Path moveToPoint: CGPointMake(26.82, 20.96)];
        [bezier8Path addLineToPoint: CGPointMake(26.52, 20.96)];
        bezier8Path.miterLimit = 4;
        
        [color0 setFill];
        [bezier8Path fill];
        
        
        //// Oval 2 Drawing
        UIBezierPath* oval2Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(10, 2.1, 4, 4)];
        [color1 setFill];
        [oval2Path fill];
        
        
        //// Bezier 10 Drawing
        UIBezierPath* bezier10Path = UIBezierPath.bezierPath;
        [bezier10Path moveToPoint: CGPointMake(15.86, 10.18)];
        [bezier10Path addLineToPoint: CGPointMake(15.86, 10.45)];
        [bezier10Path addLineToPoint: CGPointMake(14.44, 10.45)];
        [bezier10Path addLineToPoint: CGPointMake(14.44, 9.31)];
        [bezier10Path addLineToPoint: CGPointMake(14.13, 9.31)];
        [bezier10Path addLineToPoint: CGPointMake(14.13, 10.45)];
        [bezier10Path addLineToPoint: CGPointMake(13.57, 10.45)];
        [bezier10Path addCurveToPoint: CGPointMake(12.98, 11) controlPoint1: CGPointMake(13.24, 10.45) controlPoint2: CGPointMake(12.98, 10.7)];
        [bezier10Path addLineToPoint: CGPointMake(12.98, 16.13)];
        [bezier10Path addLineToPoint: CGPointMake(11.12, 16.13)];
        [bezier10Path addLineToPoint: CGPointMake(11.12, 11.08)];
        [bezier10Path addCurveToPoint: CGPointMake(10.43, 10.43) controlPoint1: CGPointMake(11.12, 10.72) controlPoint2: CGPointMake(10.81, 10.43)];
        [bezier10Path addLineToPoint: CGPointMake(9.88, 10.43)];
        [bezier10Path addLineToPoint: CGPointMake(9.88, 9.31)];
        [bezier10Path addLineToPoint: CGPointMake(9.58, 9.31)];
        [bezier10Path addLineToPoint: CGPointMake(9.58, 10.43)];
        [bezier10Path addLineToPoint: CGPointMake(8.16, 10.43)];
        [bezier10Path addLineToPoint: CGPointMake(8.16, 10.21)];
        [bezier10Path addCurveToPoint: CGPointMake(9.53, 8.24) controlPoint1: CGPointMake(8.96, 9.88) controlPoint2: CGPointMake(9.53, 9.12)];
        [bezier10Path addCurveToPoint: CGPointMake(9.27, 7.24) controlPoint1: CGPointMake(9.53, 7.89) controlPoint2: CGPointMake(9.44, 7.54)];
        [bezier10Path addLineToPoint: CGPointMake(14.76, 7.24)];
        [bezier10Path addCurveToPoint: CGPointMake(14.51, 8.22) controlPoint1: CGPointMake(14.6, 7.54) controlPoint2: CGPointMake(14.51, 7.87)];
        [bezier10Path addCurveToPoint: CGPointMake(15.86, 10.18) controlPoint1: CGPointMake(14.51, 9.09) controlPoint2: CGPointMake(15.06, 9.85)];
        [bezier10Path closePath];
        bezier10Path.miterLimit = 4;
        
        [color1 setFill];
        [bezier10Path fill];
        
        
        //// Bezier 12 Drawing
        UIBezierPath* bezier12Path = UIBezierPath.bezierPath;
        [bezier12Path moveToPoint: CGPointMake(8.02, 20.56)];
        [bezier12Path addLineToPoint: CGPointMake(7.72, 20.56)];
        bezier12Path.miterLimit = 4;
        
        [color0 setFill];
        [bezier12Path fill];
        
        
        //// Bezier 14 Drawing
        UIBezierPath* bezier14Path = UIBezierPath.bezierPath;
        [bezier14Path moveToPoint: CGPointMake(20.53, 10.28)];
        [bezier14Path addLineToPoint: CGPointMake(20.23, 10.28)];
        bezier14Path.miterLimit = 4;
        
        [color0 setFill];
        [bezier14Path fill];
        
        
        //// Bezier 16 Drawing
        
        
        //// Oval 4 Drawing
        UIBezierPath* oval4Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(4.8, 4.8, 4, 5)];
        [color1 setFill];
        [oval4Path fill];
        
        
        //// Bezier 18 Drawing
        UIBezierPath* bezier18Path = UIBezierPath.bezierPath;
        [bezier18Path moveToPoint: CGPointMake(10.31, 11.69)];
        [bezier18Path addLineToPoint: CGPointMake(10.31, 19.48)];
        [bezier18Path addCurveToPoint: CGPointMake(9.73, 20.03) controlPoint1: CGPointMake(10.31, 19.78) controlPoint2: CGPointMake(10.05, 20.03)];
        [bezier18Path addLineToPoint: CGPointMake(9.46, 20.03)];
        [bezier18Path addCurveToPoint: CGPointMake(8.89, 19.48) controlPoint1: CGPointMake(9.15, 20.03) controlPoint2: CGPointMake(8.89, 19.78)];
        [bezier18Path addLineToPoint: CGPointMake(8.89, 13.21)];
        [bezier18Path addLineToPoint: CGPointMake(8.58, 13.21)];
        [bezier18Path addLineToPoint: CGPointMake(8.58, 19.71)];
        [bezier18Path addCurveToPoint: CGPointMake(8.24, 20.03) controlPoint1: CGPointMake(8.58, 19.89) controlPoint2: CGPointMake(8.43, 20.03)];
        [bezier18Path addLineToPoint: CGPointMake(4.66, 20.03)];
        [bezier18Path addCurveToPoint: CGPointMake(4.32, 19.71) controlPoint1: CGPointMake(4.48, 20.03) controlPoint2: CGPointMake(4.32, 19.89)];
        [bezier18Path addLineToPoint: CGPointMake(4.32, 13.21)];
        [bezier18Path addLineToPoint: CGPointMake(4.02, 13.21)];
        [bezier18Path addLineToPoint: CGPointMake(4.02, 19.48)];
        [bezier18Path addCurveToPoint: CGPointMake(3.44, 20.03) controlPoint1: CGPointMake(4.02, 19.78) controlPoint2: CGPointMake(3.76, 20.03)];
        [bezier18Path addLineToPoint: CGPointMake(3.18, 20.03)];
        [bezier18Path addCurveToPoint: CGPointMake(2.6, 19.48) controlPoint1: CGPointMake(2.86, 20.03) controlPoint2: CGPointMake(2.6, 19.78)];
        [bezier18Path addLineToPoint: CGPointMake(2.6, 11.69)];
        [bezier18Path addCurveToPoint: CGPointMake(3.19, 11.14) controlPoint1: CGPointMake(2.6, 11.39) controlPoint2: CGPointMake(2.86, 11.14)];
        [bezier18Path addLineToPoint: CGPointMake(9.72, 11.14)];
        [bezier18Path addCurveToPoint: CGPointMake(10.31, 11.69) controlPoint1: CGPointMake(10.04, 11.14) controlPoint2: CGPointMake(10.31, 11.39)];
        [bezier18Path closePath];
        bezier18Path.miterLimit = 4;
        
        [color1 setFill];
        [bezier18Path fill];
        
        
        //// Oval 6 Drawing
        UIBezierPath* oval6Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(15.6, 5.8, 5, 4)];
        [color1 setFill];
        [oval6Path fill];
        
        
        //// Bezier 20 Drawing
        UIBezierPath* bezier20Path = UIBezierPath.bezierPath;
        [bezier20Path moveToPoint: CGPointMake(21.47, 11.69)];
        [bezier20Path addLineToPoint: CGPointMake(21.47, 19.48)];
        [bezier20Path addCurveToPoint: CGPointMake(20.89, 20.03) controlPoint1: CGPointMake(21.47, 19.78) controlPoint2: CGPointMake(21.21, 20.03)];
        [bezier20Path addLineToPoint: CGPointMake(20.63, 20.03)];
        [bezier20Path addCurveToPoint: CGPointMake(20.05, 19.48) controlPoint1: CGPointMake(20.31, 20.03) controlPoint2: CGPointMake(20.05, 19.78)];
        [bezier20Path addLineToPoint: CGPointMake(20.05, 13.21)];
        [bezier20Path addLineToPoint: CGPointMake(19.74, 13.21)];
        [bezier20Path addLineToPoint: CGPointMake(19.74, 19.71)];
        [bezier20Path addCurveToPoint: CGPointMake(19.41, 20.03) controlPoint1: CGPointMake(19.74, 19.89) controlPoint2: CGPointMake(19.59, 20.03)];
        [bezier20Path addLineToPoint: CGPointMake(15.82, 20.03)];
        [bezier20Path addCurveToPoint: CGPointMake(15.49, 19.71) controlPoint1: CGPointMake(15.64, 20.03) controlPoint2: CGPointMake(15.49, 19.89)];
        [bezier20Path addLineToPoint: CGPointMake(15.49, 13.21)];
        [bezier20Path addLineToPoint: CGPointMake(15.18, 13.21)];
        [bezier20Path addLineToPoint: CGPointMake(15.18, 19.48)];
        [bezier20Path addCurveToPoint: CGPointMake(14.6, 20.03) controlPoint1: CGPointMake(15.18, 19.78) controlPoint2: CGPointMake(14.92, 20.03)];
        [bezier20Path addLineToPoint: CGPointMake(14.34, 20.03)];
        [bezier20Path addCurveToPoint: CGPointMake(13.76, 19.48) controlPoint1: CGPointMake(14.02, 20.03) controlPoint2: CGPointMake(13.76, 19.78)];
        [bezier20Path addLineToPoint: CGPointMake(13.76, 11.69)];
        [bezier20Path addCurveToPoint: CGPointMake(14.35, 11.14) controlPoint1: CGPointMake(13.76, 11.39) controlPoint2: CGPointMake(14.03, 11.14)];
        [bezier20Path addLineToPoint: CGPointMake(20.88, 11.14)];
        [bezier20Path addCurveToPoint: CGPointMake(21.47, 11.69) controlPoint1: CGPointMake(21.2, 11.14) controlPoint2: CGPointMake(21.47, 11.39)];
        [bezier20Path closePath];
        bezier20Path.miterLimit = 4;
        
        [color1 setFill];
        [bezier20Path fill];
    }

}
@end
