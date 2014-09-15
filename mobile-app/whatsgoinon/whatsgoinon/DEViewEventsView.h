//
//  DEViewEvents.h
//  whatsgoinon
//
//  Created by adeiji on 8/5/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DEPost.h"
#import "DEEventsTimeline.h"
#import "DEScreenManager.h"
#import "DELocationManager.h"
#import "DEEventViewController.h"
#import "DEViewComment.h"

@interface DEViewEventsView : UIView <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imgMainImageView;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblDistance;
@property (weak, nonatomic) IBOutlet UILabel *lblSubtitle;
@property (weak, nonatomic) IBOutlet UILabel *lblNumGoing;

@property (weak, nonatomic) DEEventsTimeline *overlayView;
@property (strong, nonatomic) DEPost *post;

- (void) renderViewWithPost : (DEPost *) post;
- (void) refreshView;
@end
