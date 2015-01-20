//
//  DEAppDelegate.h
//  whatsgoinon
//
//  Created by adeiji on 8/4/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DELocationManager.h"
#import "DESyncManager.h"
#import "DEScreenManager.h"
#import "DEUserManager.h"

@interface DEAppDelegate : UIResponder <UIApplicationDelegate>
{
    NSTimer *timer;
}
@property (strong, nonatomic) UIWindow *window;

@end
