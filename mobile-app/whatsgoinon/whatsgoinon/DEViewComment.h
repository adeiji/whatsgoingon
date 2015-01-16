//
//  DEViewComment.h
//  whatsgoinon
//
//  Created by adeiji on 8/19/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DESyncManager.h"
#import "DEScreenManager.h"
#import "DEPost.h"
#import "UIView+DEScrollOnShowKeyboard.h"

@class DEPost;

@interface DEViewComment : UIView <UIPickerViewDataSource, UIPickerViewDelegate, UITextViewDelegate>
{
    NSArray *options;
    NSString *comment;
    NSInteger ratingChange;
    DEPost *post;
}

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UILabel *lblPromptEntry;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttons;
@property (weak, nonatomic) IBOutlet UITextView *txtComment;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *commentButtons;
@property (weak, nonatomic) IBOutlet UILabel *lblHeader;
@property (weak, nonatomic) IBOutlet UIButton *btnThumbsUp;
@property (weak, nonatomic) IBOutlet UIButton *btnThumbsDown;
@property (weak, nonatomic) IBOutlet UILabel *lblMinCharacters;

- (IBAction)submitComment:(id)sender;
- (IBAction)cancel:(id)sender;

- (IBAction)thumbsUp:(id)sender;
- (IBAction)thumbsDown:(id)sender;

- (void) setPost : (DEPost *) myPost;

@end
