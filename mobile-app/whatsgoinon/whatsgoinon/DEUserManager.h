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
                               Email : (NSString *) email
                      ViewController : (UIViewController *) viewController
                          ErrorLabel : (UILabel *) label;

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
- (void) saveItemToArray : (NSString *) item
         ParseColumnName : (NSString *) columnName;

+ (void) addProfileImage : (NSData *) profileImageData;
+ (void) getUserRank;

@property (strong, nonatomic) PFUser *user;

@end
