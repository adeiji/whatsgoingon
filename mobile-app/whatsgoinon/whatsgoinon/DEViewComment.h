//
//  DEViewComment.h
//  whatsgoinon
//
//  Created by adeiji on 8/19/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DESyncManager.h"
#import "DEPost.h"

@class DEPost;

@interface DEViewComment : UIView <UIPickerViewDataSource, UIPickerViewDelegate, UITextViewDelegate>
{
    NSArray *options;
    NSString *comment;
    NSInteger ratingChange;
}

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UILabel *lblPromptEntry;
@property (strong, nonatomic) DEPost *post;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttons;
@property (weak, nonatomic) IBOutlet UITextView *txtComment;

- (IBAction)submitComment:(id)sender;
- (IBAction)cancel:(id)sender;

- (IBAction)thumbsUp:(id)sender;
- (IBAction)thumbsDown:(id)sender;

@end
