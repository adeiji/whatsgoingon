//
//  DEBinoculars.m
//  whatsgoinon
//
//  Created by adeiji on 1/8/15.
//  Copyright (c) 2015 adeiji. All rights reserved.
//

#import "DEBinoculars.h"
#import "HPStyleKit.h"

@implementation DEBinoculars


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [HPStyleKit drawBinocularsWithFrame:rect];
}


@end
