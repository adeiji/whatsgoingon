//
//  DESector.h
//  whatsgoinon
//
//  Created by adeiji on 8/13/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DESector : NSObject

@property float minValue;
@property float maxValue;
@property float midValue;
@property int sector;

@property (nonatomic, strong) NSMutableArray *sectors;



@end
