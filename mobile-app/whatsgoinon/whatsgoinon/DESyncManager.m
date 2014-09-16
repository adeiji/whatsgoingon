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
    PFQuery *query = [PFQuery queryWithClassName:PARSE_CLASS_NAME_EVENT];
    //Get all the events that are currently active
    [query whereKey:PARSE_CLASS_EVENT_ACTIVE equalTo:[NSNumber numberWithBool:true]];
    [query whereKey:PARSE_CLASS_EVENT_END_TIME greaterThan:[NSDate date]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error)
        {
            //The find succeeded, now do something with it
            [sharedManager setPosts:objects];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CENTER_ALL_EVENTS_LOADED object:nil];
            
            if ([objects count] != 0)
            {
                NSLog(@"Retreived all objects from server");
//                [DEScreenManager showCommentView];
            }
        }
        else {
            // The find failed, let the customer know
        }
    }];
    
}

+ (void) saveObjectFromDictionary:(NSDictionary *)dictionary
{
    
}

+ (void) updateObjectWithId:(NSString *)objectId
               UpdateValues:(NSDictionary *)values
             ParseClassName:(NSString *) className;
{
    PFQuery *query = [PFQuery queryWithClassName:className];
    
    [query getObjectInBackgroundWithId:objectId block:^(PFObject *object, NSError *error) {
        for (NSString *key in values) {
            id value = [values objectForKey:key];
            object[key] = value;
        }
        
        [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded)
            {
                NSLog(@"Saved successfully");
            }
            else
            {
                NSLog(@"%@", error.description);
            }
        }];
    }];
}

+ (BOOL) savePost : (DEPost *) post {
    DEPostManager *sharedManager = [DEPostManager sharedManager];
    PFObject *postObject = [PFObject objectWithClassName:PARSE_CLASS_NAME_EVENT];
    
    postObject[PARSE_CLASS_EVENT_TITLE] = post.title;
    postObject[PARSE_CLASS_EVENT_ADDRESS] = post.address;
    postObject[PARSE_CLASS_EVENT_DESCRIPTION] = post.description;
    postObject[PARSE_CLASS_EVENT_START_TIME] = post.startTime;
    postObject[PARSE_CLASS_EVENT_END_TIME] = post.endTime;
    postObject[PARSE_CLASS_EVENT_COST] = post.cost;
    postObject[PARSE_CLASS_EVENT_CATEGORY] = post.category;
    postObject[PARSE_CLASS_EVENT_ACTIVE] = [NSNumber numberWithBool:TRUE];
    postObject[PARSE_CLASS_EVENT_POST_RANGE] = post.postRange;
    postObject[PARSE_CLASS_EVENT_LOCATION] = post.location;
    postObject[PARSE_CLASS_EVENT_IMAGES] = [self getImagesArrayWithArray:post.images];
    postObject[PARSE_CLASS_EVENT_QUICK_DESCRIPTION] = post.quickDescription;
    postObject[PARSE_CLASS_EVENT_NUMBER_GOING] = post.numberGoing;
    postObject[PARSE_CLASS_EVENT_COMMENTS] = post.comments;
    
    // If it saved successful return that it was successful and vice versa.
    [postObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded)
        {
            NSLog(@"Post Saved to Parse Server");
            NSMutableArray *array = [NSMutableArray arrayWithArray : [sharedManager posts]];
            [array addObject:postObject];
            
            [sharedManager setPosts:array];
        }
    }];
    
    return YES;
}

+ (void) saveEventAsMiscategorizedWithEventId : (NSString *) objectId
                                     Category : (NSString *) category
{
    PFObject *miscategorizedEventObject = [PFObject objectWithClassName:PARSE_CLASS_NAME_MISCATEGORIZED_EVENT];
    miscategorizedEventObject[PARSE_CLASS_MISCATEGORIZED_EVENT_ID] = objectId;
    miscategorizedEventObject[PARSE_CLASS_MISCATEGORIZED_EVENT_CATEGORY] = category;
    
    [miscategorizedEventObject saveEventually:^(BOOL succeeded, NSError *error){
        if (succeeded)
        {
            NSLog(@"You set the current object as miscategorized successfully");
        }
    }];
}

+ (void) saveReportWithEventId : (NSString * )objectId
                    WhatsWrong : (NSDictionary *) whatsWrong
                         Other : (NSString *) other
{
    
    PFObject *reportObject = [PFObject objectWithClassName:PARSE_CLASS_NAME_REPORT];
    
    reportObject[PARSE_CLASS_REPORT_EVENT_ID] = objectId;
    reportObject[PARSE_CLASS_REPORT_WHATS_WRONG] = whatsWrong;
    reportObject[PARSE_CLASS_REPORT_OTHER] = other;
    
    [reportObject saveEventually:^(BOOL succeeded, NSError *error) {
        if (succeeded)
        {
            NSLog(@"The report was saved to the server");
        }
    }];
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

#warning This should not be here, it needs to be moved to the Screen Manager
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
