//
//  DEEventsTimeline.h
//  whatsgoinon
//
//  Created by adeiji on 8/5/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DEEventsTimeline : UIView

@property (weak, nonatomic) IBOutlet UILabel *lblTimeUntilStartsOrEnds;
@property (weak, nonatomic) IBOutlet UILabel *lblEndsInStartsIn;
@property (weak, nonatomic) IBOutlet UILabel *lblDuration;

@end
