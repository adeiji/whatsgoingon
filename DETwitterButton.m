//
//  DETwitterButton.m
//  whatsgoinon
//
//  Created by adeiji on 8/28/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import "DETwitterButton.h"

@implementation DETwitterButton

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
    // Drawing code
    //// Color Declarations
    UIColor* color0 = [UIColor colorWithRed: 0.075 green: 0.606 blue: 0.915 alpha: 1];
    UIColor* color1 = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
    
    //// Layer_1
    {
    }
    
    
    //// Events_2_Share
    {
        //// Oval 2 Drawing
        UIBezierPath* oval2Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(0.9, 0.6, 48, 48)];
        [color0 setFill];
        [oval2Path fill];
        
        
        //// _x36_4_2_ Drawing
        UIBezierPath* _x36_4_2_Path = UIBezierPath.bezierPath;
        [_x36_4_2_Path moveToPoint: CGPointMake(36.99, 17.83)];
        [_x36_4_2_Path addCurveToPoint: CGPointMake(34.21, 18.57) controlPoint1: CGPointMake(36.13, 18.2) controlPoint2: CGPointMake(35.19, 18.46)];
        [_x36_4_2_Path addCurveToPoint: CGPointMake(34.19, 18.51) controlPoint1: CGPointMake(34.21, 18.54) controlPoint2: CGPointMake(34.19, 18.54)];
        [_x36_4_2_Path addCurveToPoint: CGPointMake(36.41, 15.8) controlPoint1: CGPointMake(35.21, 17.91) controlPoint2: CGPointMake(36.01, 16.94)];
        [_x36_4_2_Path addCurveToPoint: CGPointMake(33.27, 17.06) controlPoint1: CGPointMake(36.13, 15.97) controlPoint2: CGPointMake(34.67, 16.8)];
        [_x36_4_2_Path addCurveToPoint: CGPointMake(29.56, 15.4) controlPoint1: CGPointMake(32.36, 16.06) controlPoint2: CGPointMake(31.01, 15.4)];
        [_x36_4_2_Path addCurveToPoint: CGPointMake(24.53, 20.43) controlPoint1: CGPointMake(26.44, 15.4) controlPoint2: CGPointMake(24.53, 17.94)];
        [_x36_4_2_Path addCurveToPoint: CGPointMake(24.64, 21.46) controlPoint1: CGPointMake(24.53, 20.63) controlPoint2: CGPointMake(24.61, 21.43)];
        [_x36_4_2_Path addCurveToPoint: CGPointMake(14.36, 16.26) controlPoint1: CGPointMake(20.47, 21.37) controlPoint2: CGPointMake(16.76, 19.34)];
        [_x36_4_2_Path addCurveToPoint: CGPointMake(15.67, 23.03) controlPoint1: CGPointMake(12.64, 19.37) controlPoint2: CGPointMake(14.44, 22.09)];
        [_x36_4_2_Path addCurveToPoint: CGPointMake(13.67, 22.6) controlPoint1: CGPointMake(14.96, 23.03) controlPoint2: CGPointMake(14.27, 22.86)];
        [_x36_4_2_Path addCurveToPoint: CGPointMake(17.81, 27.46) controlPoint1: CGPointMake(13.81, 25) controlPoint2: CGPointMake(15.53, 26.97)];
        [_x36_4_2_Path addCurveToPoint: CGPointMake(15.39, 27.4) controlPoint1: CGPointMake(16.9, 27.71) controlPoint2: CGPointMake(15.81, 27.51)];
        [_x36_4_2_Path addCurveToPoint: CGPointMake(20.1, 30.97) controlPoint1: CGPointMake(16.07, 29.4) controlPoint2: CGPointMake(17.9, 30.86)];
        [_x36_4_2_Path addCurveToPoint: CGPointMake(13.01, 33.2) controlPoint1: CGPointMake(16.73, 33.46) controlPoint2: CGPointMake(13.1, 33.2)];
        [_x36_4_2_Path addCurveToPoint: CGPointMake(20.33, 35.23) controlPoint1: CGPointMake(15.16, 34.49) controlPoint2: CGPointMake(17.64, 35.23)];
        [_x36_4_2_Path addCurveToPoint: CGPointMake(34.56, 20.23) controlPoint1: CGPointMake(30.13, 35.17) controlPoint2: CGPointMake(35.16, 26.46)];
        [_x36_4_2_Path addCurveToPoint: CGPointMake(36.99, 17.83) controlPoint1: CGPointMake(35.61, 19.77) controlPoint2: CGPointMake(36.5, 18.91)];
        [_x36_4_2_Path closePath];
        _x36_4_2_Path.miterLimit = 4;
        
        [color1 setFill];
        [_x36_4_2_Path fill];
    }

}


@end
