//
//  DESyncManager.h
//  whatsgoinon
//
//  Created by adeiji on 8/5/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DEPost.h"

@interface DESyncManager : NSObject

// Get all the values from the Parse database
+ (NSArray *) getAllValues;
+ (BOOL) savePost : (DEPost *) post;

@end
