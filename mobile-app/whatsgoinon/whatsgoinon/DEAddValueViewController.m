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
    [[view.btnCancel layer] setCornerRadius:view.btnCancel.frame.size.height / 2.0f];
    [[view.btnOk layer] setCornerRadius:view.btnOk.frame.size.height / 2.0f];
    
    [view.btnCancel setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [view.btnOk setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];

}

/*

Show the tutorial showing the user what should be entered for the different description types
 
*/

- (void) showTutorial {
    if (_isQuickDescription)
    {
        [_lblTutorial setText:@"The quick description will be visible underneath your main image while scrolling events. Use the quick description to attract your attendees at a glance with keywords that make your event stand out. This field is limited to 150 characters or less so use them wisely."];
    }
    else {
        [_lblTutorial setText:@"The full description will be visible inside your event post info. This should contain all the detail that you want everyone to know about your event. Include everything that pertains to your event including additional costs if any. Be careful with profanity as it may get your post removed."];
    }

    [_overlayView setAlpha:1.0];
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
    
    DEPost *post = [[DEPostManager sharedManager] currentPost];
    
    if (_isQuickDescription)
    {
        post.quickDescription = view.txtValue.text;
    }
    else
    {
        post.myDescription = view.txtValue.text;
    }

    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction) cancelPressed:(id)sender
{
    // Simply go back to the previous screen
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSUInteger newLength = [textView.text length] + [text length] - range.length;
    
    if (newLength > 0)
    {
        [UIView animateWithDuration:.2 animations:^{
            [_overlayView setAlpha:0.0f];
        }];
    }
    else
    {
        [UIView animateWithDuration:.2 animations:^{
            [_overlayView setAlpha:1.0f];
        }];
    }
    
    // Get how many characters are available to be entered after the data is pasted
    int targetLength = 150 - (int) newLength;
    
    if (!_isQuickDescription && targetLength > -1)
    {
        self.lblMinCharacters.text = [NSString stringWithFormat:@"%lu", 150 - newLength];
    }
    else
    {
        self.lblMinCharacters.text = @"0";
    }
    
    targetLength = 150 - (int) newLength;
    
    if (_isQuickDescription)
    {
        if (targetLength < 0)
        {
            NSMutableString *allText = [NSMutableString new];
            [allText appendString:textView.text];
            [allText appendString:text];
            
            textView.text = [allText substringToIndex:150];
            
            return NO;
        }
        else
        {
            self.lblMinCharacters.text = [NSString stringWithFormat:@"%lu", 150 - newLength];
        }
    }
    
    return  YES;
}

@end
