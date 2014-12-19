//
//  DEViewImageViewController.m
//  whatsgoinon
//
//  Created by adeiji on 12/16/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import "DEViewImageViewController.h"

@interface DEViewImageViewController ()

@end

@implementation DEViewImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_image getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        
        @autoreleasepool {
            NSData *imageData = data;
            UIImage *image = [UIImage imageWithData:imageData];
            
            [_imageView setImage:image];
            
        }
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
