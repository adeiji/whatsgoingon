//
//  DEViewComments.m
//  whatsgoinon
//
//  Created by adeiji on 9/23/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import "DEViewComments.h"
#import "Constants.h"

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
    return [_comments count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DECommentTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"ViewMadeComments" owner:self options:nil] objectAtIndex:1];
    
    if (_comments[indexPath.row][PARSE_CLASS_COMMENT_THUMBS_UP] == [NSNumber numberWithBool:NO])
    {
        CGRect frame = cell.lblComment.frame;
        frame.origin.x = 20;
        [cell.lblComment setFrame:frame];
        
        frame = cell.imgProfileView.frame;
        frame.origin.x = 185;
        [cell.imgProfileView setFrame:frame];
        
        frame = cell.imgThumbView.frame;
        frame.origin.x = 278;
        [cell.imgThumbView setFrame:frame];
        
        [cell.imgThumbView setImage:[UIImage imageNamed:@"thumbs-down.png"]];
    }
    
    [cell layoutSubviews];
    
    [cell setBackgroundColor:[UIColor clearColor]];
    cell.lblComment.text = _comments[indexPath.row][PARSE_CLASS_COMMENT_COMMENT];
    [[cell.imgProfileView layer] setCornerRadius:cell.imgProfileView.frame.size.height / 2.0f];;
    
    PFObject *user = (PFObject *) _comments[indexPath.row][PARSE_CLASS_COMMENT_USER];
    [user fetchIfNeeded];
    if (!user[PARSE_CLASS_USER_PROFILE_PICTURE])
    {
        [cell.imgProfileView setImage:[UIImage imageNamed:@"profile-pic.jpg"]];
    }
    else
    {
        PFFile *profileImage = _comments[indexPath.row][PARSE_CLASS_COMMENT_USER][PARSE_CLASS_USER_PROFILE_PICTURE];
        
        [profileImage getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            UIImage *image = [UIImage imageWithData:data];
            [cell.imgProfileView setImage:image];
        }];
    }
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
