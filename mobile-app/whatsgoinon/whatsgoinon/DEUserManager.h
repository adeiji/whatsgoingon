//
//  DEUserManager.h
//  whatsgoinon
//
//  Created by adeiji on 8/8/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "DELoginViewController.h"
#import "DESyncManager.h"

@interface DEUserManager : NSObject

- (NSError *) createUserWithUserName : (NSString *) userName
                       Password : (NSString *) password
                          Email : (NSString *) email;

- (NSError *) loginWithUsername : (NSString *) username
                       Password : (NSString *) password
                 ViewController : (UIViewController *) viewController
                     ErrorLabel : (UILabel *) label;

- (BOOL) isLoggedIn;

+ (id)sharedManager;
- (NSError *) loginWithTwitter;
- (NSError *) linkWithTwitter;
- (NSError *) loginWithFacebook;

- (BOOL) isLinkedWithTwitter;
- (BOOL) isLinkedWithFacebook;

@property (strong, nonatomic) PFUser *user;

@end
