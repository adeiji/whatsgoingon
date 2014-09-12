//
//  DEAnimationManager.h
//  whatsgoinon
//
//  Created by adeiji on 9/11/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DEAnimationManager : NSObject

+ (void) fadeOutWithView : (UIView *) view
               ViewToAdd : (UIView *) viewToAdd;

+ (void) fadeOutRemoveView : (UIView *) view
                  FromView : (UIView *) superview;

@end