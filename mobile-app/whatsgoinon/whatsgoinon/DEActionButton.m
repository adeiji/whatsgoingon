//
//  DEActionButton.m
//  whatsgoinon
//
//  Created by adeiji on 9/12/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import "DEActionButton.h"

@implementation DEActionButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (CGSize) intrinsicContentSize
{
    CGSize size = [super intrinsicContentSize];
    
    return CGSizeMake(size.width - (self.imageEdgeInsets.left + self.imageEdgeInsets.right), size.height - (self.imageEdgeInsets.top + self.imageEdgeInsets.bottom));
}

@end
