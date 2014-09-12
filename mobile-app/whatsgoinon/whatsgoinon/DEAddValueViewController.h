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

@property (strong, nonatomic) id inputView;
@property (strong, nonatomic) UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *lblMinCharacters;
@property (weak, nonatomic) IBOutlet UILabel *lblTutorial;
@property (weak, nonatomic) IBOutlet UIView *overlayView;

#pragma mark - Outlet Button Methods

- (IBAction)okPressed:(id)sender;
- (IBAction)cancelPressed:(id)sender;

@end
