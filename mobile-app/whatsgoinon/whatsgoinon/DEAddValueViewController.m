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
    
    if(_isQuickDescription)
    {
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker set:kGAIScreenName value:@"QuickDesc"];
        [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    }
    else
    {
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker set:kGAIScreenName value:@"LongDesc"];
        [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    }
    
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
        [_lblTutorial setText:@"Start typing to begin...\n\nThe Quick Description is the first thing people will see for your event.\n\nYou only get 150 characters.\nUse them wisely to make it stand out."];
    }
    else {
        [_lblTutorial setText:@"Start typing to begin...\n\nThe Full Description will appear when someone opens your event.\n\nBe sure to include all the details."];
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
    int targetLength;
    int maxLength;
    if (!_isQuickDescription)
    {
        maxLength = 500;
        targetLength = maxLength - (int) newLength;
    }
    else {
        maxLength = 150;
        targetLength = maxLength - (int) newLength;
    }
    
    if (targetLength < 0)
    {
        NSMutableString *allText = [NSMutableString new];
        [allText appendString:textView.text];
        [allText appendString:text];
        
        textView.text = [allText substringToIndex:maxLength];
        self.lblMinCharacters.text = @"0";
        return NO;
    }
    else
    {
        self.lblMinCharacters.text = [NSString stringWithFormat:@"%u", maxLength - newLength];
    }
    
    
    return  YES;
}

@end
