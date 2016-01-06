//
//  DETrophy.m
//  whatsgoinon
//
//  Created by adeiji on 1/9/15.
//  Copyright (c) 2015 adeiji. All rights reserved.
//

#import "DETrophy.h"
#import "HPStyleKit.h"

@implementation DETrophy

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    [HPStyleKit drawTrophyWithFrame:rect];
}


@end
