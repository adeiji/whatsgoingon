//
//  DEAddValueViewController.m
//  whatsgoinon
//
//  Created by adeiji on 8/11/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import "DEAddValueViewController.h"

@interface DEAddValueViewController ()

@end

@implementation DEAddValueViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    DEAddValueView *view = (DEAddValueView *) self.view;
    
    [view.txtValue becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) okPressed:(id)sender
{
    DEAddValueView *view = (DEAddValueView *) self.view;
    [self.inputView performSelector:@selector(setText:) withObject:view.txtValue.text];

    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction) cancelPressed:(id)sender
{
    // Simply go back to the previous screen
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
