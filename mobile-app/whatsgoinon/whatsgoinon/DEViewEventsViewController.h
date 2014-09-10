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

@interface DEViewEventsViewController : UIViewController 
{
    int postCounter;
    DEViewMainMenu *viewMainMenu;
    BOOL menuDisplayed;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) NSArray *posts;
@property BOOL *overlayDisplayed;


- (IBAction)displayMainMenu:(id)sender;
- (IBAction)goHome:(id)sender;


@end
