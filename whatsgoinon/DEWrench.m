//
//  DEWrench.m
//  whatsgoinon
//
//  Created by adeiji on 1/13/15.
//  Copyright (c) 2015 adeiji. All rights reserved.
//

#import "DEWrench.h"
#import "HPStyleKit.h"

@implementation DEWrench


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [HPStyleKit drawWrenchWithRect:rect];
}

@end
