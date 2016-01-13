//
//  DETutorialCategory.m
//  whatsgoinon
//
//  Created by adeiji on 5/16/15.
//  Copyright (c) 2015 adeiji. All rights reserved.
//

#import "DETutorialCategory.h"
#import "HPStyleKit.h"

@implementation DETutorialCategory

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    [HPStyleKit drawTutorialWithFrame:rect];
}


@end
