//
//  DEUserManager.m
//  whatsgoinon
//
//  Created by adeiji on 8/8/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import "DEUserManager.h"
#import "Constants.h"

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
- (BOOL) isLoggedIn
{
    PFUser *currentUser = [PFUser currentUser];
    
    if (currentUser) {
        _user = currentUser;
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
    _user.username = [userName lowercaseString];
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
                     ErrorLabel : (UILabel *)label
{
    [PFUser logInWithUsernameInBackground:[username lowercaseString] password:password block:^(PFUser *user, NSError *error) {
        if (user)
        {
            [DESyncManager popToRootAndShowViewController:viewController];
        }
        else {
            [self usernameExist:[username lowercaseString] ErrorLabel:label];
        }
    }];
    
    return nil;
}

- (BOOL) usernameExist : (NSString *) username
            ErrorLabel : (UILabel *) label
{
    PFQuery *query = [PFUser query];

    [query whereKey:PARSE_CLASS_USER_USERNAME equalTo:[username lowercaseString]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ([objects count] > 0)
        {
            [label setText:@"Incorrect password"];
        }
        else {
            [label setText:@"Username does not exist"];
        }
        
        [label setHidden:NO];
    }];
    
    return NO;
}

- (BOOL) isLinkedWithTwitter
{
    return [PFTwitterUtils isLinkedWithUser:[PFUser user]];
}

- (BOOL) isLinkedWithFacebook
{
    return [PFFacebookUtils isLinkedWithUser:[PFUser user]];
}
- (NSError *) loginWithTwitter {
    [PFTwitterUtils logInWithBlock:^(PFUser *user, NSError *error) {
        if (!user) {
            NSLog(@"Uh oh. The user cancelled the Twitter login.");
            [[DEScreenManager sharedManager] stopActivitySpinner];
            return;
        } else if (user.isNew) {
            NSLog(@"User signed up and logged in with Twitter!");
            DEScreenManager *screenManager = [DEScreenManager sharedManager];
            [screenManager gotoNextScreen];
            [[DEScreenManager sharedManager] stopActivitySpinner];
        } else {
            NSLog(@"User logged in with Twitter!");
            DEScreenManager *screenManager = [DEScreenManager sharedManager];
            [screenManager gotoNextScreen];
            [[DEScreenManager sharedManager] stopActivitySpinner];
        }
    }];
    
    return nil;
}

- (NSError *) linkWithTwitter
{
    if (![PFTwitterUtils isLinkedWithUser:_user]) {
        [PFTwitterUtils linkUser:_user block:^(BOOL succeeded, NSError *error) {
            if ([PFTwitterUtils isLinkedWithUser:_user]) {
                NSLog(@"Woohoo, user logged in with Twitter!");
            }
            else {
                // Uh oh, there was an error here!
                NSLog(@"%@", error);
            }
        }];
    }
    
    return nil;
}

- (NSError *) loginWithFacebook {
    
    NSArray *permissionsArray = @[@"user_about_me", @"user_relationships", @"user_birthday", @"user_location"];
    
    if (![PFUser currentUser] && // Check if a user is cached
        ![PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) // Check if user is linked to Facebook
    {
        [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
            // Display some sort of loading indicator
            
            if (!user) {
                if (!error) {
                    NSLog(@"The user cancelled the Facebook login.");
                    [[DEScreenManager sharedManager] stopActivitySpinner];
                }
                else {
                    NSLog(@"An error occured: %@", error);
                    [[DEScreenManager sharedManager] stopActivitySpinner];
                }
            }
            else if (user.isNew)
            {
                NSLog(@"User with facebook signed up and logged in");
                DEScreenManager *screenManager = [DEScreenManager sharedManager];
                [screenManager gotoNextScreen];
                [[DEScreenManager sharedManager] stopActivitySpinner];
            }
            else {
                NSLog(@"User with facebook logged in!");
                DEScreenManager *screenManager = [DEScreenManager sharedManager];
                [screenManager gotoNextScreen];
                [[DEScreenManager sharedManager] stopActivitySpinner];
            }
        }];
    }
    
    return nil;
}


@end
