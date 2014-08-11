//
//  DEEventViewController.m
//  whatsgoinon
//
//  Created by adeiji on 8/11/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import "DEEventViewController.h"

@interface DEEventViewController ()

@end

@implementation DEEventViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _eventDetailsViewController = [[DEEventDetailsViewController alloc] initWithNibName:@"EventDetailsView" bundle:[NSBundle mainBundle]];
    
    if (_isPreview)
    {
        [[_eventView btnGoing] setEnabled:NO];
        [[_eventView btnMaybe] setEnabled:NO];
        
        UIImage *mainImage = [[_post images] firstObject];
        
        [[_eventView imgMainImage] setImage:mainImage];
        [[_eventView lblCost] setText:[[_post cost] stringValue]];
        [[_eventView lblNumberOfPeopleGoing] setText:0];
    }
    
    [self showView:[_eventDetailsViewController viewInfo]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) showView : (UIView *) newView {
    UIView *view = [[[_eventView detailsView] subviews] lastObject];
    [view removeFromSuperview];
    view = [_eventView detailsView];
    [view addSubview:newView];
}

#pragma mark - Button Action Methods

- (IBAction)showEventDetails:(id)sender
{
    [self showView:[_eventDetailsViewController viewInfo]];
}
- (IBAction)showEventComments:(id)sender
{
    [self showView:[_eventDetailsViewController viewNoComments]];
}
- (IBAction)shareEvent:(id)sender
{
    [self showView:[_eventDetailsViewController viewSocialNetworkShare]];
}
- (IBAction)viewMoreForEvent:(id)sender
{
    [self showView:[_eventDetailsViewController viewMore]];
}

@end
