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
    UIColor* color2 = [UIColor colorWithRed: 0.222 green: 0.699 blue: 0.312 alpha: 1];
    UIColor* color1 = [UIColor colorWithRed: 0.075 green: 0.606 blue: 0.915 alpha: 1];
    UIColor* color0 = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
    UIColor* color = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
    
    //// Layer_2
    {
        //// Bezier 2 Drawing
        UIBezierPath* bezier2Path = UIBezierPath.bezierPath;
        [bezier2Path moveToPoint: CGPointMake(107.1, 16)];
        [bezier2Path addCurveToPoint: CGPointMake(61.9, 61.2) controlPoint1: CGPointMake(82.1, 16) controlPoint2: CGPointMake(61.9, 36.3)];
        [bezier2Path addCurveToPoint: CGPointMake(107.1, 106.4) controlPoint1: CGPointMake(61.9, 86.1) controlPoint2: CGPointMake(82.2, 106.4)];
        [bezier2Path addCurveToPoint: CGPointMake(152.3, 61.2) controlPoint1: CGPointMake(132.1, 106.4) controlPoint2: CGPointMake(152.3, 86.1)];
        [bezier2Path addCurveToPoint: CGPointMake(107.1, 16) controlPoint1: CGPointMake(152.3, 36.3) controlPoint2: CGPointMake(132.1, 16)];
        [bezier2Path closePath];
        [bezier2Path moveToPoint: CGPointMake(107.1, 65.4)];
        [bezier2Path addCurveToPoint: CGPointMake(105.1, 64.9) controlPoint1: CGPointMake(106.4, 65.4) controlPoint2: CGPointMake(105.7, 65.2)];
        [bezier2Path addLineToPoint: CGPointMake(94.9, 75.1)];
        [bezier2Path addCurveToPoint: CGPointMake(93.2, 75.1) controlPoint1: CGPointMake(94.4, 75.6) controlPoint2: CGPointMake(93.7, 75.6)];
        [bezier2Path addCurveToPoint: CGPointMake(93.2, 73.4) controlPoint1: CGPointMake(92.7, 74.6) controlPoint2: CGPointMake(92.7, 73.9)];
        [bezier2Path addLineToPoint: CGPointMake(103.5, 63.1)];
        [bezier2Path addLineToPoint: CGPointMake(103.5, 63.1)];
        [bezier2Path addCurveToPoint: CGPointMake(103, 61.1) controlPoint1: CGPointMake(103.2, 62.5) controlPoint2: CGPointMake(103, 61.8)];
        [bezier2Path addCurveToPoint: CGPointMake(106, 57.1) controlPoint1: CGPointMake(103, 59.2) controlPoint2: CGPointMake(104.3, 57.6)];
        [bezier2Path addLineToPoint: CGPointMake(106, 27.1)];
        [bezier2Path addCurveToPoint: CGPointMake(107.2, 25.9) controlPoint1: CGPointMake(106, 26.5) controlPoint2: CGPointMake(106.5, 25.9)];
        [bezier2Path addCurveToPoint: CGPointMake(108.4, 27.1) controlPoint1: CGPointMake(107.8, 25.9) controlPoint2: CGPointMake(108.4, 26.4)];
        [bezier2Path addLineToPoint: CGPointMake(108.4, 57.2)];
        [bezier2Path addCurveToPoint: CGPointMake(111.4, 61.2) controlPoint1: CGPointMake(110.1, 57.7) controlPoint2: CGPointMake(111.4, 59.3)];
        [bezier2Path addCurveToPoint: CGPointMake(107.1, 65.4) controlPoint1: CGPointMake(111.3, 63.5) controlPoint2: CGPointMake(109.4, 65.4)];
        [bezier2Path closePath];
        bezier2Path.miterLimit = 4;
        
        [color0 setFill];
        [bezier2Path fill];
        
        
        //// Bezier 4 Drawing
        UIBezierPath* bezier4Path = UIBezierPath.bezierPath;
        [bezier4Path moveToPoint: CGPointMake(143.3, 88.2)];
        [bezier4Path addLineToPoint: CGPointMake(111.3, 143.6)];
        [bezier4Path addCurveToPoint: CGPointMake(103, 143.6) controlPoint1: CGPointMake(109.5, 146.8) controlPoint2: CGPointMake(104.9, 146.8)];
        [bezier4Path addLineToPoint: CGPointMake(71, 88.2)];
        [bezier4Path addLineToPoint: CGPointMake(143.3, 88.2)];
        [bezier4Path closePath];
        bezier4Path.miterLimit = 4;
        
        [color0 setFill];
        [bezier4Path fill];
        
        
        //// Rectangle 4 Drawing
        CGRect rectangle4Rect = CGRectMake(25.75, 155.82, 36, 72);
        NSMutableParagraphStyle* rectangle4Style = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
        rectangle4Style.alignment = NSTextAlignmentLeft;
        
        NSDictionary* rectangle4FontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"Avenir-Roman" size: 36], NSForegroundColorAttributeName: color1, NSParagraphStyleAttributeName: rectangle4Style};
        
        [@"H" drawInRect: rectangle4Rect withAttributes: rectangle4FontAttributes];
        
        
        //// Rectangle 6 Drawing
        CGRect rectangle6Rect = CGRectMake(51.75, 155.82, 108, 72);
        NSMutableParagraphStyle* rectangle6Style = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
        rectangle6Style.alignment = NSTextAlignmentLeft;
        
        NSDictionary* rectangle6FontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"Avenir-Roman" size: 36], NSForegroundColorAttributeName: color0, NSParagraphStyleAttributeName: rectangle6Style};
        
        [@"app" drawInRect: rectangle6Rect withAttributes: rectangle6FontAttributes];
        
        
        //// Rectangle 8 Drawing
        CGRect rectangle8Rect = CGRectMake(114.45, 155.82, 36, 72);
        NSMutableParagraphStyle* rectangle8Style = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
        rectangle8Style.alignment = NSTextAlignmentLeft;
        
        NSDictionary* rectangle8FontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"Avenir-Roman" size: 36], NSForegroundColorAttributeName: color2, NSParagraphStyleAttributeName: rectangle8Style};
        
        [@"S" drawInRect: rectangle8Rect withAttributes: rectangle8FontAttributes];
        
        
        //// Rectangle 10 Drawing
        CGRect rectangle10Rect = CGRectMake(134.45, 155.82, 108, 72);
        NSMutableParagraphStyle* rectangle10Style = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
        rectangle10Style.alignment = NSTextAlignmentLeft;
        
        NSDictionary* rectangle10FontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"Avenir-Roman" size: 36], NSForegroundColorAttributeName: color0, NSParagraphStyleAttributeName: rectangle10Style};
        
        [@"nap" drawInRect: rectangle10Rect withAttributes: rectangle10FontAttributes];
    }
    
    
    //// Oval Drawing
    UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(86, 152, 43, 10)];
    [color setFill];
    [ovalPath fill];
}

@end
