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
        NSDictionary *dictionary = @{PARSE_CLASS_EVENT_COMMENTS: comments, PARSE_CLASS_EVENT_RATING : rating };
        
        [DESyncManager updateObjectWithId:_post.objectId UpdateValues:dictionary ParseClassName:PARSE_CLASS_NAME_EVENT];
        
        [self removeFromSuperview];
    }
    else {
        [_lblPromptEntry setHidden:NO];
    }
}

- (IBAction)cancel:(id)sender {
    [self removeFromSuperview];
}

- (IBAction)thumbsUp:(id)sender {
    ratingChange = 5;
    [_lblPromptEntry setHidden:YES];
}

- (IBAction)thumbsDown:(id)sender {
    ratingChange = -5;
    [_lblPromptEntry setHidden:YES];
}

@end
