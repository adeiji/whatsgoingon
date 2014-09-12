//
//  DELoginViewController.h
//  whatsgoinon
//
//  Created by adeiji on 8/8/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DECreateAccountView.h"
#import "DEScreenManager.h"

@interface DELoginViewController : UIViewController

#pragma mark - IBOutlets

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttons;
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *textFields;

#pragma mark - Button Press Methods

- (IBAction)createAnAccount:(id)sender;

@end
