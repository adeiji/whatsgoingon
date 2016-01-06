//
//  DECommentTableViewCell.h
//  whatsgoinon
//
//  Created by adeiji on 9/23/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DECommentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblComment;
@property (weak, nonatomic) IBOutlet UIImageView *imgProfileView;
@property (weak, nonatomic) IBOutlet UIImageView *imgThumbView;

@end
