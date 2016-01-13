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
#import <FBSDKShareKit/FBSDKShareLinkContent.h>
#import <FBSDKShareKit/FBSDKSharePhotoContent.h>
#import <FBSDKShareKit/FBSDKSharePhoto.h>
#import <FBSDKShareKit/FBSDKShareDialog.h>
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
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"EventView"
                                                          action:@"ShareEvent"
                                                           label:@"Facebook Share"
                                                           value:nil] build]];
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        NSString *message = [self messageCaption];
        NSURL *url = [self getEventUrl];
        NSDictionary *facebookPostData = @{
                                            @"message" : message,
                                            @"url" : url.absoluteString,
                                            @"title" : _post.title
                                            };
        
        UINavigationController *navController = [DEScreenManager getMainNavigationController];
        UIViewController *viewController = navController.viewControllers.lastObject;
        [PFAnalytics trackEvent:@"facebookSharing" dimensions:facebookPostData];

        FBSDKSharePhoto *photo = [[FBSDKSharePhoto alloc] init];
        photo.image = _image;
        photo.userGenerated = YES;
        
        FBSDKSharePhotoContent *content = [[FBSDKSharePhotoContent alloc] init];
        content.photos = @[photo];
        content.contentURL = [self getEventUrl];
        
        FBSDKShareDialog *dialog = [[FBSDKShareDialog alloc] init];
        dialog.mode = FBSDKShareDialogModeShareSheet;
        dialog.fromViewController = viewController;
        dialog.shareContent = content;
//        [FBSDKShareDialog showFromViewController:viewController withContent:content delegate:nil];
        [dialog show];

    }
    else {
        if (UIApplicationOpenSettingsURLString != NULL)  // If we're in iOS 8 and the user can open the settings app from within this app
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cannot Post to Facebook" message:@"It seems that you can't post to Facebook using this app right now.  Go to Settings --> Facebook, and ensure that all is set up accurately" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", @"Settings", nil];
            
            [alert show];
        }
    }
}


- (IBAction)shareTwitter:(id)sender {
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"EventView"
                                                          action:@"ShareEvent"
                                                           label:@"Twitter Share"
                                                           value:nil] build]];

    
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
        if (UIApplicationOpenSettingsURLString != NULL)  // If we're in iOS 8 and the user can open the settings app from within this app
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
    NSString *stringUrl = @"www.happsnap.com/event/?";
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
    if (buttonIndex == 1)
    {
        if (&UIApplicationOpenSettingsURLString != NULL) {
            NSURL *appSettings = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            [[UIApplication sharedApplication] openURL:appSettings];
        }
    }
}

@end
