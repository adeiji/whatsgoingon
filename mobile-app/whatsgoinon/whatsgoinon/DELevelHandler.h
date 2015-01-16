//
//  DENSNumber *postNecessaryToReachAdeler.h
//  whatsgoinon
//
//  Created by adeiji on 1/9/15.
//  Copyright (c) 2015 adeiji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DELevelHandler : NSObject

@property (strong, nonatomic) NSArray *levels;
@property (strong, nonatomic) NSNumber *postSinceLastLevel;
@property (strong, nonatomic) NSNumber *postNecessaryToReachAde;
@property (strong, nonatomic) NSNumber *postNecessaryForAyosLevel;

/*
 
Set up the amount of post since the last level, and necessary for the next level, and return the current user's level
 
 */
- (NSNumber *) getLevelInformation : (NSNumber *) numberOfPost;
@end
