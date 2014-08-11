//
//  DEViewEvents.m
//  whatsgoinon
//
//  Created by adeiji on 8/5/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import "DEViewEventsView.h"
#import <Parse/Parse.h>

@implementation DEViewEventsView

#define OVERLAY_VIEW 1

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void) showOverlayView : (UILongPressGestureRecognizer *) sender {
    
    NSArray *allViews = [[super superview] subviews];
    DEScreenManager *screenManager = [DEScreenManager sharedManager];
    
    BOOL overlayDisplayed = [screenManager overlayDisplayed];
    
    //Get all the sibling DEEventTimeline views and display them on the screen
    for (UIView *superView in allViews) {
        for (UIView *view in [superView subviews]) {
            if ([view isKindOfClass:[DEEventsTimeline class]])
            {
                DEEventsTimeline *overlayView = (DEEventsTimeline *) view;
                
                if (sender.state == UIGestureRecognizerStateBegan)
                {
                    [UIView animateWithDuration:.3 animations:^{
                        [[overlayView layer] setOpacity:.8];
                    }];
                }
                else if (sender.state == UIGestureRecognizerStateEnded)
                {
                    [UIView animateWithDuration:.3 animations:^{
                        [[overlayView layer] setOpacity:0];
                    }];
                }
            
                [screenManager setOverlayDisplayed:overlayDisplayed];
            }
        }
    }
    [screenManager setOverlayDisplayed:!overlayDisplayed];
}

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return TRUE;
}

- (void) renderViewWithPost : (DEPost *) myPost {
    
    __block PFObject *post = (PFObject *) myPost;
    
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showOverlayView:)];
    longPressGestureRecognizer.minimumPressDuration = .2;
    longPressGestureRecognizer.delegate = self;
    [self addGestureRecognizer:longPressGestureRecognizer];
    
    _overlayView = [[[NSBundle mainBundle] loadNibNamed:@"ViewEventsView" owner:self options:nil] objectAtIndex:OVERLAY_VIEW];
    [_overlayView setFrame:CGRectMake(0, 0, 140, 216)];
    [self addSubview:_overlayView];
    [[_overlayView layer] setOpacity:0];
    
    // THREADING
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

    dispatch_async(queue, ^{
        self.lblTitle.text = post[@"name"];
        self.imgMainImageView.backgroundColor = [UIColor greenColor];
        
        if ([post[@"images"] count] > 0)
        {
            PFFile *imageFile = post[@"images"][0];
            NSData *imageData = [imageFile getData];
            UIImage *image = [UIImage imageWithData:imageData];
            
            //Load the images on the main thread asynchronously
            dispatch_sync(dispatch_get_main_queue(), ^{
                self.imgMainImageView.image = image;
            });
        }
    });
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
