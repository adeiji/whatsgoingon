//
//  DEViewImageViewController.h
//  whatsgoinon
//
//  Created by adeiji on 12/16/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Constants.h"

@interface DEViewImageViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) PFFile *image;
@property (weak, nonatomic) NSString *postTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property NSUInteger index;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewWidthConstraint;

- (IBAction)goBack:(id)sender;

@end
