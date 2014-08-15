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

- (IBAction)sharePost:(id)sender {
    if (_switchPostOnTwitter.on)
    {
        [self performSelectorOnMainThread:@selector(postToTwitter) withObject:nil waitUntilDone:YES];
    }
    if (_switchPostOnFacebook.on)
    {
        [self postToFacebook];
    }
}

- (BOOL) postToFacebook {
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];

        UINavigationController *vc = (UINavigationController *) [[[[UIApplication sharedApplication] delegate] window] rootViewController];
        
        [controller setInitialText:@"First post from my iPhone app"];
        [vc presentViewController:controller animated:YES completion:Nil];
    }

    return NO;
}

- (BOOL) postToInstagram {
    return NO;
}

- (BOOL) postToTwitter {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        [tweetSheet setInitialText:@"Great"];
        
        UINavigationController *vc = (UINavigationController *) [[[[UIApplication sharedApplication] delegate] window] rootViewController];
        
        [vc presentViewController:tweetSheet animated:YES completion:nil];
        
        return YES;
    }
    
    return NO;
}

@end
