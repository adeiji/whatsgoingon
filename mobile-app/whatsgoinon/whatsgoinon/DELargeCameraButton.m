//
//  DELargeCameraButton.m
//  whatsgoinon
//
//  Created by adeiji on 9/11/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import "DELargeCameraButton.h"

@implementation DELargeCameraButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    
    if (!_noProfileImage)
    {
        [HPStyleKit drawLargeCameraButton:rect];
    }
    else {
        [HPStyleKit drawHappSnapIcon:rect];
    }
}


@end
