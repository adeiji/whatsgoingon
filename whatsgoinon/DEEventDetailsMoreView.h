//
//  DEEventDetailsMoreView.h
//  whatsgoinon
//
//  Created by adeiji on 8/15/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DECreatePostViewController.h"
#import "DEViewReportEvent.h"
#import "DEAnimationManager.h"

@interface DEEventDetailsMoreView : UIView

@property (weak, nonatomic) IBOutlet UIButton *btnPostSomethingSimilar;
@property (weak, nonatomic) IBOutlet UIButton *btnReportEvent;
@property (weak, nonatomic) IBOutlet UIButton *btnMiscategorized;
@property (strong, nonatomic) NSString *eventId;
@property (strong, nonatomic) NSString *category;

- (IBAction)postSomethingSimilar:(id)sender;
- (IBAction)reportEvent:(id)sender;
- (IBAction)setAsMiscategorized:(id)sender;

- (void) loadView;



@end
