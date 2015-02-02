//
//  DESyncManager.h
//  whatsgoinon
//
//  Created by adeiji on 8/5/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DEPostManager.h"
#import "DEPost.h"

@class DEPost;

@interface DESyncManager : NSObject

// Get all the values from the Parse database
+ (void) getAllValuesForNow : (BOOL) now;
+ (PFObject *) getPFObjectWithValuesFromPost : (DEPost *) post
                                    PFObject : (PFObject *) postObject;
+ (void) updatePFObject : (PFObject *) postObject
     WithValuesFromPost : (DEPost *) post;
+ (BOOL) savePost : (DEPost *) post;
+ (void) saveReportWithEventId : (NSString * )objectId
                    WhatsWrong : (NSDictionary *) whatsWrong
                         Other : (NSString *) other;
+ (void) saveEventAsMiscategorizedWithEventId : (NSString *) objectId
                                     Category : (NSString *) category;
+ (void) saveObjectFromDictionary : (NSDictionary *) dictionary;
+ (void) updateObjectWithId : (NSString *) objectId
               UpdateValues : (NSDictionary *) values
             ParseClassName : (NSString *) className;
+ (void) saveCommentWithEventId : (NSString *) objectId
                        Comment : (NSString *) comment
                         Rating : (NSInteger) rating;
+ (void) getNumberOfPostByUser : (NSString *) username;
+ (void) saveUpdatedPFObjectToServer : (PFObject *) post;
+ (void) getEventsPostedByUser : (NSString *) username;
+ (void) updatePost : (DEPost *) post;
/*
 
 Get all the saved events that the user has selected has maybe or going
 
 */
+ (void) getAllSavedEvents;

// Pull all the comments for this specific event
+ (NSArray *) getAllCommentsForEventId : (NSString *) objectId;

/*
 
 Get all the values that are posted at a specific miles distance from the user
 
 */
+ (void) getAllValuesWithinMilesForNow : (BOOL) now
                            PostsArray : (NSMutableArray *) postsArray
                              Location : (PFGeoPoint *) location;

/*
 
 Get one post by its Id
 
 */
+ (void) getPostById : (NSString *) eventId
             Comment : (BOOL) comment;


+ (void) loadEpicEvents : (BOOL) epicEvents;

@end
