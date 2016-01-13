//
//  DEOrbButton.m
//  whatsgoinon
//
//  Created by adeiji on 8/26/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import "DEOrbButton.h"

@implementation DEOrbButton

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
    //// PaintCode Trial Version
    //// www.paintcodeapp.com
    
    //// Color Declarations
    UIColor* prettyBlue = [UIColor colorWithRed: 0.161 green: 0.502 blue: 0.725 alpha: 1];
    CGFloat prettyBlueHSBA[4];
    [prettyBlue getHue: &prettyBlueHSBA[0] saturation: &prettyBlueHSBA[1] brightness: &prettyBlueHSBA[2] alpha: &prettyBlueHSBA[3]];
    
    UIColor* color2 = [UIColor colorWithHue: prettyBlueHSBA[0] saturation: 1 brightness: prettyBlueHSBA[2] alpha: prettyBlueHSBA[3]];
    
    //// Oval Drawing
    UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(6, 6, 35, 35)];
    [color2 setFill];
    [ovalPath fill];
    
    
    //// Oval 2 Drawing
    UIBezierPath* oval2Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(1, 0.5, 46.5, 46.5)];
    [prettyBlue setStroke];
    oval2Path.lineWidth = 1;
    [oval2Path stroke];


}

@end
