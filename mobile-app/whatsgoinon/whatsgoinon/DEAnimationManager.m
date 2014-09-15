//
//  DEAnimationManager.m
//  whatsgoinon
//
//  Created by adeiji on 9/11/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import "DEAnimationManager.h"

@implementation DEAnimationManager

+ (void) fadeOutWithView : (UIView *) view
               ViewToAdd : (UIView *) viewToAdd
{
    // Create a view that will act as an overlay that will fade to a specific color.  This view covers the entire screen
    [UIView animateWithDuration:.3 animations:^{
        // Fade out every view on the current screen
        [self setSubviewsOfView:view ToAlpha:0.0f];

    } completion:^(BOOL finished) {
        // Set the subviews of the new view to zero to ensure that nothing appears when it's first added
        [self setSubviewsOfView:viewToAdd ToAlpha:0.0f];
        [view addSubview:viewToAdd];
        [UIView animateWithDuration:.3 animations:^{
            [self setSubviewsOfView:viewToAdd ToAlpha:1.0f];
        }];
    }];
}

+ (void) fadeOutRemoveView : (UIView *) view
                  FromView : (UIView *) superview
{
    // Create a view that will act as an overlay that will fade to a specific color.  This view covers the entire screen
    [UIView animateWithDuration:.3 animations:^{
        // Fade out every view on the current screen
        [self setSubviewsOfView:view ToAlpha:0.0f];
        
    } completion:^(BOOL finished) {
        // Set the subviews of the new view to zero to ensure that nothing appears when it's first added
        [view removeFromSuperview];
        [UIView animateWithDuration:.3 animations:^{
            [self setSubviewsOfView:superview ToAlpha:1.0f];
        }];
    }];

}

+ (void) savedAnimationWithView {
    
    UIView *view = [[[UIApplication sharedApplication] delegate] window];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"going-indicator.png"]];
    CGRect frame = CGRectMake(60, 180, 200, 200);
    
    imageView.frame = frame;
    [view addSubview:imageView];
    
    if ([view subviews])
        
        [UIView animateWithDuration:1.0 animations:^{
            [imageView.layer setOpacity:0.0];
        } completion:^(BOOL finished) {
            [imageView removeFromSuperview];
        }];
}



+ (void) setSubviewsOfView : (UIView *) view
                   ToAlpha : (CGFloat) alpha
{
    for (UIView *myView in [view subviews]) {
        [myView setAlpha:alpha];
    }
}

@end
