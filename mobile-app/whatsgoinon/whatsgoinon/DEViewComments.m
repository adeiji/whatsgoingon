//
//  DEViewComments.m
//  whatsgoinon
//
//  Created by adeiji on 9/23/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import "DEViewComments.h"

@implementation DEViewComments

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_post.comments count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DECommentTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"ViewMadeComments" owner:self options:nil] objectAtIndex:1];
    
    [cell setBackgroundColor:[UIColor clearColor]];
    cell.lblComment.text = _post.comments[indexPath.row];
    [[cell.imgProfileView layer] setCornerRadius:cell.imgProfileView.frame.size.height / 2.0f];
    [cell.imgProfileView setImage:[UIImage imageNamed:@"profile-pic.jpg"]];
    [cell.imgProfileView setClipsToBounds:YES];
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85.0f;
}

#pragma mark - Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


@end
