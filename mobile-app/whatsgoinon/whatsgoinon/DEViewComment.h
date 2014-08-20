//
//  DEViewComment.h
//  whatsgoinon
//
//  Created by adeiji on 8/19/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DEViewComment : UIView <UIPickerViewDataSource, UIPickerViewDelegate, UITextViewDelegate>
{
    NSArray *options;
}

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

- (IBAction)submitComment:(id)sender;
- (IBAction)cancel:(id)sender;


@end
