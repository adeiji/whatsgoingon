//
//  DESharingView.m
//  whatsgoinon
//
//  Created by adeiji on 8/14/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//
//  This view is the view used to post something to Facebook, Tiwtter, or Instagram

#import "DESharingView.h"
#import <Social/Social.h>

@implementation DESharingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void) getAddress {
    [DELocationManager getAddressFromLatLongValue:_post.location CompletionBlock:^(NSString *value) {
        [_post setAddress:value];
    }];
}

- (IBAction)shareFacebook:(id)sender {
    DEUserManager *userManager = [DEUserManager sharedManager];
    if ([PFFacebookUtils isLinkedWithUser:userManager.user])
    {
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];

        UINavigationController *vc = (UINavigationController *) [[[[UIApplication sharedApplication] delegate] window] rootViewController];
        
        [controller setInitialText:[_post toString]];
        [controller addImage:_image];
        [vc presentViewController:controller animated:NO completion:^{
            NSLog(@"Completed the transition");
        }];
        
    }
}

- (IBAction)shareInstagram:(id)sender {
}

- (IBAction)shareTwitter:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        [tweetSheet setInitialText:[_post toString]];
        [tweetSheet addImage:_image];
        UINavigationController *vc = (UINavigationController *) [[[[UIApplication sharedApplication] delegate] window] rootViewController];
        
        [vc presentViewController:tweetSheet animated:YES completion:^{
            NSLog(@"Completed the transition");
        }];
    }
}

@end
