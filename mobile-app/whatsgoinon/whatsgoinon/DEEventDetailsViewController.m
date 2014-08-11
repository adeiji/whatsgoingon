//
//  DEEventDetailsViewController.m
//  whatsgoinon
//
//  Created by adeiji on 8/11/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import "DEEventDetailsViewController.h"

@interface DEEventDetailsViewController ()

@end

@implementation DEEventDetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.viewNoComments = [[[NSBundle mainBundle] loadNibNamed:nibNameOrNil owner:self options:nil] objectAtIndex:0];
        self.viewShare = [[[NSBundle mainBundle] loadNibNamed:nibNameOrNil owner:self options:nil] objectAtIndex:1];
        self.viewMore = [[[NSBundle mainBundle] loadNibNamed:nibNameOrNil owner:self options:nil] objectAtIndex:2];
        self.viewSocialNetworkShare = [[[NSBundle mainBundle] loadNibNamed:nibNameOrNil owner:self options:nil] objectAtIndex:3];
        self.viewInfo = [[[NSBundle mainBundle] loadNibNamed:nibNameOrNil owner:self options:nil] objectAtIndex:4];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
