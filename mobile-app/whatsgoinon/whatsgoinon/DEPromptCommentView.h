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

/*
 
 The label that contains the name of the event that we are prompting the user to comment on
 
 */
@property (weak, nonatomic) IBOutlet UILabel *lblEventTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnComment;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;

/*
 
 If the user decides that he is going to comment on this post then remove the banner and show the comment screen
 
 */
- (IBAction)showCommentScreen:(id)sender;
/*
 
 Animate the view out of the screen
 
 */

- (IBAction)hideView:(id)sender;
/*
 
 Show a view that is similar to the iOS banner at the top of the screen prompting the user to comment
 
 */
- (void) showView;
- (id) initWithPost : (DEPost *) myPost;

@end
