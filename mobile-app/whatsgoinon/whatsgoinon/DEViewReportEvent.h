//
//  DEViewReportEvent.h
//  whatsgoinon
//
//  Created by adeiji on 8/15/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DEViewReportEvent : UIView

@property (weak, nonatomic) IBOutlet UISwitch *switchAbusive;
@property (weak, nonatomic) IBOutlet UISwitch *switchCrude;
@property (weak, nonatomic) IBOutlet UISwitch *switchNotReal;
@property (weak, nonatomic) IBOutlet UISwitch *switchInappropriate;
@property (weak, nonatomic) IBOutlet UISwitch *switchOther;

@property (weak, nonatomic) IBOutlet UITextView *txtNotes;

- (IBAction)cancelReport:(id)sender;
- (IBAction)reportEvent:(id)sender;



@end
