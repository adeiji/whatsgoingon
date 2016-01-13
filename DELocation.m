//
//  DELocation.m
//  whatsgoinon
//
//  Created by adeiji on 1/13/15.
//  Copyright (c) 2015 adeiji. All rights reserved.
//

#import "DELocation.h"
#import "HPStyleKit.h"

@implementation DELocation


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [HPStyleKit drawLocationWithFrame:rect];
}

@end
