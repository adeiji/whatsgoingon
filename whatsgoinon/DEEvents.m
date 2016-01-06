//
//  DEEvents.m
//  whatsgoinon
//
//  Created by adeiji on 8/5/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import "DEEvents.h"
#import "DESyncManager.h"

@implementation DEEvents

@synthesize events = _events;

+ (id) sharedManager {
    static DEEvents *sharedManager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    
    return sharedManager;
}

- (id) init {
    if (self = [super init]) {
        DEPostManager *sharedManager = [DEPostManager sharedManager];
        _events = [sharedManager posts];
    }
    
    return self;
}

- (NSArray *) getEvents {
    return _events;
}

@end
