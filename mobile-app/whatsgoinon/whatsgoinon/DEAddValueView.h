//
//  DEAddValueView.h
//  whatsgoinon
//
//  Created by adeiji on 8/11/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DEAddValueView : UIView

#pragma mark - View Outlets

@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UIButton *btnOk;
@property (weak, nonatomic) IBOutlet UITextView *txtValue;
@property (weak, nonatomic) IBOutlet UILabel *lblPrompt;

@end
