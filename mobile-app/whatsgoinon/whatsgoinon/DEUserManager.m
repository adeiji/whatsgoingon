//
//  DEUserManager.m
//  whatsgoinon
//
//  Created by adeiji on 8/8/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import "DEUserManager.h"

@implementation DEUserManager

+ (id)sharedManager {
    static DEUserManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        _user = [PFUser user];
    }
    return self;
}
// Check to see if there is a current user logged in and returns the result
+ (BOOL) isLoggedIn
{
    PFUser *currentUser = [PFUser currentUser];
    
    if (currentUser) {
        return YES;
    }
    else {
        return NO;
    }
}

- (NSError *) createUserWithUserName : (NSString *) userName
                       Password : (NSString *) password
                          Email : (NSString *) email
{
    _user.username = userName;
    _user.password = password;
    _user.email = email;
    
    NSError *error;
#warning This will block the main thread, so you may need to change before production
    [_user signUp:&error];

    return error;
}

- (NSError *) loginWithUsername : (NSString *) username
                       Password : (NSString *) password
                 ViewController : (UIViewController *)viewController
{
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error) {
        if (user)
        {
            // Successful login
            UINavigationController *navigationController = (UINavigationController *)[[[[UIApplication sharedApplication] delegate] window] rootViewController];
            
            [navigationController popToRootViewControllerAnimated:NO];
            [navigationController pushViewController:viewController animated:YES];
            
            [[viewController navigationController] setNavigationBarHidden:NO];
        }
        else {
            // Login failed, check error to see why.
        }
    }];
    
    return nil;
}

@end
