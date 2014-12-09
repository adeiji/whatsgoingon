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
    UIColor* color3 = [UIColor colorWithRed: 0.25 green: 0.25 blue: 0.25 alpha: 0.4];
    UIColor* color1 = [UIColor colorWithRed: 0.259 green: 0.737 blue: 0.384 alpha: 1];
    UIColor* color2 = [UIColor colorWithRed: 0.25 green: 0.25 blue: 0.25 alpha: 0.5];
    UIColor* color0 = [UIColor colorWithRed: 0.074 green: 0.601 blue: 0.915 alpha: 1];
    
    //// Bezier 2 Drawing
    UIBezierPath* bezier2Path = UIBezierPath.bezierPath;
    [bezier2Path moveToPoint: CGPointMake(133.47, 38.94)];
    [bezier2Path addCurveToPoint: CGPointMake(107.61, 24.4) controlPoint1: CGPointMake(128.12, 31.54) controlPoint2: CGPointMake(119.37, 25.44)];
    [bezier2Path addCurveToPoint: CGPointMake(105.26, 24.4) controlPoint1: CGPointMake(106.84, 24.4) controlPoint2: CGPointMake(106.03, 24.4)];
    [bezier2Path addCurveToPoint: CGPointMake(102.91, 24.4) controlPoint1: CGPointMake(104.49, 24.4) controlPoint2: CGPointMake(103.68, 24.4)];
    [bezier2Path addCurveToPoint: CGPointMake(77.05, 38.94) controlPoint1: CGPointMake(91.15, 25.44) controlPoint2: CGPointMake(82.4, 31.5)];
    [bezier2Path addCurveToPoint: CGPointMake(72.31, 70.76) controlPoint1: CGPointMake(71.34, 46.81) controlPoint2: CGPointMake(68.34, 58.92)];
    [bezier2Path addCurveToPoint: CGPointMake(86.87, 96.53) controlPoint1: CGPointMake(75.54, 80.37) controlPoint2: CGPointMake(81.25, 88.62)];
    [bezier2Path addCurveToPoint: CGPointMake(105.26, 118.24) controlPoint1: CGPointMake(92.58, 104.51) controlPoint2: CGPointMake(98.75, 112.19)];
    [bezier2Path addCurveToPoint: CGPointMake(123.64, 96.53) controlPoint1: CGPointMake(111.77, 112.19) controlPoint2: CGPointMake(117.94, 104.55)];
    [bezier2Path addCurveToPoint: CGPointMake(138.21, 70.76) controlPoint1: CGPointMake(129.27, 88.66) controlPoint2: CGPointMake(134.98, 80.37)];
    [bezier2Path addCurveToPoint: CGPointMake(133.47, 38.94) controlPoint1: CGPointMake(142.18, 58.92) controlPoint2: CGPointMake(139.18, 46.81)];
    [bezier2Path closePath];
    [bezier2Path moveToPoint: CGPointMake(104.99, 86.19)];
    [bezier2Path addCurveToPoint: CGPointMake(78.82, 60.08) controlPoint1: CGPointMake(90.54, 86.19) controlPoint2: CGPointMake(78.82, 74.5)];
    [bezier2Path addCurveToPoint: CGPointMake(104.99, 33.97) controlPoint1: CGPointMake(78.82, 45.65) controlPoint2: CGPointMake(90.54, 33.97)];
    [bezier2Path addCurveToPoint: CGPointMake(131.16, 60.08) controlPoint1: CGPointMake(119.44, 33.97) controlPoint2: CGPointMake(131.16, 45.65)];
    [bezier2Path addCurveToPoint: CGPointMake(104.99, 86.19) controlPoint1: CGPointMake(131.16, 74.5) controlPoint2: CGPointMake(119.44, 86.19)];
    [bezier2Path closePath];
    bezier2Path.miterLimit = 4;
    
    bezier2Path.usesEvenOddFillRule = YES;
    
    [color0 setFill];
    [bezier2Path fill];
    
    
    //// Bezier 4 Drawing
    UIBezierPath* bezier4Path = UIBezierPath.bezierPath;
    [bezier4Path moveToPoint: CGPointMake(105.95, 41.8)];
    [bezier4Path addCurveToPoint: CGPointMake(104.99, 42.76) controlPoint1: CGPointMake(105.95, 42.34) controlPoint2: CGPointMake(105.53, 42.76)];
    [bezier4Path addLineToPoint: CGPointMake(104.99, 42.76)];
    [bezier4Path addCurveToPoint: CGPointMake(104.03, 41.8) controlPoint1: CGPointMake(104.45, 42.76) controlPoint2: CGPointMake(104.03, 42.34)];
    [bezier4Path addLineToPoint: CGPointMake(104.03, 37.55)];
    [bezier4Path addCurveToPoint: CGPointMake(104.99, 36.59) controlPoint1: CGPointMake(104.03, 37.01) controlPoint2: CGPointMake(104.45, 36.59)];
    [bezier4Path addLineToPoint: CGPointMake(104.99, 36.59)];
    [bezier4Path addCurveToPoint: CGPointMake(105.95, 37.55) controlPoint1: CGPointMake(105.53, 36.59) controlPoint2: CGPointMake(105.95, 37.01)];
    [bezier4Path addLineToPoint: CGPointMake(105.95, 41.8)];
    [bezier4Path closePath];
    bezier4Path.miterLimit = 4;
    
    [color0 setFill];
    [bezier4Path fill];
    
    
    //// Bezier 6 Drawing
    UIBezierPath* bezier6Path = UIBezierPath.bezierPath;
    [bezier6Path moveToPoint: CGPointMake(105.95, 82.68)];
    [bezier6Path addCurveToPoint: CGPointMake(104.99, 83.65) controlPoint1: CGPointMake(105.95, 83.22) controlPoint2: CGPointMake(105.53, 83.65)];
    [bezier6Path addLineToPoint: CGPointMake(104.99, 83.65)];
    [bezier6Path addCurveToPoint: CGPointMake(104.03, 82.68) controlPoint1: CGPointMake(104.45, 83.65) controlPoint2: CGPointMake(104.03, 83.22)];
    [bezier6Path addLineToPoint: CGPointMake(104.03, 78.44)];
    [bezier6Path addCurveToPoint: CGPointMake(104.99, 77.47) controlPoint1: CGPointMake(104.03, 77.9) controlPoint2: CGPointMake(104.45, 77.47)];
    [bezier6Path addLineToPoint: CGPointMake(104.99, 77.47)];
    [bezier6Path addCurveToPoint: CGPointMake(105.95, 78.44) controlPoint1: CGPointMake(105.53, 77.47) controlPoint2: CGPointMake(105.95, 77.9)];
    [bezier6Path addLineToPoint: CGPointMake(105.95, 82.68)];
    [bezier6Path closePath];
    bezier6Path.miterLimit = 4;
    
    [color0 setFill];
    [bezier6Path fill];
    
    
    //// Bezier 8 Drawing
    UIBezierPath* bezier8Path = UIBezierPath.bezierPath;
    [bezier8Path moveToPoint: CGPointMake(122.64, 60.39)];
    [bezier8Path addCurveToPoint: CGPointMake(121.68, 59.42) controlPoint1: CGPointMake(122.1, 60.39) controlPoint2: CGPointMake(121.68, 59.96)];
    [bezier8Path addLineToPoint: CGPointMake(121.68, 59.42)];
    [bezier8Path addCurveToPoint: CGPointMake(122.64, 58.46) controlPoint1: CGPointMake(121.68, 58.88) controlPoint2: CGPointMake(122.1, 58.46)];
    [bezier8Path addLineToPoint: CGPointMake(126.88, 58.46)];
    [bezier8Path addCurveToPoint: CGPointMake(127.85, 59.42) controlPoint1: CGPointMake(127.42, 58.46) controlPoint2: CGPointMake(127.85, 58.88)];
    [bezier8Path addLineToPoint: CGPointMake(127.85, 59.42)];
    [bezier8Path addCurveToPoint: CGPointMake(126.88, 60.39) controlPoint1: CGPointMake(127.85, 59.96) controlPoint2: CGPointMake(127.42, 60.39)];
    [bezier8Path addLineToPoint: CGPointMake(122.64, 60.39)];
    [bezier8Path closePath];
    bezier8Path.miterLimit = 4;
    
    [color0 setFill];
    [bezier8Path fill];
    
    
    //// Bezier 10 Drawing
    UIBezierPath* bezier10Path = UIBezierPath.bezierPath;
    [bezier10Path moveToPoint: CGPointMake(82.44, 60.39)];
    [bezier10Path addCurveToPoint: CGPointMake(81.48, 59.42) controlPoint1: CGPointMake(81.9, 60.39) controlPoint2: CGPointMake(81.48, 59.96)];
    [bezier10Path addLineToPoint: CGPointMake(81.48, 59.42)];
    [bezier10Path addCurveToPoint: CGPointMake(82.44, 58.46) controlPoint1: CGPointMake(81.48, 58.88) controlPoint2: CGPointMake(81.9, 58.46)];
    [bezier10Path addLineToPoint: CGPointMake(86.68, 58.46)];
    [bezier10Path addCurveToPoint: CGPointMake(87.65, 59.42) controlPoint1: CGPointMake(87.22, 58.46) controlPoint2: CGPointMake(87.65, 58.88)];
    [bezier10Path addLineToPoint: CGPointMake(87.65, 59.42)];
    [bezier10Path addCurveToPoint: CGPointMake(86.68, 60.39) controlPoint1: CGPointMake(87.65, 59.96) controlPoint2: CGPointMake(87.22, 60.39)];
    [bezier10Path addLineToPoint: CGPointMake(82.44, 60.39)];
    [bezier10Path closePath];
    bezier10Path.miterLimit = 4;
    
    [color0 setFill];
    [bezier10Path fill];
    
    
    //// Group
    {
        //// Bezier 12 Drawing
        UIBezierPath* bezier12Path = UIBezierPath.bezierPath;
        [bezier12Path moveToPoint: CGPointMake(101.77, 59.72)];
        [bezier12Path addLineToPoint: CGPointMake(94.47, 66.9)];
        [bezier12Path addCurveToPoint: CGPointMake(95.74, 68.19) controlPoint1: CGPointMake(94.47, 66.9) controlPoint2: CGPointMake(94.2, 68.59)];
        [bezier12Path addLineToPoint: CGPointMake(104.46, 60.05)];
        [bezier12Path addLineToPoint: CGPointMake(103.85, 58.8)];
        [bezier12Path addLineToPoint: CGPointMake(101.77, 59.72)];
        [bezier12Path closePath];
        bezier12Path.miterLimit = 4;
        
        [color0 setFill];
        [bezier12Path fill];
        
        
        //// Bezier 14 Drawing
        UIBezierPath* bezier14Path = UIBezierPath.bezierPath;
        [bezier14Path moveToPoint: CGPointMake(118.14, 69.62)];
        [bezier14Path addLineToPoint: CGPointMake(106.69, 58.8)];
        [bezier14Path addLineToPoint: CGPointMake(105.61, 60.6)];
        [bezier14Path addLineToPoint: CGPointMake(116.45, 70.94)];
        [bezier14Path addCurveToPoint: CGPointMake(118.14, 69.62) controlPoint1: CGPointMake(116.49, 70.97) controlPoint2: CGPointMake(118.41, 71.12)];
        [bezier14Path closePath];
        bezier14Path.miterLimit = 4;
        
        [color0 setFill];
        [bezier14Path fill];
    }
    
    
    //// Bezier 16 Drawing
    UIBezierPath* bezier16Path = UIBezierPath.bezierPath;
    [bezier16Path moveToPoint: CGPointMake(104.07, 56.14)];
    [bezier16Path addLineToPoint: CGPointMake(104.03, 56.14)];
    [bezier16Path addLineToPoint: CGPointMake(100.25, 41.37)];
    [bezier16Path addCurveToPoint: CGPointMake(99.09, 41.8) controlPoint1: CGPointMake(99.4, 40.91) controlPoint2: CGPointMake(99.09, 41.8)];
    [bezier16Path addLineToPoint: CGPointMake(102.79, 56.49)];
    [bezier16Path addLineToPoint: CGPointMake(102.64, 56.57)];
    [bezier16Path addLineToPoint: CGPointMake(102.64, 56.57)];
    [bezier16Path addCurveToPoint: CGPointMake(101.41, 58.81) controlPoint1: CGPointMake(101.91, 57.03) controlPoint2: CGPointMake(101.41, 57.88)];
    [bezier16Path addCurveToPoint: CGPointMake(104.07, 61.47) controlPoint1: CGPointMake(101.41, 60.27) controlPoint2: CGPointMake(102.6, 61.47)];
    [bezier16Path addCurveToPoint: CGPointMake(106.72, 58.81) controlPoint1: CGPointMake(105.53, 61.47) controlPoint2: CGPointMake(106.72, 60.27)];
    [bezier16Path addCurveToPoint: CGPointMake(104.07, 56.14) controlPoint1: CGPointMake(106.69, 57.34) controlPoint2: CGPointMake(105.53, 56.14)];
    [bezier16Path closePath];
    bezier16Path.miterLimit = 4;
    
    [color1 setFill];
    [bezier16Path fill];
    
    
    //// Oval 2 Drawing
    UIBezierPath* oval2Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(94.4, 121.1, 22.2, 5.2)];
    [color2 setFill];
    [oval2Path fill];
    
    
    //// Group 2
    {
        //// Bezier 18 Drawing
        UIBezierPath* bezier18Path = UIBezierPath.bezierPath;
        [bezier18Path moveToPoint: CGPointMake(138.09, 142.6)];
        [bezier18Path addLineToPoint: CGPointMake(168.3, 142.6)];
        [bezier18Path addLineToPoint: CGPointMake(153.43, 121.1)];
        [bezier18Path addLineToPoint: CGPointMake(130.23, 121.1)];
        [bezier18Path addLineToPoint: CGPointMake(138.09, 142.6)];
        [bezier18Path closePath];
        bezier18Path.miterLimit = 4;
        
        [color1 setFill];
        [bezier18Path fill];
        
        
        //// Bezier 20 Drawing
        UIBezierPath* bezier20Path = UIBezierPath.bezierPath;
        [bezier20Path moveToPoint: CGPointMake(119.36, 121.1)];
        [bezier20Path addLineToPoint: CGPointMake(56.28, 121.1)];
        [bezier20Path addLineToPoint: CGPointMake(40.4, 142.6)];
        [bezier20Path addLineToPoint: CGPointMake(126.18, 142.6)];
        [bezier20Path addLineToPoint: CGPointMake(119.36, 121.1)];
        [bezier20Path closePath];
        bezier20Path.miterLimit = 4;
        
        [color0 setFill];
        [bezier20Path fill];
    }
    
    
    //// Group 3
    {
        //// Bezier 22 Drawing
        UIBezierPath* bezier22Path = UIBezierPath.bezierPath;
        [bezier22Path moveToPoint: CGPointMake(7.9, 149.94)];
        [bezier22Path addLineToPoint: CGPointMake(13.37, 149.94)];
        [bezier22Path addLineToPoint: CGPointMake(13.37, 160.77)];
        [bezier22Path addLineToPoint: CGPointMake(22.82, 160.77)];
        [bezier22Path addLineToPoint: CGPointMake(22.82, 149.94)];
        [bezier22Path addLineToPoint: CGPointMake(28.25, 149.94)];
        [bezier22Path addLineToPoint: CGPointMake(28.25, 178.66)];
        [bezier22Path addLineToPoint: CGPointMake(22.82, 178.66)];
        [bezier22Path addLineToPoint: CGPointMake(22.82, 166.08)];
        [bezier22Path addLineToPoint: CGPointMake(13.37, 166.08)];
        [bezier22Path addLineToPoint: CGPointMake(13.37, 178.66)];
        [bezier22Path addLineToPoint: CGPointMake(7.9, 178.66)];
        [bezier22Path addLineToPoint: CGPointMake(7.9, 149.94)];
        [bezier22Path closePath];
        bezier22Path.miterLimit = 4;
        
        [color0 setFill];
        [bezier22Path fill];
        
        
        //// Bezier 24 Drawing
        UIBezierPath* bezier24Path = UIBezierPath.bezierPath;
        [bezier24Path moveToPoint: CGPointMake(49.64, 157.41)];
        [bezier24Path addLineToPoint: CGPointMake(54.88, 157.41)];
        [bezier24Path addLineToPoint: CGPointMake(54.88, 178.66)];
        [bezier24Path addLineToPoint: CGPointMake(49.64, 178.66)];
        [bezier24Path addLineToPoint: CGPointMake(49.64, 176.44)];
        [bezier24Path addCurveToPoint: CGPointMake(46.56, 178.58) controlPoint1: CGPointMake(48.6, 177.41) controlPoint2: CGPointMake(47.6, 178.16)];
        [bezier24Path addCurveToPoint: CGPointMake(43.21, 179.25) controlPoint1: CGPointMake(45.52, 179.01) controlPoint2: CGPointMake(44.4, 179.25)];
        [bezier24Path addCurveToPoint: CGPointMake(36.19, 176.04) controlPoint1: CGPointMake(40.51, 179.25) controlPoint2: CGPointMake(38.16, 178.19)];
        [bezier24Path addCurveToPoint: CGPointMake(33.22, 168.11) controlPoint1: CGPointMake(34.22, 173.93) controlPoint2: CGPointMake(33.22, 171.28)];
        [bezier24Path addCurveToPoint: CGPointMake(36.08, 160.06) controlPoint1: CGPointMake(33.22, 164.83) controlPoint2: CGPointMake(34.19, 162.13)];
        [bezier24Path addCurveToPoint: CGPointMake(43.05, 156.94) controlPoint1: CGPointMake(38, 157.95) controlPoint2: CGPointMake(40.31, 156.94)];
        [bezier24Path addCurveToPoint: CGPointMake(46.6, 157.64) controlPoint1: CGPointMake(44.32, 156.94) controlPoint2: CGPointMake(45.48, 157.17)];
        [bezier24Path addCurveToPoint: CGPointMake(49.64, 159.79) controlPoint1: CGPointMake(47.72, 158.11) controlPoint2: CGPointMake(48.72, 158.85)];
        [bezier24Path addLineToPoint: CGPointMake(49.64, 157.41)];
        [bezier24Path closePath];
        [bezier24Path moveToPoint: CGPointMake(44.13, 161.78)];
        [bezier24Path addCurveToPoint: CGPointMake(40.08, 163.54) controlPoint1: CGPointMake(42.51, 161.78) controlPoint2: CGPointMake(41.16, 162.37)];
        [bezier24Path addCurveToPoint: CGPointMake(38.46, 168.03) controlPoint1: CGPointMake(39, 164.71) controlPoint2: CGPointMake(38.46, 166.2)];
        [bezier24Path addCurveToPoint: CGPointMake(40.12, 172.57) controlPoint1: CGPointMake(38.46, 169.87) controlPoint2: CGPointMake(39, 171.39)];
        [bezier24Path addCurveToPoint: CGPointMake(44.17, 174.33) controlPoint1: CGPointMake(41.2, 173.74) controlPoint2: CGPointMake(42.55, 174.33)];
        [bezier24Path addCurveToPoint: CGPointMake(48.29, 172.57) controlPoint1: CGPointMake(45.83, 174.33) controlPoint2: CGPointMake(47.18, 173.74)];
        [bezier24Path addCurveToPoint: CGPointMake(49.91, 168) controlPoint1: CGPointMake(49.37, 171.39) controlPoint2: CGPointMake(49.91, 169.87)];
        [bezier24Path addCurveToPoint: CGPointMake(48.29, 163.5) controlPoint1: CGPointMake(49.91, 166.16) controlPoint2: CGPointMake(49.37, 164.63)];
        [bezier24Path addCurveToPoint: CGPointMake(44.13, 161.78) controlPoint1: CGPointMake(47.14, 162.37) controlPoint2: CGPointMake(45.79, 161.78)];
        [bezier24Path closePath];
        bezier24Path.miterLimit = 4;
        
        [UIColor.whiteColor setFill];
        [bezier24Path fill];
        
        
        //// Bezier 26 Drawing
        UIBezierPath* bezier26Path = UIBezierPath.bezierPath;
        [bezier26Path moveToPoint: CGPointMake(65.44, 157.41)];
        [bezier26Path addLineToPoint: CGPointMake(65.44, 159.75)];
        [bezier26Path addCurveToPoint: CGPointMake(68.53, 157.6) controlPoint1: CGPointMake(66.41, 158.77) controlPoint2: CGPointMake(67.41, 158.07)];
        [bezier26Path addCurveToPoint: CGPointMake(72.07, 156.9) controlPoint1: CGPointMake(69.65, 157.13) controlPoint2: CGPointMake(70.8, 156.9)];
        [bezier26Path addCurveToPoint: CGPointMake(79.05, 160.02) controlPoint1: CGPointMake(74.81, 156.9) controlPoint2: CGPointMake(77.12, 157.95)];
        [bezier26Path addCurveToPoint: CGPointMake(81.9, 168.07) controlPoint1: CGPointMake(80.98, 162.13) controlPoint2: CGPointMake(81.9, 164.79)];
        [bezier26Path addCurveToPoint: CGPointMake(78.93, 176.01) controlPoint1: CGPointMake(81.9, 171.24) controlPoint2: CGPointMake(80.9, 173.9)];
        [bezier26Path addCurveToPoint: CGPointMake(71.92, 179.21) controlPoint1: CGPointMake(76.97, 178.12) controlPoint2: CGPointMake(74.62, 179.21)];
        [bezier26Path addCurveToPoint: CGPointMake(68.57, 178.55) controlPoint1: CGPointMake(70.73, 179.21) controlPoint2: CGPointMake(69.61, 178.98)];
        [bezier26Path addCurveToPoint: CGPointMake(65.48, 176.4) controlPoint1: CGPointMake(67.53, 178.12) controlPoint2: CGPointMake(66.49, 177.41)];
        [bezier26Path addLineToPoint: CGPointMake(65.48, 186.4)];
        [bezier26Path addLineToPoint: CGPointMake(60.28, 186.4)];
        [bezier26Path addLineToPoint: CGPointMake(60.28, 157.37)];
        [bezier26Path addLineToPoint: CGPointMake(65.44, 157.37)];
        [bezier26Path addLineToPoint: CGPointMake(65.44, 157.41)];
        [bezier26Path closePath];
        [bezier26Path moveToPoint: CGPointMake(70.96, 161.78)];
        [bezier26Path addCurveToPoint: CGPointMake(66.83, 163.5) controlPoint1: CGPointMake(69.3, 161.78) controlPoint2: CGPointMake(67.91, 162.37)];
        [bezier26Path addCurveToPoint: CGPointMake(65.21, 168) controlPoint1: CGPointMake(65.75, 164.63) controlPoint2: CGPointMake(65.21, 166.16)];
        [bezier26Path addCurveToPoint: CGPointMake(66.83, 172.57) controlPoint1: CGPointMake(65.21, 169.87) controlPoint2: CGPointMake(65.75, 171.39)];
        [bezier26Path addCurveToPoint: CGPointMake(70.96, 174.33) controlPoint1: CGPointMake(67.91, 173.74) controlPoint2: CGPointMake(69.3, 174.33)];
        [bezier26Path addCurveToPoint: CGPointMake(75, 172.57) controlPoint1: CGPointMake(72.58, 174.33) controlPoint2: CGPointMake(73.92, 173.74)];
        [bezier26Path addCurveToPoint: CGPointMake(76.66, 168.03) controlPoint1: CGPointMake(76.08, 171.39) controlPoint2: CGPointMake(76.66, 169.87)];
        [bezier26Path addCurveToPoint: CGPointMake(75.04, 163.54) controlPoint1: CGPointMake(76.66, 166.2) controlPoint2: CGPointMake(76.12, 164.71)];
        [bezier26Path addCurveToPoint: CGPointMake(70.96, 161.78) controlPoint1: CGPointMake(73.96, 162.37) controlPoint2: CGPointMake(72.61, 161.78)];
        [bezier26Path closePath];
        bezier26Path.miterLimit = 4;
        
        [UIColor.whiteColor setFill];
        [bezier26Path fill];
        
        
        //// Bezier 28 Drawing
        UIBezierPath* bezier28Path = UIBezierPath.bezierPath;
        [bezier28Path moveToPoint: CGPointMake(91.46, 157.41)];
        [bezier28Path addLineToPoint: CGPointMake(91.46, 159.75)];
        [bezier28Path addCurveToPoint: CGPointMake(94.54, 157.6) controlPoint1: CGPointMake(92.43, 158.77) controlPoint2: CGPointMake(93.43, 158.07)];
        [bezier28Path addCurveToPoint: CGPointMake(98.09, 156.9) controlPoint1: CGPointMake(95.66, 157.13) controlPoint2: CGPointMake(96.82, 156.9)];
        [bezier28Path addCurveToPoint: CGPointMake(105.07, 160.02) controlPoint1: CGPointMake(100.83, 156.9) controlPoint2: CGPointMake(103.14, 157.95)];
        [bezier28Path addCurveToPoint: CGPointMake(107.92, 168.07) controlPoint1: CGPointMake(106.99, 162.13) controlPoint2: CGPointMake(107.92, 164.79)];
        [bezier28Path addCurveToPoint: CGPointMake(104.95, 176.01) controlPoint1: CGPointMake(107.92, 171.24) controlPoint2: CGPointMake(106.92, 173.9)];
        [bezier28Path addCurveToPoint: CGPointMake(97.94, 179.21) controlPoint1: CGPointMake(102.99, 178.12) controlPoint2: CGPointMake(100.63, 179.21)];
        [bezier28Path addCurveToPoint: CGPointMake(94.58, 178.55) controlPoint1: CGPointMake(96.74, 179.21) controlPoint2: CGPointMake(95.62, 178.98)];
        [bezier28Path addCurveToPoint: CGPointMake(91.5, 176.4) controlPoint1: CGPointMake(93.54, 178.12) controlPoint2: CGPointMake(92.5, 177.41)];
        [bezier28Path addLineToPoint: CGPointMake(91.5, 186.4)];
        [bezier28Path addLineToPoint: CGPointMake(86.3, 186.4)];
        [bezier28Path addLineToPoint: CGPointMake(86.3, 157.37)];
        [bezier28Path addLineToPoint: CGPointMake(91.46, 157.37)];
        [bezier28Path addLineToPoint: CGPointMake(91.46, 157.41)];
        [bezier28Path closePath];
        [bezier28Path moveToPoint: CGPointMake(97.01, 161.78)];
        [bezier28Path addCurveToPoint: CGPointMake(92.89, 163.5) controlPoint1: CGPointMake(95.35, 161.78) controlPoint2: CGPointMake(93.97, 162.37)];
        [bezier28Path addCurveToPoint: CGPointMake(91.27, 168) controlPoint1: CGPointMake(91.81, 164.63) controlPoint2: CGPointMake(91.27, 166.16)];
        [bezier28Path addCurveToPoint: CGPointMake(92.89, 172.57) controlPoint1: CGPointMake(91.27, 169.87) controlPoint2: CGPointMake(91.81, 171.39)];
        [bezier28Path addCurveToPoint: CGPointMake(97.01, 174.33) controlPoint1: CGPointMake(93.97, 173.74) controlPoint2: CGPointMake(95.35, 174.33)];
        [bezier28Path addCurveToPoint: CGPointMake(101.06, 172.57) controlPoint1: CGPointMake(98.63, 174.33) controlPoint2: CGPointMake(99.98, 173.74)];
        [bezier28Path addCurveToPoint: CGPointMake(102.72, 168.03) controlPoint1: CGPointMake(102.14, 171.39) controlPoint2: CGPointMake(102.72, 169.87)];
        [bezier28Path addCurveToPoint: CGPointMake(101.1, 163.54) controlPoint1: CGPointMake(102.72, 166.2) controlPoint2: CGPointMake(102.18, 164.71)];
        [bezier28Path addCurveToPoint: CGPointMake(97.01, 161.78) controlPoint1: CGPointMake(100.02, 162.37) controlPoint2: CGPointMake(98.63, 161.78)];
        [bezier28Path closePath];
        bezier28Path.miterLimit = 4;
        
        [UIColor.whiteColor setFill];
        [bezier28Path fill];
        
        
        //// Bezier 30 Drawing
        UIBezierPath* bezier30Path = UIBezierPath.bezierPath;
        [bezier30Path moveToPoint: CGPointMake(127.73, 153.85)];
        [bezier30Path addLineToPoint: CGPointMake(123.72, 157.41)];
        [bezier30Path addCurveToPoint: CGPointMake(119.44, 154.44) controlPoint1: CGPointMake(122.33, 155.41) controlPoint2: CGPointMake(120.91, 154.44)];
        [bezier30Path addCurveToPoint: CGPointMake(117.71, 155.02) controlPoint1: CGPointMake(118.75, 154.44) controlPoint2: CGPointMake(118.17, 154.63)];
        [bezier30Path addCurveToPoint: CGPointMake(117.02, 156.31) controlPoint1: CGPointMake(117.25, 155.41) controlPoint2: CGPointMake(117.02, 155.84)];
        [bezier30Path addCurveToPoint: CGPointMake(117.52, 157.68) controlPoint1: CGPointMake(117.02, 156.78) controlPoint2: CGPointMake(117.17, 157.25)];
        [bezier30Path addCurveToPoint: CGPointMake(121.49, 161.35) controlPoint1: CGPointMake(117.94, 158.27) controlPoint2: CGPointMake(119.29, 159.48)];
        [bezier30Path addCurveToPoint: CGPointMake(125.23, 164.63) controlPoint1: CGPointMake(123.53, 163.11) controlPoint2: CGPointMake(124.8, 164.21)];
        [bezier30Path addCurveToPoint: CGPointMake(127.54, 167.84) controlPoint1: CGPointMake(126.3, 165.77) controlPoint2: CGPointMake(127.08, 166.82)];
        [bezier30Path addCurveToPoint: CGPointMake(128.23, 171.2) controlPoint1: CGPointMake(128, 168.86) controlPoint2: CGPointMake(128.23, 169.99)];
        [bezier30Path addCurveToPoint: CGPointMake(125.8, 177.02) controlPoint1: CGPointMake(128.23, 173.54) controlPoint2: CGPointMake(127.42, 175.5)];
        [bezier30Path addCurveToPoint: CGPointMake(119.52, 179.33) controlPoint1: CGPointMake(124.18, 178.55) controlPoint2: CGPointMake(122.1, 179.33)];
        [bezier30Path addCurveToPoint: CGPointMake(114.24, 177.84) controlPoint1: CGPointMake(117.52, 179.33) controlPoint2: CGPointMake(115.74, 178.82)];
        [bezier30Path addCurveToPoint: CGPointMake(110.39, 173.11) controlPoint1: CGPointMake(112.74, 176.83) controlPoint2: CGPointMake(111.47, 175.26)];
        [bezier30Path addLineToPoint: CGPointMake(114.93, 170.34)];
        [bezier30Path addCurveToPoint: CGPointMake(119.64, 174.13) controlPoint1: CGPointMake(116.28, 172.88) controlPoint2: CGPointMake(117.86, 174.13)];
        [bezier30Path addCurveToPoint: CGPointMake(121.99, 173.31) controlPoint1: CGPointMake(120.56, 174.13) controlPoint2: CGPointMake(121.33, 173.86)];
        [bezier30Path addCurveToPoint: CGPointMake(122.95, 171.43) controlPoint1: CGPointMake(122.6, 172.76) controlPoint2: CGPointMake(122.95, 172.14)];
        [bezier30Path addCurveToPoint: CGPointMake(122.22, 169.48) controlPoint1: CGPointMake(122.95, 170.77) controlPoint2: CGPointMake(122.72, 170.14)];
        [bezier30Path addCurveToPoint: CGPointMake(119.06, 166.51) controlPoint1: CGPointMake(121.76, 168.82) controlPoint2: CGPointMake(120.68, 167.84)];
        [bezier30Path addCurveToPoint: CGPointMake(113.08, 160.61) controlPoint1: CGPointMake(115.97, 163.97) controlPoint2: CGPointMake(113.97, 161.98)];
        [bezier30Path addCurveToPoint: CGPointMake(111.74, 156.47) controlPoint1: CGPointMake(112.2, 159.24) controlPoint2: CGPointMake(111.74, 157.84)];
        [bezier30Path addCurveToPoint: CGPointMake(113.97, 151.35) controlPoint1: CGPointMake(111.74, 154.48) controlPoint2: CGPointMake(112.47, 152.76)];
        [bezier30Path addCurveToPoint: CGPointMake(119.52, 149.2) controlPoint1: CGPointMake(115.47, 149.94) controlPoint2: CGPointMake(117.32, 149.2)];
        [bezier30Path addCurveToPoint: CGPointMake(123.57, 150.18) controlPoint1: CGPointMake(120.95, 149.2) controlPoint2: CGPointMake(122.3, 149.51)];
        [bezier30Path addCurveToPoint: CGPointMake(127.73, 153.85) controlPoint1: CGPointMake(124.88, 150.88) controlPoint2: CGPointMake(126.23, 152.09)];
        [bezier30Path closePath];
        bezier30Path.miterLimit = 4;
        
        [color1 setFill];
        [bezier30Path fill];
        
        
        //// Bezier 32 Drawing
        UIBezierPath* bezier32Path = UIBezierPath.bezierPath;
        [bezier32Path moveToPoint: CGPointMake(132.82, 157.41)];
        [bezier32Path addLineToPoint: CGPointMake(138.06, 157.41)];
        [bezier32Path addLineToPoint: CGPointMake(138.06, 159.59)];
        [bezier32Path addCurveToPoint: CGPointMake(141.3, 157.48) controlPoint1: CGPointMake(139.25, 158.58) controlPoint2: CGPointMake(140.33, 157.87)];
        [bezier32Path addCurveToPoint: CGPointMake(144.27, 156.9) controlPoint1: CGPointMake(142.26, 157.09) controlPoint2: CGPointMake(143.26, 156.9)];
        [bezier32Path addCurveToPoint: CGPointMake(149.55, 159.09) controlPoint1: CGPointMake(146.35, 156.9) controlPoint2: CGPointMake(148.12, 157.64)];
        [bezier32Path addCurveToPoint: CGPointMake(151.36, 164.63) controlPoint1: CGPointMake(150.78, 160.34) controlPoint2: CGPointMake(151.36, 162.17)];
        [bezier32Path addLineToPoint: CGPointMake(151.36, 178.66)];
        [bezier32Path addLineToPoint: CGPointMake(146.15, 178.66)];
        [bezier32Path addLineToPoint: CGPointMake(146.15, 169.36)];
        [bezier32Path addCurveToPoint: CGPointMake(145.81, 164.32) controlPoint1: CGPointMake(146.15, 166.82) controlPoint2: CGPointMake(146.04, 165.14)];
        [bezier32Path addCurveToPoint: CGPointMake(144.65, 162.41) controlPoint1: CGPointMake(145.58, 163.5) controlPoint2: CGPointMake(145.19, 162.84)];
        [bezier32Path addCurveToPoint: CGPointMake(142.57, 161.74) controlPoint1: CGPointMake(144.11, 161.98) controlPoint2: CGPointMake(143.42, 161.74)];
        [bezier32Path addCurveToPoint: CGPointMake(139.83, 162.84) controlPoint1: CGPointMake(141.49, 161.74) controlPoint2: CGPointMake(140.6, 162.09)];
        [bezier32Path addCurveToPoint: CGPointMake(138.25, 165.85) controlPoint1: CGPointMake(139.06, 163.54) controlPoint2: CGPointMake(138.56, 164.56)];
        [bezier32Path addCurveToPoint: CGPointMake(138.02, 170.14) controlPoint1: CGPointMake(138.1, 166.51) controlPoint2: CGPointMake(138.02, 167.96)];
        [bezier32Path addLineToPoint: CGPointMake(138.02, 178.66)];
        [bezier32Path addLineToPoint: CGPointMake(132.82, 178.66)];
        [bezier32Path addLineToPoint: CGPointMake(132.82, 157.41)];
        [bezier32Path closePath];
        bezier32Path.miterLimit = 4;
        
        [UIColor.whiteColor setFill];
        [bezier32Path fill];
        
        
        //// Bezier 34 Drawing
        UIBezierPath* bezier34Path = UIBezierPath.bezierPath;
        [bezier34Path moveToPoint: CGPointMake(171.94, 157.41)];
        [bezier34Path addLineToPoint: CGPointMake(177.18, 157.41)];
        [bezier34Path addLineToPoint: CGPointMake(177.18, 178.66)];
        [bezier34Path addLineToPoint: CGPointMake(171.94, 178.66)];
        [bezier34Path addLineToPoint: CGPointMake(171.94, 176.44)];
        [bezier34Path addCurveToPoint: CGPointMake(168.86, 178.58) controlPoint1: CGPointMake(170.9, 177.41) controlPoint2: CGPointMake(169.9, 178.16)];
        [bezier34Path addCurveToPoint: CGPointMake(165.5, 179.25) controlPoint1: CGPointMake(167.82, 179.01) controlPoint2: CGPointMake(166.7, 179.25)];
        [bezier34Path addCurveToPoint: CGPointMake(158.49, 176.04) controlPoint1: CGPointMake(162.8, 179.25) controlPoint2: CGPointMake(160.45, 178.19)];
        [bezier34Path addCurveToPoint: CGPointMake(155.52, 168.11) controlPoint1: CGPointMake(156.52, 173.93) controlPoint2: CGPointMake(155.52, 171.28)];
        [bezier34Path addCurveToPoint: CGPointMake(158.37, 160.06) controlPoint1: CGPointMake(155.52, 164.83) controlPoint2: CGPointMake(156.48, 162.13)];
        [bezier34Path addCurveToPoint: CGPointMake(165.35, 156.94) controlPoint1: CGPointMake(160.3, 157.95) controlPoint2: CGPointMake(162.61, 156.94)];
        [bezier34Path addCurveToPoint: CGPointMake(168.89, 157.64) controlPoint1: CGPointMake(166.62, 156.94) controlPoint2: CGPointMake(167.78, 157.17)];
        [bezier34Path addCurveToPoint: CGPointMake(171.94, 159.79) controlPoint1: CGPointMake(170.01, 158.11) controlPoint2: CGPointMake(171.01, 158.85)];
        [bezier34Path addLineToPoint: CGPointMake(171.94, 157.41)];
        [bezier34Path closePath];
        [bezier34Path moveToPoint: CGPointMake(166.43, 161.78)];
        [bezier34Path addCurveToPoint: CGPointMake(162.38, 163.54) controlPoint1: CGPointMake(164.81, 161.78) controlPoint2: CGPointMake(163.46, 162.37)];
        [bezier34Path addCurveToPoint: CGPointMake(160.76, 168.03) controlPoint1: CGPointMake(161.3, 164.71) controlPoint2: CGPointMake(160.76, 166.2)];
        [bezier34Path addCurveToPoint: CGPointMake(162.42, 172.57) controlPoint1: CGPointMake(160.76, 169.87) controlPoint2: CGPointMake(161.3, 171.39)];
        [bezier34Path addCurveToPoint: CGPointMake(166.47, 174.33) controlPoint1: CGPointMake(163.5, 173.74) controlPoint2: CGPointMake(164.85, 174.33)];
        [bezier34Path addCurveToPoint: CGPointMake(170.59, 172.57) controlPoint1: CGPointMake(168.12, 174.33) controlPoint2: CGPointMake(169.47, 173.74)];
        [bezier34Path addCurveToPoint: CGPointMake(172.21, 168) controlPoint1: CGPointMake(171.67, 171.39) controlPoint2: CGPointMake(172.21, 169.87)];
        [bezier34Path addCurveToPoint: CGPointMake(170.59, 163.5) controlPoint1: CGPointMake(172.21, 166.16) controlPoint2: CGPointMake(171.67, 164.63)];
        [bezier34Path addCurveToPoint: CGPointMake(166.43, 161.78) controlPoint1: CGPointMake(169.43, 162.37) controlPoint2: CGPointMake(168.09, 161.78)];
        [bezier34Path closePath];
        bezier34Path.miterLimit = 4;
        
        [UIColor.whiteColor setFill];
        [bezier34Path fill];
        
        
        //// Bezier 36 Drawing
        UIBezierPath* bezier36Path = UIBezierPath.bezierPath;
        [bezier36Path moveToPoint: CGPointMake(187.74, 157.41)];
        [bezier36Path addLineToPoint: CGPointMake(187.74, 159.75)];
        [bezier36Path addCurveToPoint: CGPointMake(190.83, 157.6) controlPoint1: CGPointMake(188.71, 158.77) controlPoint2: CGPointMake(189.71, 158.07)];
        [bezier36Path addCurveToPoint: CGPointMake(194.37, 156.9) controlPoint1: CGPointMake(191.94, 157.13) controlPoint2: CGPointMake(193.1, 156.9)];
        [bezier36Path addCurveToPoint: CGPointMake(201.35, 160.02) controlPoint1: CGPointMake(197.11, 156.9) controlPoint2: CGPointMake(199.42, 157.95)];
        [bezier36Path addCurveToPoint: CGPointMake(204.2, 168.07) controlPoint1: CGPointMake(203.27, 162.13) controlPoint2: CGPointMake(204.2, 164.79)];
        [bezier36Path addCurveToPoint: CGPointMake(201.23, 176.01) controlPoint1: CGPointMake(204.2, 171.24) controlPoint2: CGPointMake(203.2, 173.9)];
        [bezier36Path addCurveToPoint: CGPointMake(194.22, 179.21) controlPoint1: CGPointMake(199.27, 178.12) controlPoint2: CGPointMake(196.92, 179.21)];
        [bezier36Path addCurveToPoint: CGPointMake(190.86, 178.55) controlPoint1: CGPointMake(193.02, 179.21) controlPoint2: CGPointMake(191.9, 178.98)];
        [bezier36Path addCurveToPoint: CGPointMake(187.78, 176.4) controlPoint1: CGPointMake(189.82, 178.12) controlPoint2: CGPointMake(188.78, 177.41)];
        [bezier36Path addLineToPoint: CGPointMake(187.78, 186.4)];
        [bezier36Path addLineToPoint: CGPointMake(182.58, 186.4)];
        [bezier36Path addLineToPoint: CGPointMake(182.58, 157.37)];
        [bezier36Path addLineToPoint: CGPointMake(187.74, 157.37)];
        [bezier36Path addLineToPoint: CGPointMake(187.74, 157.41)];
        [bezier36Path closePath];
        [bezier36Path moveToPoint: CGPointMake(193.25, 161.78)];
        [bezier36Path addCurveToPoint: CGPointMake(189.13, 163.5) controlPoint1: CGPointMake(191.6, 161.78) controlPoint2: CGPointMake(190.21, 162.37)];
        [bezier36Path addCurveToPoint: CGPointMake(187.51, 168) controlPoint1: CGPointMake(188.05, 164.63) controlPoint2: CGPointMake(187.51, 166.16)];
        [bezier36Path addCurveToPoint: CGPointMake(189.13, 172.57) controlPoint1: CGPointMake(187.51, 169.87) controlPoint2: CGPointMake(188.05, 171.39)];
        [bezier36Path addCurveToPoint: CGPointMake(193.25, 174.33) controlPoint1: CGPointMake(190.21, 173.74) controlPoint2: CGPointMake(191.6, 174.33)];
        [bezier36Path addCurveToPoint: CGPointMake(197.3, 172.57) controlPoint1: CGPointMake(194.87, 174.33) controlPoint2: CGPointMake(196.22, 173.74)];
        [bezier36Path addCurveToPoint: CGPointMake(198.96, 168.03) controlPoint1: CGPointMake(198.38, 171.39) controlPoint2: CGPointMake(198.96, 169.87)];
        [bezier36Path addCurveToPoint: CGPointMake(197.34, 163.54) controlPoint1: CGPointMake(198.96, 166.2) controlPoint2: CGPointMake(198.42, 164.71)];
        [bezier36Path addCurveToPoint: CGPointMake(193.25, 161.78) controlPoint1: CGPointMake(196.26, 162.37) controlPoint2: CGPointMake(194.91, 161.78)];
        [bezier36Path closePath];
        bezier36Path.miterLimit = 4;
        
        [UIColor.whiteColor setFill];
        [bezier36Path fill];
    }
    
    
    //// Bezier 38 Drawing
    UIBezierPath* bezier38Path = UIBezierPath.bezierPath;
    [bezier38Path moveToPoint: CGPointMake(136.13, 97.11)];
    [bezier38Path addLineToPoint: CGPointMake(124.72, 97.11)];
    [bezier38Path addCurveToPoint: CGPointMake(121.91, 100.96) controlPoint1: CGPointMake(123.8, 98.42) controlPoint2: CGPointMake(122.84, 99.69)];
    [bezier38Path addLineToPoint: CGPointMake(127.5, 114.23)];
    [bezier38Path addLineToPoint: CGPointMake(148.08, 114.23)];
    [bezier38Path addLineToPoint: CGPointMake(136.13, 97.11)];
    [bezier38Path closePath];
    bezier38Path.miterLimit = 4;
    
    [color0 setFill];
    [bezier38Path fill];
    
    
    //// Group 4
    {
        //// Bezier 40 Drawing
        UIBezierPath* bezier40Path = UIBezierPath.bezierPath;
        [bezier40Path moveToPoint: CGPointMake(85.8, 96.9)];
        [bezier40Path addLineToPoint: CGPointMake(72.15, 96.9)];
        [bezier40Path addLineToPoint: CGPointMake(59.8, 114.2)];
        [bezier40Path addLineToPoint: CGPointMake(100, 114.2)];
        [bezier40Path addCurveToPoint: CGPointMake(85.8, 96.9) controlPoint1: CGPointMake(95.04, 109.05) controlPoint2: CGPointMake(90.28, 103.11)];
        [bezier40Path closePath];
        bezier40Path.miterLimit = 4;
        
        [color1 setFill];
        [bezier40Path fill];
    }
    
    
    //// Bezier 42 Drawing
    UIBezierPath* bezier42Path = UIBezierPath.bezierPath;
    [bezier42Path moveToPoint: CGPointMake(110.81, 114.23)];
    [bezier42Path addLineToPoint: CGPointMake(116.63, 114.23)];
    [bezier42Path addLineToPoint: CGPointMake(115.09, 109.49)];
    [bezier42Path addCurveToPoint: CGPointMake(110.81, 114.23) controlPoint1: CGPointMake(113.66, 111.11) controlPoint2: CGPointMake(112.24, 112.69)];
    [bezier42Path closePath];
    bezier42Path.miterLimit = 4;
    
    [color1 setFill];
    [bezier42Path fill];
    
    
    //// Bezier 44 Drawing
    UIBezierPath* bezier44Path = UIBezierPath.bezierPath;
    [bezier44Path moveToPoint: CGPointMake(114.66, 123.57)];
    [bezier44Path addCurveToPoint: CGPointMake(105.22, 125.53) controlPoint1: CGPointMake(114.66, 124.65) controlPoint2: CGPointMake(110.42, 125.53)];
    [bezier44Path addCurveToPoint: CGPointMake(95.78, 123.57) controlPoint1: CGPointMake(100.02, 125.53) controlPoint2: CGPointMake(95.78, 124.65)];
    [bezier44Path addCurveToPoint: CGPointMake(105.22, 121.6) controlPoint1: CGPointMake(95.78, 122.49) controlPoint2: CGPointMake(100.02, 121.6)];
    [bezier44Path addCurveToPoint: CGPointMake(114.66, 123.57) controlPoint1: CGPointMake(110.42, 121.6) controlPoint2: CGPointMake(114.66, 122.49)];
    [bezier44Path closePath];
    bezier44Path.miterLimit = 4;
    
    [color3 setFill];
    [bezier44Path fill];
}

@end
