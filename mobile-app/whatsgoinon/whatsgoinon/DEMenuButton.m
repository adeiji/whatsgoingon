//
//  DEMenuButton.m
//  whatsgoinon
//
//  Created by adeiji on 8/26/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import "DEMenuButton.h"

@implementation DEMenuButton

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

    //// Nav_Bar
    {
        //// Group 4
        {
            //// Bezier 2 Drawing
            UIBezierPath* bezier2Path = UIBezierPath.bezierPath;
            [bezier2Path moveToPoint: CGPointMake(7.9, 8.6)];
            [bezier2Path addLineToPoint: CGPointMake(38, 8.6)];
            [color0 setStroke];
            bezier2Path.lineWidth = 5;
            [bezier2Path stroke];
            
            
            //// Bezier 4 Drawing
            UIBezierPath* bezier4Path = UIBezierPath.bezierPath;
            [bezier4Path moveToPoint: CGPointMake(7.9, 21)];
            [bezier4Path addLineToPoint: CGPointMake(38, 21)];
            [color0 setStroke];
            bezier4Path.lineWidth = 5;
            [bezier4Path stroke];
            
            
            //// Bezier 6 Drawing
            UIBezierPath* bezier6Path = UIBezierPath.bezierPath;
            [bezier6Path moveToPoint: CGPointMake(7.9, 33.4)];
            [bezier6Path addLineToPoint: CGPointMake(38, 33.4)];
            [color0 setStroke];
            bezier6Path.lineWidth = 5;
            [bezier6Path stroke];
        }
    }
}


@end
