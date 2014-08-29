//
//  DEFacebookButton.m
//  whatsgoinon
//
//  Created by adeiji on 8/28/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import "DEFacebookButton.h"

@implementation DEFacebookButton

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
    
    //// General Declarations
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Color Declarations
    UIColor* color7 = [UIColor colorWithRed: 0 green: 0.675 blue: 0.933 alpha: 1];

    CGContextSaveGState(context);
    CGContextTranslateCTM(context, 5.7, 7.8);
    CGContextRestoreGState(context);

    //// Oval Drawing
    UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(2, 1, 47, 48)];
    [color7 setFill];
    [ovalPath fill];
    
    
    //// Text Drawing
    CGRect textRect = CGRectMake(3, 3, 47, 48);
    NSMutableParagraphStyle* textStyle = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
    textStyle.alignment = NSTextAlignmentCenter;
    
    NSDictionary* textFontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"HelveticaNeue-Medium" size: 35], NSForegroundColorAttributeName: UIColor.whiteColor, NSParagraphStyleAttributeName: textStyle};
    
    [@"f" drawInRect: textRect withAttributes: textFontAttributes];
}


@end
