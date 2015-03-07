//
//  DEViewEventsViewController.h
//  whatsgoinon
//
//  Created by adeiji on 8/5/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DEPostManager.h"
#import "DEViewEventsView.h"
#import "DEScreenManager.h"
#import "DELocationManager.h"
#import "DESelectCategoryView.h"
#import "DEViewMainMenu.h"
#import <Masonry/Masonry.h>
#import "DEWelcomeEventView.h"

@class DEViewMainMenu;

@interface DEViewEventsViewController : UIViewController <UIScrollViewDelegate, MFMailComposeViewControllerDelegate, UISearchBarDelegate, UIGestureRecognizerDelegate>
{
    DEViewMainMenu *viewMainMenu;
    BOOL menuDisplayed;
    NSString *category;
    UIView *outerView;
    UIButton *orbView;
    SEL postSelector;
    CGFloat lastContentOffset;
    UIActivityIndicatorView *spinner;
    BOOL welcomeScreen;
    DEWelcomeEventView *welcomeView;
}

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainViewLeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainViewRightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *lblCategoryHeader;
@property (strong, nonatomic) NSArray *posts;
@property (strong, nonatomic) NSMutableArray *postsCopy;
@property (strong, nonatomic) NSMutableArray *searchPosts;
@property BOOL shouldNotDisplayPosts;
@property BOOL overlayDisplayed;
@property BOOL now;
@property BOOL isNewProcess;

- (IBAction)showCreatePostScreen:(id)sender;
- (IBAction)displayMainMenu:(id)sender;
- (IBAction)goHome:(id)sender;
- (void) displayPost : (NSNotification *) notification
           TopMargin : (CGFloat) topMargin
           PostArray : (NSArray *) postArray;
- (void) showMainMenu;
- (void) hideMainMenu;


@end
