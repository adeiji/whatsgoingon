//
//  DEViewReportEvent.h
//  whatsgoinon
//
//  Created by adeiji on 8/15/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+DEScrollOnShowKeyboard.h"
#import "DEPost.h"
#import "DESyncManager.h"

@interface DEViewReportEvent : UIView <UITextViewDelegate>
{
    UITextView *activeField;
}
@property (weak, nonatomic) IBOutlet UISwitch *switchAbusive;
@property (weak, nonatomic) IBOutlet UISwitch *switchCrude;
@property (weak, nonatomic) IBOutlet UISwitch *switchNotReal;
@property (weak, nonatomic) IBOutlet UISwitch *switchInappropriate;
@property (weak, nonatomic) IBOutlet UISwitch *switchOther;
@property (weak, nonatomic) IBOutlet UITextView *txtNotes;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttons;

@property (strong, nonatomic) NSString *eventId;

- (IBAction)cancelReport:(id)sender;
- (IBAction)reportEvent:(id)sender;
- (IBAction)enableReportDetailsTextView:(id)sender;
- (void) registerForKeyboardNotifications;

@end

@interface DEReport : NSObject

@property (strong, nonatomic) NSString *other;
@property (strong, nonatomic) NSDictionary *whatsWrong;

@end