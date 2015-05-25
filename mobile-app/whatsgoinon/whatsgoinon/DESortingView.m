//
//  DESortingView.m
//  whatsgoinon
//
//  Created by adeiji on 5/24/15.
//  Copyright (c) 2015 adeiji. All rights reserved.
//

#import "DESortingView.h"
#import "Constants.h"

@implementation DESortingView

- (id) initWithOwner : (id) owner {
    
    self = [super init];
    if (self)
    {
        self = [[[NSBundle mainBundle] loadNibNamed:@"ViewSort" owner:owner options:nil] firstObject];
        [[self.btnNearMe layer] setCornerRadius:BUTTON_CORNER_RADIUS];
        [[self.btnStartTime layer] setCornerRadius:BUTTON_CORNER_RADIUS];
        [[self.btnTrending layer] setCornerRadius:BUTTON_CORNER_RADIUS];
        [[self.btnCancel layer] setCornerRadius:BUTTON_CORNER_RADIUS];
    }
    
    return self;
}

@end
