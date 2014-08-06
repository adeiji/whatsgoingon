//
//  DEViewEvents.h
//  whatsgoinon
//
//  Created by adeiji on 8/5/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DEPost.h"

@interface DEViewEventsView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *imgMainImageView;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblSubtitle;
@property (weak, nonatomic) IBOutlet UILabel *lblDistance;

- (void) renderViewWithPost : (DEPost *) post;

@end
