//
//  DEViewDistance.m
//  whatsgoinon
//
//  Created by adeiji on 9/10/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import "DEViewDistance.h"

@implementation DEViewDistance

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
    UIColor* color3 = [UIColor colorWithRed: 0.522 green: 0.534 blue: 0.538 alpha: 1];
    
    //// Group
    {
        //// Bezier 3 Drawing
        UIBezierPath* bezier3Path = UIBezierPath.bezierPath;
        [bezier3Path moveToPoint: CGPointMake(13.52, 9.15)];
        [bezier3Path addCurveToPoint: CGPointMake(13.5, 9.36) controlPoint1: CGPointMake(13.51, 9.22) controlPoint2: CGPointMake(13.5, 9.29)];
        [bezier3Path addCurveToPoint: CGPointMake(13.52, 9.15) controlPoint1: CGPointMake(13.5, 9.28) controlPoint2: CGPointMake(13.51, 9.21)];
        [bezier3Path closePath];
        bezier3Path.miterLimit = 4;
        
        [color3 setFill];
        [bezier3Path fill];
        
        
        //// Bezier 7 Drawing
        UIBezierPath* bezier7Path = UIBezierPath.bezierPath;
        [bezier7Path moveToPoint: CGPointMake(14.32, 2.2)];
        [bezier7Path addLineToPoint: CGPointMake(8.44, 2.2)];
        [bezier7Path addCurveToPoint: CGPointMake(6.89, 2.66) controlPoint1: CGPointMake(7.86, 2.2) controlPoint2: CGPointMake(7.3, 2.37)];
        [bezier7Path addLineToPoint: CGPointMake(3.01, 5.5)];
        [bezier7Path addLineToPoint: CGPointMake(19.75, 5.5)];
        [bezier7Path addLineToPoint: CGPointMake(15.87, 2.66)];
        [bezier7Path addCurveToPoint: CGPointMake(14.32, 2.2) controlPoint1: CGPointMake(15.47, 2.36) controlPoint2: CGPointMake(14.91, 2.2)];
        [bezier7Path closePath];
        bezier7Path.miterLimit = 4;
        
        [color3 setFill];
        [bezier7Path fill];
        
        
        //// Bezier 11 Drawing
        UIBezierPath* bezier11Path = UIBezierPath.bezierPath;
        [bezier11Path moveToPoint: CGPointMake(21, 6.33)];
        [bezier11Path addLineToPoint: CGPointMake(21, 8.27)];
        [bezier11Path addCurveToPoint: CGPointMake(19.91, 9.36) controlPoint1: CGPointMake(21, 8.88) controlPoint2: CGPointMake(20.51, 9.36)];
        [bezier11Path addLineToPoint: CGPointMake(18.02, 9.36)];
        [bezier11Path addCurveToPoint: CGPointMake(18.01, 9.21) controlPoint1: CGPointMake(18.02, 9.31) controlPoint2: CGPointMake(18.02, 9.26)];
        [bezier11Path addCurveToPoint: CGPointMake(18, 9.14) controlPoint1: CGPointMake(18.01, 9.19) controlPoint2: CGPointMake(18.01, 9.16)];
        [bezier11Path addCurveToPoint: CGPointMake(18, 9.12) controlPoint1: CGPointMake(18, 9.13) controlPoint2: CGPointMake(18, 9.12)];
        [bezier11Path addCurveToPoint: CGPointMake(17.99, 9.02) controlPoint1: CGPointMake(18, 9.09) controlPoint2: CGPointMake(17.99, 9.06)];
        [bezier11Path addCurveToPoint: CGPointMake(17.91, 8.71) controlPoint1: CGPointMake(17.97, 8.92) controlPoint2: CGPointMake(17.94, 8.81)];
        [bezier11Path addCurveToPoint: CGPointMake(17.88, 8.63) controlPoint1: CGPointMake(17.9, 8.69) controlPoint2: CGPointMake(17.89, 8.66)];
        [bezier11Path addCurveToPoint: CGPointMake(17.85, 8.56) controlPoint1: CGPointMake(17.87, 8.61) controlPoint2: CGPointMake(17.86, 8.59)];
        [bezier11Path addCurveToPoint: CGPointMake(17.82, 8.48) controlPoint1: CGPointMake(17.85, 8.54) controlPoint2: CGPointMake(17.84, 8.51)];
        [bezier11Path addCurveToPoint: CGPointMake(17.77, 8.4) controlPoint1: CGPointMake(17.8, 8.45) controlPoint2: CGPointMake(17.79, 8.42)];
        [bezier11Path addCurveToPoint: CGPointMake(17.74, 8.32) controlPoint1: CGPointMake(17.76, 8.37) controlPoint2: CGPointMake(17.75, 8.35)];
        [bezier11Path addCurveToPoint: CGPointMake(17.54, 8.03) controlPoint1: CGPointMake(17.68, 8.22) controlPoint2: CGPointMake(17.61, 8.12)];
        [bezier11Path addCurveToPoint: CGPointMake(17.48, 7.95) controlPoint1: CGPointMake(17.52, 8) controlPoint2: CGPointMake(17.5, 7.98)];
        [bezier11Path addCurveToPoint: CGPointMake(17.24, 7.71) controlPoint1: CGPointMake(17.41, 7.86) controlPoint2: CGPointMake(17.33, 7.78)];
        [bezier11Path addCurveToPoint: CGPointMake(17.16, 7.64) controlPoint1: CGPointMake(17.21, 7.69) controlPoint2: CGPointMake(17.18, 7.66)];
        [bezier11Path addCurveToPoint: CGPointMake(16.88, 7.45) controlPoint1: CGPointMake(17.07, 7.57) controlPoint2: CGPointMake(16.98, 7.51)];
        [bezier11Path addCurveToPoint: CGPointMake(16.68, 7.34) controlPoint1: CGPointMake(16.81, 7.4) controlPoint2: CGPointMake(16.75, 7.37)];
        [bezier11Path addCurveToPoint: CGPointMake(16.47, 7.25) controlPoint1: CGPointMake(16.61, 7.31) controlPoint2: CGPointMake(16.54, 7.28)];
        [bezier11Path addCurveToPoint: CGPointMake(16.29, 7.2) controlPoint1: CGPointMake(16.4, 7.24) controlPoint2: CGPointMake(16.35, 7.21)];
        [bezier11Path addCurveToPoint: CGPointMake(16.24, 7.19) controlPoint1: CGPointMake(16.28, 7.2) controlPoint2: CGPointMake(16.26, 7.19)];
        [bezier11Path addCurveToPoint: CGPointMake(16.03, 7.15) controlPoint1: CGPointMake(16.17, 7.17) controlPoint2: CGPointMake(16.11, 7.15)];
        [bezier11Path addCurveToPoint: CGPointMake(15.66, 7.11) controlPoint1: CGPointMake(15.91, 7.13) controlPoint2: CGPointMake(15.78, 7.11)];
        [bezier11Path addCurveToPoint: CGPointMake(15.26, 7.15) controlPoint1: CGPointMake(15.52, 7.11) controlPoint2: CGPointMake(15.39, 7.12)];
        [bezier11Path addCurveToPoint: CGPointMake(15.18, 7.16) controlPoint1: CGPointMake(15.24, 7.15) controlPoint2: CGPointMake(15.21, 7.15)];
        [bezier11Path addCurveToPoint: CGPointMake(15.05, 7.2) controlPoint1: CGPointMake(15.14, 7.17) controlPoint2: CGPointMake(15.09, 7.18)];
        [bezier11Path addCurveToPoint: CGPointMake(14.85, 7.25) controlPoint1: CGPointMake(14.98, 7.21) controlPoint2: CGPointMake(14.91, 7.24)];
        [bezier11Path addCurveToPoint: CGPointMake(14.74, 7.29) controlPoint1: CGPointMake(14.82, 7.27) controlPoint2: CGPointMake(14.78, 7.28)];
        [bezier11Path addCurveToPoint: CGPointMake(14.64, 7.34) controlPoint1: CGPointMake(14.71, 7.31) controlPoint2: CGPointMake(14.67, 7.32)];
        [bezier11Path addCurveToPoint: CGPointMake(14.34, 7.5) controlPoint1: CGPointMake(14.54, 7.39) controlPoint2: CGPointMake(14.44, 7.44)];
        [bezier11Path addCurveToPoint: CGPointMake(14.25, 7.57) controlPoint1: CGPointMake(14.31, 7.52) controlPoint2: CGPointMake(14.28, 7.54)];
        [bezier11Path addLineToPoint: CGPointMake(14.25, 7.57)];
        [bezier11Path addLineToPoint: CGPointMake(14.25, 7.57)];
        [bezier11Path addCurveToPoint: CGPointMake(14.16, 7.63) controlPoint1: CGPointMake(14.22, 7.59) controlPoint2: CGPointMake(14.19, 7.61)];
        [bezier11Path addCurveToPoint: CGPointMake(14.08, 7.7) controlPoint1: CGPointMake(14.13, 7.65) controlPoint2: CGPointMake(14.11, 7.68)];
        [bezier11Path addCurveToPoint: CGPointMake(13.86, 7.93) controlPoint1: CGPointMake(14, 7.78) controlPoint2: CGPointMake(13.92, 7.85)];
        [bezier11Path addCurveToPoint: CGPointMake(13.82, 7.97) controlPoint1: CGPointMake(13.85, 7.94) controlPoint2: CGPointMake(13.83, 7.95)];
        [bezier11Path addCurveToPoint: CGPointMake(13.79, 8.02) controlPoint1: CGPointMake(13.8, 7.98) controlPoint2: CGPointMake(13.79, 8)];
        [bezier11Path addCurveToPoint: CGPointMake(13.64, 8.23) controlPoint1: CGPointMake(13.73, 8.08) controlPoint2: CGPointMake(13.69, 8.15)];
        [bezier11Path addCurveToPoint: CGPointMake(13.61, 8.29) controlPoint1: CGPointMake(13.62, 8.25) controlPoint2: CGPointMake(13.62, 8.27)];
        [bezier11Path addCurveToPoint: CGPointMake(13.51, 8.48) controlPoint1: CGPointMake(13.57, 8.36) controlPoint2: CGPointMake(13.54, 8.41)];
        [bezier11Path addCurveToPoint: CGPointMake(13.47, 8.56) controlPoint1: CGPointMake(13.5, 8.5) controlPoint2: CGPointMake(13.48, 8.52)];
        [bezier11Path addCurveToPoint: CGPointMake(13.44, 8.62) controlPoint1: CGPointMake(13.46, 8.57) controlPoint2: CGPointMake(13.45, 8.6)];
        [bezier11Path addCurveToPoint: CGPointMake(13.42, 8.7) controlPoint1: CGPointMake(13.44, 8.65) controlPoint2: CGPointMake(13.43, 8.67)];
        [bezier11Path addCurveToPoint: CGPointMake(13.42, 8.72) controlPoint1: CGPointMake(13.42, 8.71) controlPoint2: CGPointMake(13.42, 8.71)];
        [bezier11Path addCurveToPoint: CGPointMake(13.39, 8.81) controlPoint1: CGPointMake(13.41, 8.75) controlPoint2: CGPointMake(13.4, 8.78)];
        [bezier11Path addCurveToPoint: CGPointMake(13.36, 8.91) controlPoint1: CGPointMake(13.38, 8.85) controlPoint2: CGPointMake(13.37, 8.88)];
        [bezier11Path addCurveToPoint: CGPointMake(13.35, 9.02) controlPoint1: CGPointMake(13.36, 8.95) controlPoint2: CGPointMake(13.35, 8.98)];
        [bezier11Path addCurveToPoint: CGPointMake(13.34, 9.12) controlPoint1: CGPointMake(13.34, 9.06) controlPoint2: CGPointMake(13.34, 9.09)];
        [bezier11Path addCurveToPoint: CGPointMake(13.34, 9.14) controlPoint1: CGPointMake(13.34, 9.13) controlPoint2: CGPointMake(13.34, 9.14)];
        [bezier11Path addCurveToPoint: CGPointMake(13.33, 9.35) controlPoint1: CGPointMake(13.33, 9.21) controlPoint2: CGPointMake(13.33, 9.28)];
        [bezier11Path addCurveToPoint: CGPointMake(13.18, 9.36) controlPoint1: CGPointMake(13.27, 9.36) controlPoint2: CGPointMake(13.23, 9.36)];
        [bezier11Path addLineToPoint: CGPointMake(9.42, 9.36)];
        [bezier11Path addCurveToPoint: CGPointMake(7.06, 7.13) controlPoint1: CGPointMake(9.41, 8.13) controlPoint2: CGPointMake(8.36, 7.13)];
        [bezier11Path addCurveToPoint: CGPointMake(4.71, 9.36) controlPoint1: CGPointMake(5.76, 7.13) controlPoint2: CGPointMake(4.72, 8.13)];
        [bezier11Path addLineToPoint: CGPointMake(3.09, 9.36)];
        [bezier11Path addCurveToPoint: CGPointMake(2, 8.27) controlPoint1: CGPointMake(2.48, 9.36) controlPoint2: CGPointMake(2, 8.88)];
        [bezier11Path addLineToPoint: CGPointMake(2, 6.33)];
        [bezier11Path addCurveToPoint: CGPointMake(3.09, 5.25) controlPoint1: CGPointMake(2, 5.74) controlPoint2: CGPointMake(2.49, 5.25)];
        [bezier11Path addLineToPoint: CGPointMake(19.9, 5.25)];
        [bezier11Path addCurveToPoint: CGPointMake(21, 6.33) controlPoint1: CGPointMake(20.51, 5.25) controlPoint2: CGPointMake(21, 5.74)];
        [bezier11Path closePath];
        bezier11Path.miterLimit = 4;
        
        [color3 setFill];
        [bezier11Path fill];
        
        
        //// Bezier 15 Drawing
        UIBezierPath* bezier15Path = UIBezierPath.bezierPath;
        [bezier15Path moveToPoint: CGPointMake(13.52, 9.15)];
        [bezier15Path addCurveToPoint: CGPointMake(13.5, 9.36) controlPoint1: CGPointMake(13.51, 9.22) controlPoint2: CGPointMake(13.5, 9.29)];
        [bezier15Path addCurveToPoint: CGPointMake(13.52, 9.15) controlPoint1: CGPointMake(13.5, 9.28) controlPoint2: CGPointMake(13.51, 9.21)];
        [bezier15Path closePath];
        bezier15Path.miterLimit = 4;
        
        [color3 setFill];
        [bezier15Path fill];
        
        
        //// Oval 3 Drawing
        UIBezierPath* oval3Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(5.5, 7.7, 3, 3)];
        [color3 setFill];
        [oval3Path fill];
        
        
        //// Oval 7 Drawing
        UIBezierPath* oval7Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(14.5, 7.7, 3, 3)];
        [color3 setFill];
        [oval7Path fill];
    }

}


@end
