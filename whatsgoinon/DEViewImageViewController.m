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
    
    if ([_image isKindOfClass:[NSData class]])
    {
        _image = [PFFile fileWithData:(NSData *) _image];
    }
    
    [_image getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        
        @autoreleasepool {
            NSData *imageData = data;
            UIImage *image = [UIImage imageWithData:imageData];
            
            [_imageView setImage:image];
            [self adjustImageViewToImageSize:image];
        }
    }];

    [[_imageView layer] setCornerRadius:BUTTON_CORNER_RADIUS * 2];
    [[_imageView layer] setBorderColor:[UIColor whiteColor].CGColor];
    [[_imageView layer] setBorderWidth:2.0f];
    _imageView.clipsToBounds = YES;
    [_lblTitle setText:_postTitle];
    
}

- (void) adjustImageViewToImageSize : (UIImage *) image {
    double maximumHeight = [[UIScreen mainScreen] bounds].size.height - 200.0f;
    [_imageView setContentMode:UIViewContentModeScaleAspectFit];
    CGSize imageSize        = image.size;
    _imageViewWidthConstraint.constant = [[UIScreen mainScreen] bounds].size.width - 32;
    CGSize imageViewSize    = CGSizeMake(_imageViewWidthConstraint.constant, _imageViewHeightConstraint.constant);
    CGFloat correctImageViewHeight = (imageViewSize.width / imageSize.width) * imageSize.height;
    
    if (correctImageViewHeight > maximumHeight)
    {
        double scaleMultiplier = maximumHeight / correctImageViewHeight;
        _imageViewHeightConstraint.constant = correctImageViewHeight * scaleMultiplier;
        _imageViewWidthConstraint.constant = _imageViewWidthConstraint.constant * scaleMultiplier;
    }
    else {
        _imageViewHeightConstraint.constant = correctImageViewHeight;
    }
    [_imageView layoutIfNeeded];
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
