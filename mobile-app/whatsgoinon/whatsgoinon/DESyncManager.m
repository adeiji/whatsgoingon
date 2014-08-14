//
//  DESyncManager.m
//  whatsgoinon
//
//  Created by adeiji on 8/5/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import "DESyncManager.h"
#import <Parse/Parse.h>
#import "Constants.h"


@implementation DESyncManager


+ (void) getAllValues {
    DEPostManager *sharedManager = [DEPostManager sharedManager];
    PFQuery *query = [PFQuery queryWithClassName:PARSE_CLASS_NAME];
    //Get all the events that are currently active
    [query whereKey:PARSE_CLASS_EVENT_ACTIVE equalTo:[NSNumber numberWithBool:true]];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error)
        {
            //The find succeeded, now do something with it
            //[sharedManager setPosts:objects];
            
            NSLog(@"Retreived all objects from server");
        }
        else {
            // The find failed, let the customer know
        }
    }];
    
}


+ (BOOL) savePost : (DEPost *) post {
    PFObject *postObject = [PFObject objectWithClassName:PARSE_CLASS_NAME];
    
    postObject[PARSE_CLASS_EVENT_TITLE] = post.title;
    postObject[PARSE_CLASS_EVENT_ADDRESS] = @"8605 Blowing Pines Drive, Las Veags, NV 89143";
    postObject[PARSE_CLASS_EVENT_DESCRIPTION] = post.description;
    postObject[PARSE_CLASS_EVENT_START_TIME] = post.startTime;
    postObject[PARSE_CLASS_EVENT_END_TIME] = post.endTime;
    postObject[PARSE_CLASS_EVENT_COST] = post.cost;
    postObject[PARSE_CLASS_EVENT_CATEGORY] = post.category;
    postObject[PARSE_CLASS_EVENT_ACTIVE] = [NSNumber numberWithBool:TRUE];
    postObject[PARSE_CLASS_EVENT_POST_RANGE] = @5.0;
    postObject[PARSE_CLASS_EVENT_LOCATION] = post.location;
    postObject[PARSE_CLASS_EVENT_IMAGES] = [self getImagesArrayWithArray:post.images];
    
    // If it saved successful return that it was successful and vice versa.
    [postObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded)
        {
            NSLog(@"Post Saved to Parse Server");
            [self getAllValues];
        }
    }];
    
    return YES;
}

+ (NSMutableArray *) getImagesArrayWithArray : (NSArray *) imageArray
{
    NSMutableArray *images = [NSMutableArray new];
    
    for (NSData *imageData in imageArray) {
        
        PFFile *imageFile = [PFFile fileWithName:@"post-image" data:imageData];
        
        [images addObject:imageFile];
    }
    
    return images;
}

// Display the new view controller, but remove all other views from the View Controller stack first.
+ (void) popToRootAndShowViewController : (UIViewController *) viewController
{
    // Successful login
    UINavigationController *navigationController = (UINavigationController *)[[[[UIApplication sharedApplication] delegate] window] rootViewController];
    
    [navigationController popToRootViewControllerAnimated:NO];
    [navigationController pushViewController:viewController animated:YES];
    
    [[viewController navigationController] setNavigationBarHidden:NO];

}

@end
