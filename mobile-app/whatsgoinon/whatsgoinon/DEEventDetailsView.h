//
//  DEEventDetailsView.h
//  whatsgoinon
//
//  Created by adeiji on 8/11/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DEPost.h"

@interface DEEventDetailsView : UIView
@property (weak, nonatomic) IBOutlet UITextView *txtDescription;
@property (weak, nonatomic) IBOutlet UILabel *lblCost;
@property (weak, nonatomic) IBOutlet UILabel *lblNumberGoing;
@property (weak, nonatomic) IBOutlet UILabel *lblTimeUntilStartsOrEnds;
@property (weak, nonatomic) IBOutlet UILabel *lblEndsInStartsIn;

@end
