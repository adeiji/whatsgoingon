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
+ (BOOL) savePost : (DEPost *) post;
+ (void) popToRootAndShowViewController : (UIViewController *) viewController;
+ (void) saveReportWithEventId : (NSString * )objectId
                    WhatsWrong : (NSDictionary *) whatsWrong
                         Other : (NSString *) other;
+ (void) saveEventAsMiscategorizedWithEventId : (NSString *) objectId
                                     Category : (NSString *) category;
+ (void) saveObjectFromDictionary : (NSDictionary *) dictionary;
+ (void) updateObjectWithId : (NSString *) objectId
               UpdateValues : (NSDictionary *) values
             ParseClassName : (NSString *) className;
@end
