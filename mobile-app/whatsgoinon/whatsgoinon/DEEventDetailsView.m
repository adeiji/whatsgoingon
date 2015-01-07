//
//  DEEventDetailsView.m
//  whatsgoinon
//
//  Created by adeiji on 8/11/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import "DEEventDetailsView.h"

@implementation DEEventDetailsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) loadView : (DEPost *) post
{
    // Event has already started
    if ([[post startTime] compare:[NSDate date]] == NSOrderedAscending)
    {

        
    }
    else    // Event has not started
    {
        
    }
}
@end
