//
//  DEViewImagesViewController.m
//  whatsgoinon
//
//  Created by adeiji on 12/16/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import "DEViewImagesViewController.h"

@interface DEViewImagesViewController ()

@end

@implementation DEViewImagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.delegate = self;
    self.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.myViewControllers count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}


#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = (((DEViewImageViewController *) viewController).index);
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [_myViewControllers objectAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = (((DEViewImageViewController *) viewController).index);
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [_myViewControllers count]) {
        return nil;
    }
    return [_myViewControllers objectAtIndex:index];
}

@end
