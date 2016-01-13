//
//  DESortingView.h
//  whatsgoinon
//
//  Created by adeiji on 5/24/15.
//  Copyright (c) 2015 adeiji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DESortingView : UIView

@property (weak, nonatomic) IBOutlet UIButton *btnTrending;
@property (weak, nonatomic) IBOutlet UIButton *btnNearMe;
@property (weak, nonatomic) IBOutlet UIButton *btnStartTime;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;

- (id) initWithOwner : (id) owner;

@end
