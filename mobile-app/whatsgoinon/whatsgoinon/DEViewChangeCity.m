//
//  DEViewChangeCity.m
//  whatsgoinon
//
//  Created by adeiji on 8/18/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import "DEViewChangeCity.h"

@implementation DEViewChangeCity

- (id) init {
    self = [super init];
    if (self)
    {
        // Initialization code.
        //
        self = [[[NSBundle mainBundle] loadNibNamed:@"ViewChangeCity" owner:self options:nil] firstObject];
        [self.searchBar setDelegate:self];
        [self.tableView setDataSource:self];
        [self.tableView setDelegate:self];
        
        [self.searchBar becomeFirstResponder];
        
        locations = [NSArray new];
    }
    return self;
}

- (void) searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self removeFromSuperview];
}

- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [DELocationManager getAutocompleteValuesFromString:searchText CompletionBlock:^(NSArray *values) {
        locations = values;
        [_tableView reloadData];
    }];
    
    searchBar.text = searchText;
}

- (void) searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    
}

#pragma mark - Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Locations";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [locations count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell;
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] init];
    }

    cell.textLabel.text = [locations objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Set the lat/long values to whatever was selected and then reload the post age with the necessary post that correspond to the city that was just selected
    
    [self removeFromSuperview];
    
}

@end
