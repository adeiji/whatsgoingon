//
//  DEEventDetailsView.h
//  whatsgoinon
//
//  Created by adeiji on 8/11/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DEPost.h"
#import "DEAmbassadorFlag.h"

@interface DEEventDetailsView : UIView
@property (weak, nonatomic) IBOutlet UITextView *txtDescription;
@property (weak, nonatomic) IBOutlet UILabel *lblCost;
@property (weak, nonatomic) IBOutlet UILabel *lblNumberGoing;
@property (weak, nonatomic) IBOutlet UILabel *lblTimeUntilStartsOrEnds;
@property (weak, nonatomic) IBOutlet UILabel *lblEndsInStartsIn;
@property (weak, nonatomic) IBOutlet UILabel *lblDuration;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;
@property (weak, nonatomic) IBOutlet DEAmbassadorFlag *ambassadorFlagView;
@property (weak, nonatomic) IBOutlet UIButton *btnUsername;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *lblLevel;
@property BOOL isLoaded;


@end
