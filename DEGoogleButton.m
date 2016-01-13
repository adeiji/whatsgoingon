//
//  DEGoogleButton.m
//  whatsgoinon
//
//  Created by adeiji on 8/28/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import "DEGoogleButton.h"

@implementation DEGoogleButton

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
    UIColor* color = [UIColor colorWithRed: 0.075 green: 0.606 blue: 0.915 alpha: 1];
    UIColor* color2 = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
    
    //// Events_2_Share
    {
        //// Icons
        {
            //// Oval 2 Drawing
            UIBezierPath* oval2Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(0, 0, 50, 50)];
            [color setFill];
            [oval2Path fill];
            
            
            //// Group 4
            {
                //// Bezier 2 Drawing
                UIBezierPath* bezier2Path = UIBezierPath.bezierPath;
                [bezier2Path moveToPoint: CGPointMake(29.54, 27)];
                [bezier2Path addCurveToPoint: CGPointMake(28.73, 21.77) controlPoint1: CGPointMake(26.8, 24.95) controlPoint2: CGPointMake(26.09, 23.82)];
                [bezier2Path addCurveToPoint: CGPointMake(31.27, 17.16) controlPoint1: CGPointMake(30.2, 20.6) controlPoint2: CGPointMake(31.27, 19.06)];
                [bezier2Path addCurveToPoint: CGPointMake(28.83, 12.25) controlPoint1: CGPointMake(31.27, 15.11) controlPoint2: CGPointMake(30.4, 13.22)];
                [bezier2Path addLineToPoint: CGPointMake(31.07, 12.25)];
                [bezier2Path addLineToPoint: CGPointMake(33, 10.3)];
                [bezier2Path addCurveToPoint: CGPointMake(24.46, 10.3) controlPoint1: CGPointMake(33, 10.3) controlPoint2: CGPointMake(25.78, 10.3)];
                [bezier2Path addCurveToPoint: CGPointMake(16.53, 17.06) controlPoint1: CGPointMake(19.12, 10.3) controlPoint2: CGPointMake(16.53, 13.53)];
                [bezier2Path addCurveToPoint: CGPointMake(23.8, 23.51) controlPoint1: CGPointMake(16.53, 20.7) controlPoint2: CGPointMake(18.97, 23.51)];
                [bezier2Path addCurveToPoint: CGPointMake(24.56, 27.46) controlPoint1: CGPointMake(23.04, 25.05) controlPoint2: CGPointMake(23.34, 26.43)];
                [bezier2Path addCurveToPoint: CGPointMake(14.6, 33.91) controlPoint1: CGPointMake(16.33, 27.46) controlPoint2: CGPointMake(14.6, 31.1)];
                [bezier2Path addCurveToPoint: CGPointMake(23.7, 39.7) controlPoint1: CGPointMake(14.6, 37.55) controlPoint2: CGPointMake(18.72, 39.7)];
                [bezier2Path addCurveToPoint: CGPointMake(33.2, 33.09) controlPoint1: CGPointMake(30.51, 39.7) controlPoint2: CGPointMake(33.2, 36.06)];
                [bezier2Path addCurveToPoint: CGPointMake(29.54, 27) controlPoint1: CGPointMake(33.15, 30.63) controlPoint2: CGPointMake(32.29, 29.05)];
                [bezier2Path closePath];
                [bezier2Path moveToPoint: CGPointMake(19.73, 17.01)];
                [bezier2Path addCurveToPoint: CGPointMake(23.19, 11.68) controlPoint1: CGPointMake(19.33, 13.94) controlPoint2: CGPointMake(20.9, 11.63)];
                [bezier2Path addCurveToPoint: CGPointMake(27.86, 17.32) controlPoint1: CGPointMake(25.48, 11.73) controlPoint2: CGPointMake(27.46, 14.24)];
                [bezier2Path addCurveToPoint: CGPointMake(24.61, 22.23) controlPoint1: CGPointMake(28.27, 20.39) controlPoint2: CGPointMake(26.95, 22.34)];
                [bezier2Path addCurveToPoint: CGPointMake(19.73, 17.01) controlPoint1: CGPointMake(22.27, 22.18) controlPoint2: CGPointMake(20.09, 20.03)];
                [bezier2Path closePath];
                [bezier2Path moveToPoint: CGPointMake(23.7, 38.06)];
                [bezier2Path addCurveToPoint: CGPointMake(17.8, 33.25) controlPoint1: CGPointMake(20.24, 38.06) controlPoint2: CGPointMake(17.8, 35.86)];
                [bezier2Path addCurveToPoint: CGPointMake(24.15, 28.48) controlPoint1: CGPointMake(17.8, 30.69) controlPoint2: CGPointMake(20.7, 28.43)];
                [bezier2Path addCurveToPoint: CGPointMake(30.25, 33.4) controlPoint1: CGPointMake(27.97, 28.48) controlPoint2: CGPointMake(30.25, 30.89)];
                [bezier2Path addCurveToPoint: CGPointMake(23.7, 38.06) controlPoint1: CGPointMake(30.2, 36.01) controlPoint2: CGPointMake(28.07, 38.06)];
                [bezier2Path closePath];
                [bezier2Path moveToPoint: CGPointMake(39.15, 22.49)];
                [bezier2Path addLineToPoint: CGPointMake(39.15, 19.26)];
                [bezier2Path addLineToPoint: CGPointMake(37.11, 19.26)];
                [bezier2Path addLineToPoint: CGPointMake(37.11, 22.49)];
                [bezier2Path addLineToPoint: CGPointMake(33.91, 22.49)];
                [bezier2Path addLineToPoint: CGPointMake(33.91, 24.54)];
                [bezier2Path addLineToPoint: CGPointMake(37.11, 24.54)];
                [bezier2Path addLineToPoint: CGPointMake(37.11, 27.92)];
                [bezier2Path addLineToPoint: CGPointMake(39.15, 27.92)];
                [bezier2Path addLineToPoint: CGPointMake(39.15, 24.49)];
                [bezier2Path addLineToPoint: CGPointMake(42.5, 24.49)];
                [bezier2Path addLineToPoint: CGPointMake(42.5, 22.44)];
                [bezier2Path addLineToPoint: CGPointMake(39.15, 22.44)];
                [bezier2Path addLineToPoint: CGPointMake(39.15, 22.49)];
                [bezier2Path closePath];
                bezier2Path.miterLimit = 4;
                
                [color2 setFill];
                [bezier2Path fill];
            }
        }
    }

}

@end
