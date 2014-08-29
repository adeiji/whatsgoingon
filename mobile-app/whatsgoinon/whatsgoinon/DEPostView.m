//
//  DEPostView.m
//  whatsgoinon
//
//  Created by adeiji on 8/26/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import "DEPostView.h"

@implementation DEPostView

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
    UIColor* color0 = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
    
    //// Layer_2
    {
        //// Group 3
        {
            //// Bezier 2 Drawing
            UIBezierPath* bezier2Path = UIBezierPath.bezierPath;
            [bezier2Path moveToPoint: CGPointMake(13.1, 22)];
            [bezier2Path addLineToPoint: CGPointMake(3.6, 22)];
            [bezier2Path addLineToPoint: CGPointMake(3.6, 12.5)];
            [bezier2Path addCurveToPoint: CGPointMake(13.1, 3) controlPoint1: CGPointMake(3.6, 7.25) controlPoint2: CGPointMake(7.85, 3)];
            [bezier2Path addLineToPoint: CGPointMake(13.1, 3)];
            [bezier2Path addCurveToPoint: CGPointMake(22.6, 12.5) controlPoint1: CGPointMake(18.35, 3) controlPoint2: CGPointMake(22.6, 7.25)];
            [bezier2Path addLineToPoint: CGPointMake(22.6, 12.5)];
            [bezier2Path addCurveToPoint: CGPointMake(13.1, 22) controlPoint1: CGPointMake(22.6, 17.75) controlPoint2: CGPointMake(18.35, 22)];
            [bezier2Path closePath];
            [color0 setStroke];
            bezier2Path.lineWidth = 1;
            [bezier2Path stroke];
            
            
            //// Bezier 4 Drawing
            UIBezierPath* bezier4Path = UIBezierPath.bezierPath;
            [bezier4Path moveToPoint: CGPointMake(3.5, 15.52)];
            [bezier4Path addLineToPoint: CGPointMake(9.31, 14.73)];
            [bezier4Path addCurveToPoint: CGPointMake(9.95, 15.35) controlPoint1: CGPointMake(9.7, 14.68) controlPoint2: CGPointMake(9.97, 14.94)];
            [bezier4Path addLineToPoint: CGPointMake(9.78, 20.5)];
            [bezier4Path addLineToPoint: CGPointMake(3.5, 15.52)];
            [bezier4Path closePath];
            [color0 setStroke];
            bezier4Path.lineWidth = 1;
            [bezier4Path stroke];
            
            
            //// Group 4
            {
                //// Group 5
                {
                    //// Bezier 6 Drawing
                    UIBezierPath* bezier6Path = UIBezierPath.bezierPath;
                    [bezier6Path moveToPoint: CGPointMake(7.49, 11)];
                    [bezier6Path addCurveToPoint: CGPointMake(16.11, 11) controlPoint1: CGPointMake(10.36, 11) controlPoint2: CGPointMake(13.24, 11)];
                    [bezier6Path addCurveToPoint: CGPointMake(19.31, 11) controlPoint1: CGPointMake(17.18, 11) controlPoint2: CGPointMake(18.24, 11)];
                    [bezier6Path addCurveToPoint: CGPointMake(19.31, 10) controlPoint1: CGPointMake(20.06, 11) controlPoint2: CGPointMake(20.06, 10)];
                    [bezier6Path addCurveToPoint: CGPointMake(10.69, 10) controlPoint1: CGPointMake(16.44, 10) controlPoint2: CGPointMake(13.56, 10)];
                    [bezier6Path addCurveToPoint: CGPointMake(7.49, 10) controlPoint1: CGPointMake(9.62, 10) controlPoint2: CGPointMake(8.56, 10)];
                    [bezier6Path addCurveToPoint: CGPointMake(7.49, 11) controlPoint1: CGPointMake(6.74, 10) controlPoint2: CGPointMake(6.74, 11)];
                    [bezier6Path addLineToPoint: CGPointMake(7.49, 11)];
                    [bezier6Path closePath];
                    bezier6Path.miterLimit = 4;
                    
                    [color0 setFill];
                    [bezier6Path fill];
                }
            }
            
            
            //// Group 6
            {
                //// Group 7
                {
                    //// Bezier 8 Drawing
                    UIBezierPath* bezier8Path = UIBezierPath.bezierPath;
                    [bezier8Path moveToPoint: CGPointMake(7.49, 14)];
                    [bezier8Path addCurveToPoint: CGPointMake(16.11, 14) controlPoint1: CGPointMake(10.36, 14) controlPoint2: CGPointMake(13.24, 14)];
                    [bezier8Path addCurveToPoint: CGPointMake(19.31, 14) controlPoint1: CGPointMake(17.18, 14) controlPoint2: CGPointMake(18.24, 14)];
                    [bezier8Path addCurveToPoint: CGPointMake(19.31, 13) controlPoint1: CGPointMake(20.06, 14) controlPoint2: CGPointMake(20.06, 13)];
                    [bezier8Path addCurveToPoint: CGPointMake(10.69, 13) controlPoint1: CGPointMake(16.44, 13) controlPoint2: CGPointMake(13.56, 13)];
                    [bezier8Path addCurveToPoint: CGPointMake(7.49, 13) controlPoint1: CGPointMake(9.62, 13) controlPoint2: CGPointMake(8.56, 13)];
                    [bezier8Path addCurveToPoint: CGPointMake(7.49, 14) controlPoint1: CGPointMake(6.74, 13) controlPoint2: CGPointMake(6.74, 14)];
                    [bezier8Path addLineToPoint: CGPointMake(7.49, 14)];
                    [bezier8Path closePath];
                    bezier8Path.miterLimit = 4;
                    
                    [color0 setFill];
                    [bezier8Path fill];
                }
            }
            
            
            //// Group 8
            {
                //// Group 9
                {
                    //// Bezier 10 Drawing
                    UIBezierPath* bezier10Path = UIBezierPath.bezierPath;
                    [bezier10Path moveToPoint: CGPointMake(19.21, 16.2)];
                    [bezier10Path addCurveToPoint: CGPointMake(10.92, 16.2) controlPoint1: CGPointMake(16.45, 16.2) controlPoint2: CGPointMake(13.68, 16.2)];
                    [bezier10Path addCurveToPoint: CGPointMake(10.49, 16.2) controlPoint1: CGPointMake(10.78, 16.2) controlPoint2: CGPointMake(10.63, 16.2)];
                    [bezier10Path addCurveToPoint: CGPointMake(10.49, 16.8) controlPoint1: CGPointMake(9.77, 16.2) controlPoint2: CGPointMake(9.77, 16.8)];
                    [bezier10Path addCurveToPoint: CGPointMake(18.78, 16.8) controlPoint1: CGPointMake(13.25, 16.8) controlPoint2: CGPointMake(16.02, 16.8)];
                    [bezier10Path addCurveToPoint: CGPointMake(19.21, 16.8) controlPoint1: CGPointMake(18.92, 16.8) controlPoint2: CGPointMake(19.07, 16.8)];
                    [bezier10Path addCurveToPoint: CGPointMake(19.21, 16.2) controlPoint1: CGPointMake(19.93, 16.8) controlPoint2: CGPointMake(19.93, 16.2)];
                    [bezier10Path addLineToPoint: CGPointMake(19.21, 16.2)];
                    [bezier10Path closePath];
                    bezier10Path.miterLimit = 4;
                    
                    [color0 setFill];
                    [bezier10Path fill];
                    [UIColor.whiteColor setStroke];
                    bezier10Path.lineWidth = 0.5;
                    [bezier10Path stroke];
                }
            }
        }
    }

}


@end
