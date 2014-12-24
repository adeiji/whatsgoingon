//
//  DEPromptCommentView.h
//  whatsgoinon
//
//  Created by adeiji on 12/24/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DEPost.h"

@interface DEPromptCommentView : UIView
{
    DEPost *post;
}


@property (weak, nonatomic) IBOutlet UILabel *lblEventTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnComment;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;

- (IBAction)showCommentScreen:(id)sender;
- (IBAction)hideView:(id)sender;

- (void) showView;
- (id) initWithPost : (DEPost *) myPost;

@end
