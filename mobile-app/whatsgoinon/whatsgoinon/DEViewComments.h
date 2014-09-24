//
//  DEViewComments.h
//  whatsgoinon
//
//  Created by adeiji on 9/23/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DEPost.h"
#import "DECommentTableViewCell.h"

@interface DEViewComments : UIView <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) DEPost *post;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
