//
//  DEPromptCommentView.m
//  whatsgoinon
//
//  Created by adeiji on 12/24/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import "DEPromptCommentView.h"

@implementation DEPromptCommentView

- (id) initWithPost : (DEPost *) myPost
{
    if (self = [super init])
    {
        self = [[[NSBundle mainBundle] loadNibNamed:@"ViewComment" owner:self options:nil] lastObject];
        CGRect frame = self.frame;
        frame.origin.y = -self.frame.size.height;
        
        [self setFrame:frame];
        post = myPost;
        [_lblEventTitle setText:post.title];
    }
    
    return self;
}

/*
 
 Show a view that is similar to the iOS banner at the top of the screen prompting the user to comment
 
 */
- (void) showView {
    
    [[_btnCancel layer] setCornerRadius:BUTTON_CORNER_RADIUS];
    [[_btnComment layer] setCornerRadius:BUTTON_CORNER_RADIUS];
    [_lblEventTitle setText:[NSString stringWithFormat:@"%@ @ %@", post.title, post.address]];
    
    [UIView animateWithDuration:.5 animations:^{
        CGRect frame = self.frame;
        frame.origin.y = 0;
        
        [self setFrame:frame];
    }];
}

/*
 
 If the user decides that he is going to comment on this post then remove the banner and show the comment screen
 
 */
- (IBAction)showCommentScreen:(id)sender {
    
    [DEScreenManager showCommentView:post];
    [self removeViewFromScreen];
    
}

/*
 
 Animate the view out of the screen
 
 */
- (void) removeViewFromScreen {
    [UIView animateWithDuration:.5 animations:^{
        CGRect frame = self.frame;
        frame.origin.y = -self.frame.size.height;
        
        [self setFrame:frame];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (IBAction)hideView:(id)sender {
    
    [self removeViewFromScreen];
    
}
@end
