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
#import <ParseFacebookUtils/PFFacebookUtils.h>

@implementation DESharingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) getAddress {
    [DELocationManager getAddressFromLatLongValue:_post.location CompletionBlock:^(NSString *value) {
        [_post setAddress:value];
    }];
    
    [_btnShareText setTitle:[[self getEventUrl] absoluteString] forState:UIControlStateNormal];
}

- (IBAction)shareFacebook:(id)sender {
    if ([PFFacebookUtils isLinkedWithUser:[PFUser currentUser]])
    {
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];

        UINavigationController *vc = (UINavigationController *) [[[[UIApplication sharedApplication] delegate] window] rootViewController];
        [controller addURL:[self getEventUrl]];
        [controller setInitialText:[self messageCaption]];
        [controller addImage:_image];
        [vc presentViewController:controller animated:NO completion:^{
            NSLog(@"Completed the transition");
        }];
    }
    else {
        [PFFacebookUtils linkUserInBackground:[PFUser currentUser] permissions:nil];
    }
}


- (IBAction)shareTwitter:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        [tweetSheet addURL:[self getEventUrl]];
        [tweetSheet setInitialText:[self messageCaption]];
        [tweetSheet addImage:_image];
        [tweetSheet setTitle:_post.title];
        UINavigationController *vc = (UINavigationController *) [[[[UIApplication sharedApplication] delegate] window] rootViewController];
        
        [vc presentViewController:tweetSheet animated:YES completion:^{
            NSLog(@"Completed the transition");
        }];
    }
    else {
        if (&UIApplicationOpenSettingsURLString != NULL)  // If we're in iOS 8 and the user can open the settings app from within this app
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cannot Tweet" message:@"It seems that you can't tweet using this app right now.  Go to Settings --> Twitter, and ensure that all is set up accurately" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", @"Settings", nil];
            
            [alert show];
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cannot Tweet" message:@"It seems that you can't tweet using this app right now.  Go to Settings --> Twitter, and ensure that all is set up accurately" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
            
            [alert show];
        }
    }
}

- (void) messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {

}


- (NSString *) messageCaption {
    return [NSString stringWithFormat:@"%@\nCheck out this event that's posted on HappSnap!", _post.title];
}

- (NSURL *) getEventUrl {
    NSString *stringUrl = @"https://www.google.com/";
    NSString *message = [NSString stringWithFormat:@"%@%@", stringUrl, _post.objectId ];
    NSURL *url = [[NSURL alloc] initWithString:message];

    return url;
}

- (IBAction)shareText:(id)sender {
    [[DEScreenManager sharedManager] showTextWithMessage:[[self getEventUrl] absoluteString ]];

}

# pragma mark - Alert View Delegate Methods

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // If he clicks on settings
    if (buttonIndex == 0)
    {
        if (&UIApplicationOpenSettingsURLString != NULL) {
            NSURL *appSettings = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            [[UIApplication sharedApplication] openURL:appSettings];
        }
    }
}

@end
