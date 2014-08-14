//
//  DEScreenManager.h
//  whatsgoinon
//
//  Created by adeiji on 8/7/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DEScreenManager : NSObject

@property BOOL overlayDisplayed;
@property (strong, nonatomic) UIViewController *nextScreen;
@property (strong, nonatomic) NSMutableDictionary *values;

+ (id)sharedManager;

@end