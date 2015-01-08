//
//  DEHappSnapTitleView.m
//  whatsgoinon
//
//  Created by adeiji on 8/26/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import "DEHappSnapTitleView.h"
#import "HPStyleKit.h"

@implementation DEHappSnapTitleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = NO;
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{

    [HPStyleKit drawHappsnaplogoWithRectangle:rect];

}

@end
