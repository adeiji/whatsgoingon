//
//  DEViewComment.m
//  whatsgoinon
//
//  Created by adeiji on 8/19/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import "DEViewComment.h"
#import "Constants.h"

@implementation DEViewComment

- (id) init {
    self = [super init];
    
    if (self)
    {
        self = [[[NSBundle mainBundle] loadNibNamed:@"ViewComment" owner:self options:nil] firstObject];
        options = @[@"Awesome", @"Meh...", @"Suuuucks!!"];
        
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        
        comment = [options objectAtIndex:[_pickerView selectedRowInComponent:0]];
        ratingChange = 0;
        
        for (UIView *view in _buttons) {
            [[view layer] setCornerRadius:BUTTON_CORNER_RADIUS];
        }
        
        [[_txtComment layer] setCornerRadius:BUTTON_CORNER_RADIUS];
    }
    
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [options objectAtIndex:row];
}

- (UIView *) pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    
    UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, pickerView.frame.size.width, 50.0f)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(myView.center.x - 35, myView.center.y - 25, 200, 50)];
    
    [label setFont:[UIFont fontWithName:@"Avenir Roman" size:14.0f]];
    [label setTextColor:[UIColor whiteColor]];
    
    [label setText:@"Yo Mama"];
    [myView addSubview:label];
    
    return myView;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [options count];
}

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

#pragma mark - Delegate Methods

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    comment = [options objectAtIndex:row];
}

- (IBAction)submitComment:(id)sender {
    
    // Need to check and make sure that the user has picked thumbs up or down.  If not then prompt the user to do so.
    if (ratingChange != 0)
    {
        NSMutableArray *comments = [NSMutableArray arrayWithArray:_post.comments];
        [comments addObject:comment];
        NSNumber *rating = _post.rating;
        rating = [NSNumber numberWithInteger:rating.integerValue + ratingChange ];
        _post.rating = rating;
        NSDictionary *dictionary = @{ PARSE_CLASS_EVENT_COMMENTS : comments, PARSE_CLASS_EVENT_RATING : rating };
        
        [DESyncManager updateObjectWithId:_post.objectId UpdateValues:dictionary ParseClassName:PARSE_CLASS_NAME_EVENT];
        
        [self removeFromSuperview];
    }
    else {
        [_lblPromptEntry setHidden:NO];
    }
}

- (IBAction)cancel:(id)sender {
    [DEScreenManager hideCommentView];
}

- (IBAction)thumbsUp:(UIButton *)sender {
    ratingChange = 5;
    [_lblPromptEntry setHidden:YES];
    
    [[sender layer] setBorderColor:[UIColor colorWithRed:0.0f/255.0f green:172.0f/255.0f blue:238.0f/255.0f alpha:1.0].CGColor];
    [[sender layer] setBorderWidth:1.5f];
    [[sender layer] setCornerRadius:5.0f];
    
}

- (IBAction)thumbsDown:(UIButton *)sender {
    ratingChange = -5;
    [_lblPromptEntry setHidden:YES];
}

@end
