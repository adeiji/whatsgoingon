//
//  DEViewReportEvent.m
//  whatsgoinon
//
//  Created by adeiji on 8/15/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import "DEViewReportEvent.h"

@implementation DEViewReportEvent

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (IBAction)cancelReport:(id)sender {
    [[self superview] removeFromSuperview];
}


// Push the event up to the server as reported, and store the reason for the report as well
- (IBAction)reportEvent:(id)sender {
}
@end
