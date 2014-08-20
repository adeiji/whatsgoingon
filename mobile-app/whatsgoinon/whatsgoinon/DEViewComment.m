//
//  DEViewComment.m
//  whatsgoinon
//
//  Created by adeiji on 8/19/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import "DEViewComment.h"

@implementation DEViewComment

- (id) init {
    self = [super init];
    
    if (self)
    {
        self = [[[NSBundle mainBundle] loadNibNamed:@"ViewComment" owner:self options:nil] firstObject];
        options = @[@"Awesome", @"Meh...", @"Suuuucks!!"];
        
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (IBAction)submitComment:(id)sender {
    [self removeFromSuperview];
}

- (IBAction)cancel:(id)sender {
    [self removeFromSuperview];
}

@end
