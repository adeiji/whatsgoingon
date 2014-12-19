//
//  DEViewImageViewController.h
//  whatsgoinon
//
//  Created by adeiji on 12/16/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface DEViewImageViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) PFFile *image;
@property NSUInteger index;

@end
