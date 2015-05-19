//
//  DEForwardArrowsView.m
//  whatsgoinon
//
//  Created by adeiji on 5/16/15.
//  Copyright (c) 2015 adeiji. All rights reserved.
//

#import "DEForwardArrowsView.h"
#import "HPStyleKit.h"

IB_DESIGNABLE

@implementation DEForwardArrowsView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [HPStyleKit drawArrows];
}


@end
