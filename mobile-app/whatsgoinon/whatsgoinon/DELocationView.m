//
//  DELocationView.m
//  whatsgoinon
//
//  Created by adeiji on 8/26/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import "DELocationView.h"

@implementation DELocationView

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
    
    //// Layer_1
    {
        //// Group 3
        {
            //// Bezier 2 Drawing
            UIBezierPath* bezier2Path = UIBezierPath.bezierPath;
            [bezier2Path moveToPoint: CGPointMake(19.46, 19.36)];
            [bezier2Path addCurveToPoint: CGPointMake(24.9, 10.98) controlPoint1: CGPointMake(22.64, 18.06) controlPoint2: CGPointMake(24.9, 14.8)];
            [bezier2Path addCurveToPoint: CGPointMake(16.4, 2) controlPoint1: CGPointMake(24.9, 6.02) controlPoint2: CGPointMake(21.1, 2)];
            [bezier2Path addCurveToPoint: CGPointMake(7.9, 10.98) controlPoint1: CGPointMake(11.7, 2) controlPoint2: CGPointMake(7.9, 6.02)];
            [bezier2Path addCurveToPoint: CGPointMake(13.33, 19.35) controlPoint1: CGPointMake(7.9, 14.8) controlPoint2: CGPointMake(10.16, 18.05)];
            [color0 setStroke];
            bezier2Path.lineWidth = 1;
            [bezier2Path stroke];
            
            
            //// Bezier 4 Drawing
            UIBezierPath* bezier4Path = UIBezierPath.bezierPath;
            [bezier4Path moveToPoint: CGPointMake(13.33, 19.17)];
            [bezier4Path addLineToPoint: CGPointMake(16.46, 28.8)];
            [bezier4Path addLineToPoint: CGPointMake(19.46, 19.17)];
            [color0 setStroke];
            bezier4Path.lineWidth = 1;
            [bezier4Path stroke];
            
            
            //// Oval 2 Drawing
            UIBezierPath* oval2Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(13.9, 7.5, 5, 5.5)];
            [color0 setStroke];
            oval2Path.lineWidth = 1;
            [oval2Path stroke];
        }
    }

}


@end
