//
//  DEViewImagesViewController.h
//  whatsgoinon
//
//  Created by adeiji on 12/16/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DEViewImageViewController.h"

/*

View all the images that are affiliated with a specific post
 
*/

@interface DEViewImagesViewController : UIPageViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (strong, nonatomic) NSArray *myViewControllers;
@property (strong, nonatomic) NSArray *images;

@end
