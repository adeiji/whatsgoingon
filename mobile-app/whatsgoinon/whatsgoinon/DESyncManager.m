//
//  DESyncManager.m
//  whatsgoinon
//
//  Created by adeiji on 8/5/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import "DESyncManager.h"
#import <Parse/Parse.h>


@implementation DESyncManager

#define CLASS_NAME @"Event"
#define ACTIVE @"active"
#define TITLE @"name"
#define ADDRESS @"address"
#define DESCRIPTION @"description"
#define START_TIME @"starttime"
#define END_TIME @"endtime"
#define COST @"cost"
#define CATEGORY @"category"
#define POST_RANGE @"postrange"
#define USER @"user"
#define LOCATION @"location"
#define IMAGES @"images"

+ (void) getAllValues {
    DEPostManager *sharedManager = [DEPostManager sharedManager];
    PFQuery *query = [PFQuery queryWithClassName:CLASS_NAME];
    //Get all the events that are currently active
    [query whereKey:ACTIVE equalTo:[NSNumber numberWithBool:true]];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error)
        {
            //The find succeeded, now do something with it
            [sharedManager setPosts:objects];
            
            NSLog(@"Retreived all objects from server");
        }
        else {
            // The find failed, let the customer know
        }
    }];
    
}


+ (BOOL) savePost : (DEPost *) post {
    PFObject *postObject = [PFObject objectWithClassName:CLASS_NAME];
    
    postObject[TITLE] = post.title;
    postObject[ADDRESS] = @"8605 Blowing Pines Drive, Las Veags, NV 89143";
    postObject[DESCRIPTION] = post.description;
    postObject[START_TIME] = post.startTime;
    postObject[END_TIME] = post.endTime;
    postObject[COST] = post.cost;
    postObject[CATEGORY] = post.category;
    postObject[ACTIVE] = [NSNumber numberWithBool:TRUE];
    postObject[POST_RANGE] = @5.0;
    postObject[LOCATION] = post.location;
    postObject[IMAGES] = [self getImagesArrayWithArray:post.images];
    
    // If it saved successful return that it was successful and vice versa.
    [postObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded)
        {
            NSLog(@"Post Saved to Parse Server");
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

@end
