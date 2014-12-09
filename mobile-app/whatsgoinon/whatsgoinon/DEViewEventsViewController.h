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

@class DEViewMainMenu;

@interface DEViewEventsViewController : UIViewController <UIScrollViewDelegate, MFMailComposeViewControllerDelegate, UISearchBarDelegate>
{
    int postCounter;
    DEViewMainMenu *viewMainMenu;
    BOOL menuDisplayed;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainViewLeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainViewRightConstraint;
@property (strong, nonatomic) NSArray *posts;
@property (strong, nonatomic) NSMutableArray *postsCopy;
@property (strong, nonatomic) NSMutableArray *searchPosts;
@property BOOL overlayDisplayed;

- (IBAction)displayMainMenu:(id)sender;
- (IBAction)goHome:(id)sender;
- (void) displayPost;
- (void) showMainMenu;
- (void) hideMainMenu;


@end
