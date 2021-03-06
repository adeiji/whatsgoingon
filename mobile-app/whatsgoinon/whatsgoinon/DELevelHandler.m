//
//  DELevelHandler.m
//  whatsgoinon
//
//  Created by adeiji on 1/9/15.
//  Copyright (c) 2015 adeiji. All rights reserved.
//

#import "DELevelHandler.h"

@implementation DELevelHandler

- (id) init
{
    self = [super init];
    if (self) {
        _levels = @[@1,
                    @3,
                    @5,
                    @10,
                    @15,
                    @20,
                    @25,
                    @30,
                    @35,
                    @40,
                    @50,
                    @65,
                    @75,
                    @90,
                    @100,
                    @115,
                    @130,
                    @145,
                    @160,
                    @175,
                    @200,
                    @225,
                    @250,
                    @275,
                    @300,
                    @325,
                    @350,
                    @375,
                    @400,
                    @425,
                    @450,
                    @475,
                    @500,
                    @525,
                    @550,
                    @575,
                    @600,
                    @625,
                    @650,
                    @675,
                    @700,
                    @725,
                    @750,
                    @775,
                    @800,
                    @825,
                    @850,
                    @875,
                    @900];
    }
    
    return self;
}

- (NSNumber *) getLevelInformation : (NSNumber *) numberOfPost {
    __block int level = 0;
    _postSinceLastLevel = [NSNumber new];
    // This post variable is called postNecessaryToReachAde, because this is the amount of post it will take to reach the next level, where Ade resides
    _postNecessaryToReachAde = [NSNumber new];
    // This is the necessary post required to reach the previous level
    _postNecessaryForAyosLevel = [NSNumber new];
    
    [_levels enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (numberOfPost > (NSNumber *) obj)
        {
            level ++;
            _postSinceLastLevel = [NSNumber numberWithLong:(numberOfPost.integerValue - ((NSNumber *) obj).integerValue)];
            _postNecessaryForAyosLevel = obj;
        }
        else {
            *stop = YES;
            _postNecessaryToReachAde = [NSNumber numberWithLong: ((NSNumber *) obj).integerValue - _postNecessaryForAyosLevel.integerValue];
        }
    }];
    
    return [NSNumber numberWithInt:level];;
}


@end
