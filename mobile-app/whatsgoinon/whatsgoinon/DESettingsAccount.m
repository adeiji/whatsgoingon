//
//  DESettingsAccount.m
//  whatsgoinon
//
//  Created by adeiji on 8/19/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import "DESettingsAccount.h"

@implementation DESettingsAccount

- (id)init
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"ViewSettingsAccount" owner:self options:nil] firstObject];
    }
    return self;
}

- (IBAction)takePicture:(id)sender {
}

- (IBAction)sendFeedback:(id)sender {
}

- (IBAction)signOut:(id)sender {
}

- (IBAction)goBack:(id)sender {
    [[self superview] removeFromSuperview];
    
}
@end
