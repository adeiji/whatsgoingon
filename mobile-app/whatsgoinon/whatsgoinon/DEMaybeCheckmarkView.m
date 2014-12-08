//
//  DEMaybeCheckmarkView.m
//  whatsgoinon
//
//  Created by adeiji on 12/7/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import "DEMaybeCheckmarkView.h"
#import "stylekit/HPStyleKit.h"

@implementation DEMaybeCheckmarkView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [HPStyleKit drawMaybeCheckmark];
}


@end
