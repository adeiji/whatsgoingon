//
//  DEHappSnapTitleView.m
//  whatsgoinon
//
//  Created by adeiji on 8/26/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import "DEHappSnapTitleView.h"

@implementation DEHappSnapTitleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = NO;
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    //// Color Declarations
    UIColor* color0 = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
    
    //// Layer_2
    {
        //// Bezier 2 Drawing
        UIBezierPath* bezier2Path = UIBezierPath.bezierPath;
        [bezier2Path moveToPoint: CGPointMake(70.6, 11.3)];
        [bezier2Path addCurveToPoint: CGPointMake(12.9, 69) controlPoint1: CGPointMake(38.8, 11.3) controlPoint2: CGPointMake(12.9, 37.1)];
        [bezier2Path addCurveToPoint: CGPointMake(70.6, 126.7) controlPoint1: CGPointMake(12.9, 100.8) controlPoint2: CGPointMake(38.7, 126.7)];
        [bezier2Path addCurveToPoint: CGPointMake(128.3, 69) controlPoint1: CGPointMake(102.4, 126.7) controlPoint2: CGPointMake(128.3, 100.9)];
        [bezier2Path addCurveToPoint: CGPointMake(70.6, 11.3) controlPoint1: CGPointMake(128.3, 37.1) controlPoint2: CGPointMake(102.5, 11.3)];
        [bezier2Path closePath];
        [bezier2Path moveToPoint: CGPointMake(71.2, 71.9)];
        [bezier2Path addCurveToPoint: CGPointMake(70.4, 71.8) controlPoint1: CGPointMake(70.9, 71.9) controlPoint2: CGPointMake(70.6, 71.9)];
        [bezier2Path addLineToPoint: CGPointMake(56.4, 85.8)];
        [bezier2Path addCurveToPoint: CGPointMake(53.9, 85.8) controlPoint1: CGPointMake(55.7, 86.5) controlPoint2: CGPointMake(54.6, 86.5)];
        [bezier2Path addCurveToPoint: CGPointMake(53.9, 83.3) controlPoint1: CGPointMake(53.2, 85.1) controlPoint2: CGPointMake(53.2, 84)];
        [bezier2Path addLineToPoint: CGPointMake(67.9, 69.3)];
        [bezier2Path addCurveToPoint: CGPointMake(67.8, 68.5) controlPoint1: CGPointMake(67.8, 69) controlPoint2: CGPointMake(67.8, 68.8)];
        [bezier2Path addCurveToPoint: CGPointMake(69.4, 65.6) controlPoint1: CGPointMake(67.8, 67.3) controlPoint2: CGPointMake(68.5, 66.2)];
        [bezier2Path addLineToPoint: CGPointMake(69.4, 27)];
        [bezier2Path addCurveToPoint: CGPointMake(71.1, 25.3) controlPoint1: CGPointMake(69.4, 26) controlPoint2: CGPointMake(70.2, 25.3)];
        [bezier2Path addCurveToPoint: CGPointMake(72.8, 27) controlPoint1: CGPointMake(72.1, 25.3) controlPoint2: CGPointMake(72.8, 26.1)];
        [bezier2Path addLineToPoint: CGPointMake(72.8, 65.5)];
        [bezier2Path addCurveToPoint: CGPointMake(74.5, 68.4) controlPoint1: CGPointMake(73.8, 66.1) controlPoint2: CGPointMake(74.5, 67.2)];
        [bezier2Path addCurveToPoint: CGPointMake(71.2, 71.9) controlPoint1: CGPointMake(74.6, 70.4) controlPoint2: CGPointMake(73.1, 71.9)];
        [bezier2Path closePath];
        bezier2Path.miterLimit = 4;
        
        [color0 setFill];
        [bezier2Path fill];
        
        
        //// Bezier 4 Drawing
        UIBezierPath* bezier4Path = UIBezierPath.bezierPath;
        [bezier4Path moveToPoint: CGPointMake(126.2, 98.7)];
        [bezier4Path addLineToPoint: CGPointMake(126, 99.1)];
        [bezier4Path addLineToPoint: CGPointMake(125.2, 100.4)];
        [bezier4Path addLineToPoint: CGPointMake(77.3, 183.4)];
        [bezier4Path addCurveToPoint: CGPointMake(65.2, 183.4) controlPoint1: CGPointMake(74.6, 188) controlPoint2: CGPointMake(67.9, 188)];
        [bezier4Path addLineToPoint: CGPointMake(17.6, 101)];
        [bezier4Path addCurveToPoint: CGPointMake(17.4, 100.7) controlPoint1: CGPointMake(17.5, 100.9) controlPoint2: CGPointMake(17.5, 100.8)];
        [bezier4Path addLineToPoint: CGPointMake(16.2, 98.6)];
        [bezier4Path addLineToPoint: CGPointMake(16.2, 98.6)];
        [bezier4Path addLineToPoint: CGPointMake(27.6, 98.6)];
        [bezier4Path addCurveToPoint: CGPointMake(71.2, 121.5) controlPoint1: CGPointMake(37.2, 112.4) controlPoint2: CGPointMake(53.1, 121.5)];
        [bezier4Path addCurveToPoint: CGPointMake(114.8, 98.7) controlPoint1: CGPointMake(89.3, 121.5) controlPoint2: CGPointMake(105.2, 112.5)];
        [bezier4Path addLineToPoint: CGPointMake(126.2, 98.7)];
        [bezier4Path addLineToPoint: CGPointMake(126.2, 98.7)];
        [bezier4Path closePath];
        bezier4Path.miterLimit = 4;
        
        [color0 setFill];
        [bezier4Path fill];
        
        
        //// Bezier 6 Drawing
        UIBezierPath* bezier6Path = UIBezierPath.bezierPath;
        [bezier6Path moveToPoint: CGPointMake(71.2, 5.9)];
        [bezier6Path addCurveToPoint: CGPointMake(8.5, 68.6) controlPoint1: CGPointMake(36.6, 5.9) controlPoint2: CGPointMake(8.5, 34)];
        [bezier6Path addCurveToPoint: CGPointMake(16.2, 98.7) controlPoint1: CGPointMake(8.5, 79.5) controlPoint2: CGPointMake(11.3, 89.8)];
        [bezier6Path addCurveToPoint: CGPointMake(16.3, 98.9) controlPoint1: CGPointMake(16.2, 98.8) controlPoint2: CGPointMake(16.3, 98.8)];
        [bezier6Path addLineToPoint: CGPointMake(17.4, 100.8)];
        [bezier6Path addCurveToPoint: CGPointMake(17.6, 101.1) controlPoint1: CGPointMake(17.4, 100.9) controlPoint2: CGPointMake(17.5, 101)];
        [bezier6Path addCurveToPoint: CGPointMake(71.2, 131.3) controlPoint1: CGPointMake(28.6, 119.2) controlPoint2: CGPointMake(48.5, 131.3)];
        [bezier6Path addCurveToPoint: CGPointMake(125.2, 100.5) controlPoint1: CGPointMake(94.2, 131.3) controlPoint2: CGPointMake(114.2, 119)];
        [bezier6Path addLineToPoint: CGPointMake(126, 99.2)];
        [bezier6Path addCurveToPoint: CGPointMake(126.2, 98.8) controlPoint1: CGPointMake(126.1, 99.1) controlPoint2: CGPointMake(126.2, 98.9)];
        [bezier6Path addLineToPoint: CGPointMake(126.2, 98.8)];
        [bezier6Path addCurveToPoint: CGPointMake(133.9, 68.6) controlPoint1: CGPointMake(131.1, 89.9) controlPoint2: CGPointMake(133.9, 79.6)];
        [bezier6Path addCurveToPoint: CGPointMake(71.2, 5.9) controlPoint1: CGPointMake(133.9, 33.9) controlPoint2: CGPointMake(105.9, 5.9)];
        [bezier6Path closePath];
        [bezier6Path moveToPoint: CGPointMake(71.2, 121.5)];
        [bezier6Path addCurveToPoint: CGPointMake(27.6, 98.6) controlPoint1: CGPointMake(53.1, 121.5) controlPoint2: CGPointMake(37.2, 112.4)];
        [bezier6Path addCurveToPoint: CGPointMake(18.2, 68.5) controlPoint1: CGPointMake(21.7, 90.1) controlPoint2: CGPointMake(18.2, 79.7)];
        [bezier6Path addCurveToPoint: CGPointMake(71.2, 15.5) controlPoint1: CGPointMake(18.2, 39.2) controlPoint2: CGPointMake(41.9, 15.5)];
        [bezier6Path addCurveToPoint: CGPointMake(124.2, 68.5) controlPoint1: CGPointMake(100.5, 15.5) controlPoint2: CGPointMake(124.2, 39.2)];
        [bezier6Path addCurveToPoint: CGPointMake(114.8, 98.7) controlPoint1: CGPointMake(124.2, 79.7) controlPoint2: CGPointMake(120.7, 90.1)];
        [bezier6Path addCurveToPoint: CGPointMake(71.2, 121.5) controlPoint1: CGPointMake(105.3, 112.5) controlPoint2: CGPointMake(89.3, 121.5)];
        [bezier6Path closePath];
        bezier6Path.miterLimit = 4;
        
        [color0 setFill];
        [bezier6Path fill];
    }


}

@end
