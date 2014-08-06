//
//  DEEvents.h
//  whatsgoinon
//
//  Created by adeiji on 8/5/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DEPostManager.h"

@interface DEEvents : NSObject

@property (nonatomic, strong) NSArray *events;

- (NSArray *) getEvents;

@end
