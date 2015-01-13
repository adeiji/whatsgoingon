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
#import <MessageUI/MessageUI.h>
#import "DEMainViewController.h"
#import "DEPromptCommentView.h"

@class DEViewMainMenu;

@interface DEScreenManager : NSObject <MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate>
{
    UIActivityIndicatorView *spinner;
}

@property BOOL overlayDisplayed;
@property (strong, nonatomic) UIViewController *nextScreen;
@property (strong, nonatomic) NSMutableDictionary *values;
@property (strong, nonatomic) DEViewMainMenu *mainMenu;
@property BOOL isLater;

#pragma mark - Public Methods

+ (id)sharedManager;
+ (void) showCommentView : (DEPost *) post;
+ (void) hideCommentView;
+ (void) setUpTextFields : (NSArray *) textFields;
+ (UIView *) createInputAccessoryView;
+ (UINavigationController *) getMainNavigationController;
+ (void) setBackgroundWithImageURL : (NSString *) imageUrl;
+ (void) popToRootAndShowViewController : (UIViewController *) viewController;
/*
 
 Display a banner in 7 minutes asking the user to comment
 
 */
+ (void) createPromptUserCommentNotification : (DEPost *) post;

/*
 
 Display a screen similar to an iOS banner that asks the user if he wants to comment on the event that he just visited
 
 */
+ (void) promptForComment : (NSString *) eventId
                     Post : (DEPost *) myPost;
#pragma mark - Private Methods

- (void) gotoNextScreen;
- (void) showEmail;
- (void) showTextWithMessage : (NSString *) message ;
- (void) stopActivitySpinner;
- (void) startActivitySpinner;

@end
