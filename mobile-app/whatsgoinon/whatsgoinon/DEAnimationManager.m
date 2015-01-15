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
        // Set the subviews of the new view alpha to zero to ensure that the views appear on screen
        [view removeFromSuperview];
        [UIView animateWithDuration:.3 animations:^{
            [self setSubviewsOfView:superview ToAlpha:1.0f];
        }];
    }];

}
/*
 
 Display in the main window that the user has just saved an event
 
 */
+ (void) savedAnimationWithImage : (NSString *) imageName {
    
    UIView *view = [[[UIApplication sharedApplication] delegate] window];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    CGRect frame = CGRectMake(0, 0, 200, 200);
    imageView.frame = frame;
    [imageView setCenter:[view center]];
    [view addSubview:imageView];
    
    if ([view subviews])
        
        [UIView animateWithDuration:1.8 animations:^{
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
