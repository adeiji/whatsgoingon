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
    // Clear the rectangle
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, rect);
    
    //// Color Declarations
    UIColor* color2 = [UIColor colorWithRed: 0.936 green: 0.936 blue: 0.936 alpha: 1];
    
    //// Group
    {
        //// Bezier 2 Drawing
        UIBezierPath* bezier2Path = UIBezierPath.bezierPath;
        [bezier2Path moveToPoint: CGPointMake(4.2, 6.97)];
        [bezier2Path addCurveToPoint: CGPointMake(5.42, 6) controlPoint1: CGPointMake(4.2, 6.39) controlPoint2: CGPointMake(4.69, 6)];
        [bezier2Path addLineToPoint: CGPointMake(26.15, 6)];
        [bezier2Path addCurveToPoint: CGPointMake(27.28, 6.78) controlPoint1: CGPointMake(26.88, 6) controlPoint2: CGPointMake(27.28, 6.29)];
        [bezier2Path addLineToPoint: CGPointMake(27.28, 32.28)];
        [bezier2Path addCurveToPoint: CGPointMake(28.16, 32.96) controlPoint1: CGPointMake(27.28, 32.67) controlPoint2: CGPointMake(27.67, 32.96)];
        [bezier2Path addLineToPoint: CGPointMake(30.61, 32.96)];
        [bezier2Path addCurveToPoint: CGPointMake(31.73, 32.28) controlPoint1: CGPointMake(31.24, 32.96) controlPoint2: CGPointMake(31.73, 32.57)];
        [bezier2Path addLineToPoint: CGPointMake(31.73, 6.88)];
        [bezier2Path addCurveToPoint: CGPointMake(32.71, 6) controlPoint1: CGPointMake(31.73, 6.39) controlPoint2: CGPointMake(32.13, 6)];
        [bezier2Path addLineToPoint: CGPointMake(53.59, 6)];
        [bezier2Path addCurveToPoint: CGPointMake(54.81, 6.88) controlPoint1: CGPointMake(54.32, 6) controlPoint2: CGPointMake(54.81, 6.39)];
        [bezier2Path addLineToPoint: CGPointMake(54.81, 77.93)];
        [bezier2Path addCurveToPoint: CGPointMake(53.83, 79) controlPoint1: CGPointMake(54.81, 78.42) controlPoint2: CGPointMake(54.42, 79)];
        [bezier2Path addLineToPoint: CGPointMake(32.86, 79)];
        [bezier2Path addCurveToPoint: CGPointMake(31.73, 77.93) controlPoint1: CGPointMake(32.22, 79) controlPoint2: CGPointMake(31.73, 78.42)];
        [bezier2Path addLineToPoint: CGPointMake(31.73, 52.53)];
        [bezier2Path addCurveToPoint: CGPointMake(31, 51.75) controlPoint1: CGPointMake(31.73, 52.14) controlPoint2: CGPointMake(31.49, 51.75)];
        [bezier2Path addLineToPoint: CGPointMake(28.16, 51.75)];
        [bezier2Path addCurveToPoint: CGPointMake(27.28, 52.53) controlPoint1: CGPointMake(27.52, 51.75) controlPoint2: CGPointMake(27.28, 52.14)];
        [bezier2Path addLineToPoint: CGPointMake(27.28, 78.03)];
        [bezier2Path addCurveToPoint: CGPointMake(26.15, 79) controlPoint1: CGPointMake(27.28, 78.51) controlPoint2: CGPointMake(26.79, 79)];
        [bezier2Path addLineToPoint: CGPointMake(5.82, 79)];
        [bezier2Path addCurveToPoint: CGPointMake(4.2, 77.54) controlPoint1: CGPointMake(4.93, 79) controlPoint2: CGPointMake(4.2, 78.32)];
        [bezier2Path addLineToPoint: CGPointMake(4.2, 6.97)];
        [bezier2Path closePath];
        bezier2Path.miterLimit = 4;
        
        [color2 setStroke];
        bezier2Path.lineWidth = 4;
        [bezier2Path stroke];
        
        
        //// Bezier 4 Drawing
        UIBezierPath* bezier4Path = UIBezierPath.bezierPath;
        [bezier4Path moveToPoint: CGPointMake(96.31, 6)];
        [bezier4Path addCurveToPoint: CGPointMake(97.92, 7.27) controlPoint1: CGPointMake(97.19, 6) controlPoint2: CGPointMake(97.78, 6.58)];
        [bezier4Path addLineToPoint: CGPointMake(114.83, 76.86)];
        [bezier4Path addCurveToPoint: CGPointMake(113.11, 79) controlPoint1: CGPointMake(115.07, 77.93) controlPoint2: CGPointMake(114.43, 79)];
        [bezier4Path addLineToPoint: CGPointMake(93.12, 79)];
        [bezier4Path addCurveToPoint: CGPointMake(91.51, 78.03) controlPoint1: CGPointMake(92.39, 79) controlPoint2: CGPointMake(91.65, 78.61)];
        [bezier4Path addLineToPoint: CGPointMake(89.06, 63.43)];
        [bezier4Path addCurveToPoint: CGPointMake(87.83, 62.65) controlPoint1: CGPointMake(88.91, 62.94) controlPoint2: CGPointMake(88.42, 62.65)];
        [bezier4Path addLineToPoint: CGPointMake(81.17, 62.65)];
        [bezier4Path addCurveToPoint: CGPointMake(80.04, 63.62) controlPoint1: CGPointMake(80.68, 62.65) controlPoint2: CGPointMake(80.19, 63.04)];
        [bezier4Path addLineToPoint: CGPointMake(77.69, 77.93)];
        [bezier4Path addCurveToPoint: CGPointMake(76.07, 79) controlPoint1: CGPointMake(77.54, 78.61) controlPoint2: CGPointMake(76.71, 79)];
        [bezier4Path addLineToPoint: CGPointMake(55.69, 79)];
        [bezier4Path addCurveToPoint: CGPointMake(54.22, 77.35) controlPoint1: CGPointMake(54.57, 79) controlPoint2: CGPointMake(53.98, 78.32)];
        [bezier4Path addLineToPoint: CGPointMake(70.78, 7.17)];
        [bezier4Path addCurveToPoint: CGPointMake(72.25, 6) controlPoint1: CGPointMake(70.93, 6.68) controlPoint2: CGPointMake(71.52, 6)];
        [bezier4Path addLineToPoint: CGPointMake(96.31, 6)];
        [bezier4Path closePath];
        [bezier4Path moveToPoint: CGPointMake(85.48, 42.69)];
        [bezier4Path addCurveToPoint: CGPointMake(84.6, 40.46) controlPoint1: CGPointMake(85.23, 41.33) controlPoint2: CGPointMake(84.99, 40.46)];
        [bezier4Path addCurveToPoint: CGPointMake(83.72, 42.69) controlPoint1: CGPointMake(84.21, 40.46) controlPoint2: CGPointMake(83.96, 41.14)];
        [bezier4Path addLineToPoint: CGPointMake(82.1, 51.94)];
        [bezier4Path addCurveToPoint: CGPointMake(82.83, 52.91) controlPoint1: CGPointMake(81.95, 52.43) controlPoint2: CGPointMake(82.25, 52.91)];
        [bezier4Path addCurveToPoint: CGPointMake(87.05, 52.04) controlPoint1: CGPointMake(86.8, 52.91) controlPoint2: CGPointMake(87.15, 52.91)];
        [bezier4Path addLineToPoint: CGPointMake(85.48, 42.69)];
        [bezier4Path closePath];
        bezier4Path.miterLimit = 4;
        
        [color2 setStroke];
        bezier4Path.lineWidth = 4;
        [bezier4Path stroke];
        
        
        //// Bezier 6 Drawing
        UIBezierPath* bezier6Path = UIBezierPath.bezierPath;
        [bezier6Path moveToPoint: CGPointMake(114.34, 7.65)];
        [bezier6Path addCurveToPoint: CGPointMake(116.05, 6) controlPoint1: CGPointMake(114.34, 6.68) controlPoint2: CGPointMake(114.97, 6)];
        [bezier6Path addLineToPoint: CGPointMake(144.81, 6)];
        [bezier6Path addCurveToPoint: CGPointMake(168.77, 27.61) controlPoint1: CGPointMake(150.49, 6) controlPoint2: CGPointMake(168.77, 9.21)];
        [bezier6Path addCurveToPoint: CGPointMake(146.67, 45.61) controlPoint1: CGPointMake(168.77, 36.66) controlPoint2: CGPointMake(158.53, 45.61)];
        [bezier6Path addCurveToPoint: CGPointMake(140.01, 46.78) controlPoint1: CGPointMake(140.65, 45.61) controlPoint2: CGPointMake(140.01, 45.61)];
        [bezier6Path addLineToPoint: CGPointMake(140.01, 77.64)];
        [bezier6Path addCurveToPoint: CGPointMake(137.9, 79) controlPoint1: CGPointMake(140.01, 78.42) controlPoint2: CGPointMake(139.27, 79)];
        [bezier6Path addLineToPoint: CGPointMake(116.3, 79)];
        [bezier6Path addCurveToPoint: CGPointMake(114.34, 77.25) controlPoint1: CGPointMake(115.17, 79) controlPoint2: CGPointMake(114.34, 78.22)];
        [bezier6Path addLineToPoint: CGPointMake(114.34, 7.65)];
        [bezier6Path closePath];
        [bezier6Path moveToPoint: CGPointMake(140.01, 33.06)];
        [bezier6Path addCurveToPoint: CGPointMake(141.23, 34.13) controlPoint1: CGPointMake(140.01, 33.45) controlPoint2: CGPointMake(140.4, 34.13)];
        [bezier6Path addCurveToPoint: CGPointMake(143.83, 30.92) controlPoint1: CGPointMake(143.1, 34.13) controlPoint2: CGPointMake(143.83, 32.86)];
        [bezier6Path addLineToPoint: CGPointMake(143.83, 26.93)];
        [bezier6Path addCurveToPoint: CGPointMake(141.23, 24.3) controlPoint1: CGPointMake(143.83, 25.37) controlPoint2: CGPointMake(142.85, 24.3)];
        [bezier6Path addCurveToPoint: CGPointMake(140.35, 24.4) controlPoint1: CGPointMake(140.84, 24.3) controlPoint2: CGPointMake(140.6, 24.3)];
        [bezier6Path addCurveToPoint: CGPointMake(139.96, 25.17) controlPoint1: CGPointMake(140.11, 24.49) controlPoint2: CGPointMake(139.96, 24.88)];
        [bezier6Path addLineToPoint: CGPointMake(139.96, 33.06)];
        [bezier6Path addLineToPoint: CGPointMake(140.01, 33.06)];
        [bezier6Path closePath];
        bezier6Path.miterLimit = 4;
        
        [color2 setStroke];
        bezier6Path.lineWidth = 4;
        [bezier6Path stroke];
        
        
        //// Bezier 8 Drawing
        UIBezierPath* bezier8Path = UIBezierPath.bezierPath;
        [bezier8Path moveToPoint: CGPointMake(168.77, 7.65)];
        [bezier8Path addCurveToPoint: CGPointMake(170.48, 6) controlPoint1: CGPointMake(168.77, 6.68) controlPoint2: CGPointMake(169.41, 6)];
        [bezier8Path addLineToPoint: CGPointMake(199.24, 6)];
        [bezier8Path addCurveToPoint: CGPointMake(223.2, 27.61) controlPoint1: CGPointMake(204.93, 6) controlPoint2: CGPointMake(223.2, 9.21)];
        [bezier8Path addCurveToPoint: CGPointMake(201.1, 45.61) controlPoint1: CGPointMake(223.2, 36.66) controlPoint2: CGPointMake(212.96, 45.61)];
        [bezier8Path addCurveToPoint: CGPointMake(194.44, 46.78) controlPoint1: CGPointMake(195.08, 45.61) controlPoint2: CGPointMake(194.44, 45.61)];
        [bezier8Path addLineToPoint: CGPointMake(194.44, 77.64)];
        [bezier8Path addCurveToPoint: CGPointMake(192.33, 79) controlPoint1: CGPointMake(194.44, 78.42) controlPoint2: CGPointMake(193.71, 79)];
        [bezier8Path addLineToPoint: CGPointMake(170.73, 79)];
        [bezier8Path addCurveToPoint: CGPointMake(168.77, 77.25) controlPoint1: CGPointMake(169.6, 79) controlPoint2: CGPointMake(168.77, 78.22)];
        [bezier8Path addLineToPoint: CGPointMake(168.77, 7.65)];
        [bezier8Path closePath];
        [bezier8Path moveToPoint: CGPointMake(194.49, 33.06)];
        [bezier8Path addCurveToPoint: CGPointMake(195.71, 34.13) controlPoint1: CGPointMake(194.49, 33.45) controlPoint2: CGPointMake(194.88, 34.13)];
        [bezier8Path addCurveToPoint: CGPointMake(198.31, 30.92) controlPoint1: CGPointMake(197.58, 34.13) controlPoint2: CGPointMake(198.31, 32.86)];
        [bezier8Path addLineToPoint: CGPointMake(198.31, 26.93)];
        [bezier8Path addCurveToPoint: CGPointMake(195.71, 24.3) controlPoint1: CGPointMake(198.31, 25.37) controlPoint2: CGPointMake(197.33, 24.3)];
        [bezier8Path addCurveToPoint: CGPointMake(194.83, 24.4) controlPoint1: CGPointMake(195.32, 24.3) controlPoint2: CGPointMake(195.08, 24.3)];
        [bezier8Path addCurveToPoint: CGPointMake(194.44, 25.17) controlPoint1: CGPointMake(194.59, 24.49) controlPoint2: CGPointMake(194.44, 24.88)];
        [bezier8Path addLineToPoint: CGPointMake(194.44, 33.06)];
        [bezier8Path addLineToPoint: CGPointMake(194.49, 33.06)];
        [bezier8Path closePath];
        bezier8Path.miterLimit = 4;
        
        [color2 setStroke];
        bezier8Path.lineWidth = 4;
        [bezier8Path stroke];
    }
    
    
    //// Group 2
    {
        //// Bezier 10 Drawing
        UIBezierPath* bezier10Path = UIBezierPath.bezierPath;
        [bezier10Path moveToPoint: CGPointMake(30.1, 104.19)];
        [bezier10Path addCurveToPoint: CGPointMake(28.94, 103.13) controlPoint1: CGPointMake(29.52, 104.19) controlPoint2: CGPointMake(29.13, 103.9)];
        [bezier10Path addCurveToPoint: CGPointMake(26.02, 99.65) controlPoint1: CGPointMake(28.35, 100.81) controlPoint2: CGPointMake(27.38, 99.65)];
        [bezier10Path addCurveToPoint: CGPointMake(24.57, 101.39) controlPoint1: CGPointMake(25.05, 99.65) controlPoint2: CGPointMake(24.57, 100.42)];
        [bezier10Path addCurveToPoint: CGPointMake(34.95, 111.93) controlPoint1: CGPointMake(24.57, 104.48) controlPoint2: CGPointMake(29.13, 107.96)];
        [bezier10Path addCurveToPoint: CGPointMake(46.01, 130.3) controlPoint1: CGPointMake(41.26, 116.18) controlPoint2: CGPointMake(46.01, 123.14)];
        [bezier10Path addCurveToPoint: CGPointMake(25.54, 153.6) controlPoint1: CGPointMake(46.01, 143.25) controlPoint2: CGPointMake(38.25, 153.6)];
        [bezier10Path addCurveToPoint: CGPointMake(4, 127.49) controlPoint1: CGPointMake(10.79, 153.6) controlPoint2: CGPointMake(4, 142.96)];
        [bezier10Path addCurveToPoint: CGPointMake(5.16, 126.53) controlPoint1: CGPointMake(4, 127.01) controlPoint2: CGPointMake(4.39, 126.53)];
        [bezier10Path addLineToPoint: CGPointMake(18.55, 125.85)];
        [bezier10Path addCurveToPoint: CGPointMake(19.72, 127.11) controlPoint1: CGPointMake(19.23, 125.85) controlPoint2: CGPointMake(19.62, 126.24)];
        [bezier10Path addCurveToPoint: CGPointMake(24.08, 135.13) controlPoint1: CGPointMake(20.11, 130.97) controlPoint2: CGPointMake(21.76, 135.13)];
        [bezier10Path addCurveToPoint: CGPointMake(26.32, 132.04) controlPoint1: CGPointMake(25.44, 135.13) controlPoint2: CGPointMake(26.32, 134.26)];
        [bezier10Path addCurveToPoint: CGPointMake(14.38, 120.24) controlPoint1: CGPointMake(26.32, 129.72) controlPoint2: CGPointMake(20.88, 125.46)];
        [bezier10Path addCurveToPoint: CGPointMake(4.68, 101.19) controlPoint1: CGPointMake(7.88, 115.02) controlPoint2: CGPointMake(4.68, 107.77)];
        [bezier10Path addCurveToPoint: CGPointMake(25.05, 80.6) controlPoint1: CGPointMake(4.68, 91.33) controlPoint2: CGPointMake(12.05, 80.6)];
        [bezier10Path addCurveToPoint: CGPointMake(46.11, 102.26) controlPoint1: CGPointMake(38.06, 80.6) controlPoint2: CGPointMake(46.11, 90.75)];
        [bezier10Path addCurveToPoint: CGPointMake(44.95, 103.52) controlPoint1: CGPointMake(46.11, 102.94) controlPoint2: CGPointMake(45.72, 103.52)];
        [bezier10Path addLineToPoint: CGPointMake(30.1, 104.19)];
        [bezier10Path closePath];
        bezier10Path.miterLimit = 4;
        
        [color2 setStroke];
        bezier10Path.lineWidth = 4;
        [bezier10Path stroke];
        
        
        //// Bezier 12 Drawing
        UIBezierPath* bezier12Path = UIBezierPath.bezierPath;
        [bezier12Path moveToPoint: CGPointMake(47.08, 82.05)];
        [bezier12Path addCurveToPoint: CGPointMake(48.15, 80.79) controlPoint1: CGPointMake(47.08, 81.37) controlPoint2: CGPointMake(47.56, 80.79)];
        [bezier12Path addLineToPoint: CGPointMake(64.54, 80.79)];
        [bezier12Path addCurveToPoint: CGPointMake(65.9, 81.95) controlPoint1: CGPointMake(65.22, 80.79) controlPoint2: CGPointMake(65.71, 81.18)];
        [bezier12Path addLineToPoint: CGPointMake(71.72, 103.71)];
        [bezier12Path addCurveToPoint: CGPointMake(72.4, 104.87) controlPoint1: CGPointMake(71.92, 104.48) controlPoint2: CGPointMake(72.21, 104.87)];
        [bezier12Path addCurveToPoint: CGPointMake(72.99, 103.61) controlPoint1: CGPointMake(72.69, 104.87) controlPoint2: CGPointMake(72.99, 104.48)];
        [bezier12Path addLineToPoint: CGPointMake(72.99, 82.05)];
        [bezier12Path addCurveToPoint: CGPointMake(74.15, 80.79) controlPoint1: CGPointMake(72.99, 81.37) controlPoint2: CGPointMake(73.47, 80.79)];
        [bezier12Path addLineToPoint: CGPointMake(88.7, 80.79)];
        [bezier12Path addCurveToPoint: CGPointMake(89.97, 82.15) controlPoint1: CGPointMake(89.48, 80.79) controlPoint2: CGPointMake(89.97, 81.47)];
        [bezier12Path addLineToPoint: CGPointMake(89.97, 152.05)];
        [bezier12Path addCurveToPoint: CGPointMake(88.9, 153.31) controlPoint1: CGPointMake(89.97, 152.73) controlPoint2: CGPointMake(89.58, 153.31)];
        [bezier12Path addLineToPoint: CGPointMake(70.75, 153.31)];
        [bezier12Path addCurveToPoint: CGPointMake(69.69, 152.34) controlPoint1: CGPointMake(70.37, 153.31) controlPoint2: CGPointMake(69.78, 152.92)];
        [bezier12Path addLineToPoint: CGPointMake(65.42, 134.94)];
        [bezier12Path addCurveToPoint: CGPointMake(64.54, 133.59) controlPoint1: CGPointMake(65.22, 133.97) controlPoint2: CGPointMake(64.84, 133.59)];
        [bezier12Path addCurveToPoint: CGPointMake(64.06, 134.94) controlPoint1: CGPointMake(64.25, 133.59) controlPoint2: CGPointMake(64.06, 133.97)];
        [bezier12Path addLineToPoint: CGPointMake(64.06, 152.05)];
        [bezier12Path addCurveToPoint: CGPointMake(62.8, 153.31) controlPoint1: CGPointMake(64.06, 152.73) controlPoint2: CGPointMake(63.48, 153.31)];
        [bezier12Path addLineToPoint: CGPointMake(48.05, 153.31)];
        [bezier12Path addCurveToPoint: CGPointMake(47.08, 151.96) controlPoint1: CGPointMake(47.47, 153.31) controlPoint2: CGPointMake(47.08, 152.73)];
        [bezier12Path addLineToPoint: CGPointMake(47.08, 82.05)];
        [bezier12Path closePath];
        bezier12Path.miterLimit = 4;
        
        [color2 setStroke];
        bezier12Path.lineWidth = 4;
        [bezier12Path stroke];
        
        
        //// Bezier 14 Drawing
        UIBezierPath* bezier14Path = UIBezierPath.bezierPath;
        [bezier14Path moveToPoint: CGPointMake(122.66, 80.79)];
        [bezier14Path addCurveToPoint: CGPointMake(123.92, 82.05) controlPoint1: CGPointMake(123.34, 80.79) controlPoint2: CGPointMake(123.83, 81.37)];
        [bezier14Path addLineToPoint: CGPointMake(137.22, 151.18)];
        [bezier14Path addCurveToPoint: CGPointMake(135.86, 153.31) controlPoint1: CGPointMake(137.41, 152.25) controlPoint2: CGPointMake(136.93, 153.31)];
        [bezier14Path addLineToPoint: CGPointMake(120.14, 153.31)];
        [bezier14Path addCurveToPoint: CGPointMake(118.88, 152.34) controlPoint1: CGPointMake(119.56, 153.31) controlPoint2: CGPointMake(118.98, 152.92)];
        [bezier14Path addLineToPoint: CGPointMake(116.94, 137.84)];
        [bezier14Path addCurveToPoint: CGPointMake(115.97, 137.07) controlPoint1: CGPointMake(116.84, 137.36) controlPoint2: CGPointMake(116.45, 137.07)];
        [bezier14Path addLineToPoint: CGPointMake(110.73, 137.07)];
        [bezier14Path addCurveToPoint: CGPointMake(109.86, 138.03) controlPoint1: CGPointMake(110.34, 137.07) controlPoint2: CGPointMake(109.95, 137.45)];
        [bezier14Path addLineToPoint: CGPointMake(108.01, 152.25)];
        [bezier14Path addCurveToPoint: CGPointMake(106.75, 153.31) controlPoint1: CGPointMake(107.92, 152.92) controlPoint2: CGPointMake(107.24, 153.31)];
        [bezier14Path addLineToPoint: CGPointMake(90.74, 153.31)];
        [bezier14Path addCurveToPoint: CGPointMake(89.58, 151.67) controlPoint1: CGPointMake(89.87, 153.31) controlPoint2: CGPointMake(89.38, 152.63)];
        [bezier14Path addLineToPoint: CGPointMake(102.58, 81.95)];
        [bezier14Path addCurveToPoint: CGPointMake(103.74, 80.79) controlPoint1: CGPointMake(102.68, 81.47) controlPoint2: CGPointMake(103.16, 80.79)];
        [bezier14Path addLineToPoint: CGPointMake(122.66, 80.79)];
        [bezier14Path closePath];
        [bezier14Path moveToPoint: CGPointMake(114.12, 117.25)];
        [bezier14Path addCurveToPoint: CGPointMake(113.45, 115.02) controlPoint1: CGPointMake(113.93, 115.89) controlPoint2: CGPointMake(113.74, 115.02)];
        [bezier14Path addCurveToPoint: CGPointMake(112.77, 117.25) controlPoint1: CGPointMake(113.15, 115.02) controlPoint2: CGPointMake(112.96, 115.7)];
        [bezier14Path addLineToPoint: CGPointMake(111.51, 126.43)];
        [bezier14Path addCurveToPoint: CGPointMake(112.09, 127.4) controlPoint1: CGPointMake(111.41, 126.91) controlPoint2: CGPointMake(111.6, 127.4)];
        [bezier14Path addCurveToPoint: CGPointMake(115.39, 126.53) controlPoint1: CGPointMake(115.19, 127.4) controlPoint2: CGPointMake(115.48, 127.4)];
        [bezier14Path addLineToPoint: CGPointMake(114.12, 117.25)];
        [bezier14Path closePath];
        bezier14Path.miterLimit = 4;
        
        [color2 setStroke];
        bezier14Path.lineWidth = 4;
        [bezier14Path stroke];
        
        
        //// Bezier 16 Drawing
        UIBezierPath* bezier16Path = UIBezierPath.bezierPath;
        [bezier16Path moveToPoint: CGPointMake(136.93, 82.44)];
        [bezier16Path addCurveToPoint: CGPointMake(138.28, 80.79) controlPoint1: CGPointMake(136.93, 81.47) controlPoint2: CGPointMake(137.41, 80.79)];
        [bezier16Path addLineToPoint: CGPointMake(160.89, 80.79)];
        [bezier16Path addCurveToPoint: CGPointMake(179.71, 102.26) controlPoint1: CGPointMake(165.35, 80.79) controlPoint2: CGPointMake(179.71, 83.98)];
        [bezier16Path addCurveToPoint: CGPointMake(162.35, 120.15) controlPoint1: CGPointMake(179.71, 111.25) controlPoint2: CGPointMake(171.66, 120.15)];
        [bezier16Path addCurveToPoint: CGPointMake(157.11, 121.31) controlPoint1: CGPointMake(157.59, 120.15) controlPoint2: CGPointMake(157.11, 120.15)];
        [bezier16Path addLineToPoint: CGPointMake(157.11, 151.96)];
        [bezier16Path addCurveToPoint: CGPointMake(155.46, 153.31) controlPoint1: CGPointMake(157.11, 152.73) controlPoint2: CGPointMake(156.53, 153.31)];
        [bezier16Path addLineToPoint: CGPointMake(138.48, 153.31)];
        [bezier16Path addCurveToPoint: CGPointMake(136.93, 151.57) controlPoint1: CGPointMake(137.61, 153.31) controlPoint2: CGPointMake(136.93, 152.54)];
        [bezier16Path addLineToPoint: CGPointMake(136.93, 82.44)];
        [bezier16Path closePath];
        [bezier16Path moveToPoint: CGPointMake(157.11, 107.67)];
        [bezier16Path addCurveToPoint: CGPointMake(158.08, 108.74) controlPoint1: CGPointMake(157.11, 108.06) controlPoint2: CGPointMake(157.4, 108.74)];
        [bezier16Path addCurveToPoint: CGPointMake(160.12, 105.55) controlPoint1: CGPointMake(159.53, 108.74) controlPoint2: CGPointMake(160.12, 107.48)];
        [bezier16Path addLineToPoint: CGPointMake(160.12, 101.58)];
        [bezier16Path addCurveToPoint: CGPointMake(158.08, 98.97) controlPoint1: CGPointMake(160.12, 100.03) controlPoint2: CGPointMake(159.34, 98.97)];
        [bezier16Path addCurveToPoint: CGPointMake(157.4, 99.07) controlPoint1: CGPointMake(157.79, 98.97) controlPoint2: CGPointMake(157.59, 98.97)];
        [bezier16Path addCurveToPoint: CGPointMake(157.11, 99.84) controlPoint1: CGPointMake(157.2, 99.16) controlPoint2: CGPointMake(157.11, 99.55)];
        [bezier16Path addLineToPoint: CGPointMake(157.11, 107.67)];
        [bezier16Path closePath];
        bezier16Path.miterLimit = 4;
        
        [color2 setStroke];
        bezier16Path.lineWidth = 4;
        [bezier16Path stroke];
        
        
        //// Bezier 18 Drawing
        UIBezierPath* bezier18Path = UIBezierPath.bezierPath;
        [bezier18Path moveToPoint: CGPointMake(179.81, 82.44)];
        [bezier18Path addCurveToPoint: CGPointMake(181.17, 80.79) controlPoint1: CGPointMake(179.81, 81.47) controlPoint2: CGPointMake(180.3, 80.79)];
        [bezier18Path addLineToPoint: CGPointMake(203.78, 80.79)];
        [bezier18Path addCurveToPoint: CGPointMake(222.6, 102.26) controlPoint1: CGPointMake(208.24, 80.79) controlPoint2: CGPointMake(222.6, 83.98)];
        [bezier18Path addCurveToPoint: CGPointMake(205.23, 120.15) controlPoint1: CGPointMake(222.6, 111.25) controlPoint2: CGPointMake(214.55, 120.15)];
        [bezier18Path addCurveToPoint: CGPointMake(199.99, 121.31) controlPoint1: CGPointMake(200.48, 120.15) controlPoint2: CGPointMake(199.99, 120.15)];
        [bezier18Path addLineToPoint: CGPointMake(199.99, 151.96)];
        [bezier18Path addCurveToPoint: CGPointMake(198.34, 153.31) controlPoint1: CGPointMake(199.99, 152.73) controlPoint2: CGPointMake(199.41, 153.31)];
        [bezier18Path addLineToPoint: CGPointMake(181.36, 153.31)];
        [bezier18Path addCurveToPoint: CGPointMake(179.81, 151.57) controlPoint1: CGPointMake(180.49, 153.31) controlPoint2: CGPointMake(179.81, 152.54)];
        [bezier18Path addLineToPoint: CGPointMake(179.81, 82.44)];
        [bezier18Path closePath];
        [bezier18Path moveToPoint: CGPointMake(199.99, 107.67)];
        [bezier18Path addCurveToPoint: CGPointMake(200.96, 108.74) controlPoint1: CGPointMake(199.99, 108.06) controlPoint2: CGPointMake(200.28, 108.74)];
        [bezier18Path addCurveToPoint: CGPointMake(203, 105.55) controlPoint1: CGPointMake(202.42, 108.74) controlPoint2: CGPointMake(203, 107.48)];
        [bezier18Path addLineToPoint: CGPointMake(203, 101.58)];
        [bezier18Path addCurveToPoint: CGPointMake(200.96, 98.97) controlPoint1: CGPointMake(203, 100.03) controlPoint2: CGPointMake(202.22, 98.97)];
        [bezier18Path addCurveToPoint: CGPointMake(200.28, 99.07) controlPoint1: CGPointMake(200.67, 98.97) controlPoint2: CGPointMake(200.48, 98.97)];
        [bezier18Path addCurveToPoint: CGPointMake(199.99, 99.84) controlPoint1: CGPointMake(200.09, 99.16) controlPoint2: CGPointMake(199.99, 99.55)];
        [bezier18Path addLineToPoint: CGPointMake(199.99, 107.67)];
        [bezier18Path closePath];
        bezier18Path.miterLimit = 4;
        
        [color2 setStroke];
        bezier18Path.lineWidth = 4;
        [bezier18Path stroke];
    }
}

@end
