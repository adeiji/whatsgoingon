//
//  DEScreenManager.h
//  whatsgoinon
//
//  Created by adeiji on 8/7/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DEViewComment.h"
#import "DEAnimationManager.h"

@class DEViewMainMenu;

@interface DEScreenManager : NSObject

@property BOOL overlayDisplayed;
@property (strong, nonatomic) UIViewController *nextScreen;
@property (strong, nonatomic) NSMutableDictionary *values;
@property (strong, nonatomic) DEViewMainMenu *mainMenu;

#pragma mark - Public Methods

+ (id)sharedManager;
+ (void) showCommentView;
+ (void) hideCommentView;
+ (void) setUpTextFields : (NSArray *) textFields;
+ (UIView *) createInputAccessoryView;

#pragma mark - Private Methods

- (void) gotoNextScreen;

@end
