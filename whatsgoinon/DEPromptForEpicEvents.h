//
//  DEPromptForEpicEvents.h
//  whatsgoinon
//
//  Created by adeiji on 1/7/15.
//  Copyright (c) 2015 adeiji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DEScreenManager.h"
#import "DECreatePostViewController.h"
#import "DEViewEventsViewController.h"

@interface DEPromptForEpicEvents : UIView

@property (weak, nonatomic) IBOutlet UIButton *btnSure;
@property (weak, nonatomic) IBOutlet UIButton *btnNoThanks;

- (void) editButtons;

@end
