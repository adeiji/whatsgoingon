//
//  DEAddValueViewController.h
//  whatsgoinon
//
//  Created by adeiji on 8/11/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DEScreenManager.h"
#import "DEAddValueView.h"

@interface DEAddValueViewController : UIViewController <UITextViewDelegate>

/*
 
 The field which will contain the information that comes from this view controller
 
 */
@property (strong, nonatomic) id inputView;

@property (strong, nonatomic) UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *lblMinCharacters;
@property (weak, nonatomic) IBOutlet UILabel *lblTutorial;
@property (weak, nonatomic) IBOutlet UIView *overlayView;
@property BOOL isQuickDescription;
#pragma mark - Outlet Button Methods

- (IBAction)okPressed:(id)sender;
- (IBAction)cancelPressed:(id)sender;

/*
 
 Display a tutorial letting the user know how to enter in data
 
*/
- (void) showTutorial;
@end
