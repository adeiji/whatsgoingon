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
                      ViewController : (UIViewController *) viewController
                          ErrorLabel : (UILabel *) label;
{
    _user.username = [userName lowercaseString];
    _user.password = password;
    _user.email = email;
    
    NSError *error;
    
    [[DEScreenManager sharedManager] startActivitySpinner];
    
    [_user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error)
        {
            [[DEScreenManager getMainNavigationController] pushViewController:viewController animated:YES];
        }
        else
        {
            label.hidden = NO;
            label.text = error.userInfo[@"error"];
        }
        
        [[DEScreenManager sharedManager] stopActivitySpinner];
    }];
    
    return error;
}

+ (void) addProfileImage : (NSData *) profileImageData
{
    PFObject *myUser = [PFUser currentUser];
    PFFile *imageFile = [PFFile fileWithData:profileImageData];
    myUser[PARSE_CLASS_USER_PROFILE_PICTURE] = imageFile;
    
    [myUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error)
        {
            NSLog(@"Sweet! The profile picture saved");
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:profileImageData forKey:@"profile-picture"];
            [userDefaults synchronize];
        }
        else
        {
            NSLog(@"Error saving the profile picture: %@", [error description]);
        }
    }];
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
        } else
        {
            [[[[DEScreenManager getMainNavigationController] topViewController] view] setHidden:YES];
            [[DEScreenManager sharedManager] gotoNextScreen];
            [[DEScreenManager sharedManager] stopActivitySpinner];
            [[DEScreenManager sharedManager] stopActivitySpinner];
            
            [self getTwitterProfilePicture : [PFTwitterUtils twitter].userId];
        }
    }];
    
    return nil;
}

- (void) getTwitterProfilePicture : (NSString *) username
{
    
    // Call the twitter API and get the profile image
    NSError *error;
    NSString *requestString = [NSString stringWithFormat:@"https://api.twitter.com/1.1/users/show.json?user_id=%@", username];
    NSURL *verify = [NSURL URLWithString:requestString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:verify];
    [[PFTwitterUtils twitter] signRequest:request];
    NSURLResponse *response = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if (!error)
    {
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        
        NSString *imageURLString = result[@"profile_image_url_https"];
        NSURL *url = [NSURL URLWithString:imageURLString];
        NSData *data = [NSData dataWithContentsOfURL:url];
        
        // Add the profile image from twitter
        [DEUserManager addProfileImage:data];
    }
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
            else
            {
                NSLog(@"User with facebook signed up and logged in");
                [[[[DEScreenManager getMainNavigationController] topViewController] view] setHidden:YES];
                [[DEScreenManager sharedManager] gotoNextScreen];
                [[DEScreenManager sharedManager] stopActivitySpinner];
                
                // Get the Facebook Profile Picture
                [self getFacebookProfilePicture];
            }
        }];
    }
    
    return nil;
}

// Get the Facebook Profile Picture
- (void) getFacebookProfilePicture
{
    [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error)
        {
            NSString *facebookId = [result objectForKey:@"id"];
            NSURL *profilePictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", facebookId]];
            
            NSData *imageData = [NSData dataWithContentsOfURL:profilePictureURL];
            [DEUserManager addProfileImage:imageData];
        }
    }];
}

@end
