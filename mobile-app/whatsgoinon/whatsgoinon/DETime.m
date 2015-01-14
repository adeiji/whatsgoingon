//
//  DETime.m
//  whatsgoinon
//
//  Created by adeiji on 1/13/15.
//  Copyright (c) 2015 adeiji. All rights reserved.
//

#import "DETime.h"
#import "HPStyleKit.h"

@implementation DETime

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [HPStyleKit drawTimeWithFrame:rect];
}


@end
