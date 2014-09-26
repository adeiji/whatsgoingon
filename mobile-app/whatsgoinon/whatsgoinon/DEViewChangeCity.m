//
//  DEViewChangeCity.m
//  whatsgoinon
//
//  Created by adeiji on 8/18/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import "DEViewChangeCity.h"

@implementation DEViewChangeCity



- (id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code.
        self = [[[NSBundle mainBundle] loadNibNamed:@"ViewChangeCity" owner:self options:nil] firstObject];
        self.frame = frame;
    }
    return self;
}

- (void) setUpViewWithType:(NSString *)myType {
    [self.searchBar setDelegate:self];
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    
    type = myType;
    
    [self initLocationsArray];
}

- (void) initLocationsArray {
    locations = [NSArray new];
}

- (void) searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [DEAnimationManager fadeOutRemoveView:self FromView:[self superview]];
}

- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [DELocationManager getAutocompleteValuesFromString:searchText DataResultType:type CompletionBlock:^(NSArray *values) {
        locations = values;
        [_tableView reloadData];
    }];
    
    searchBar.text = searchText;
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

    [cell setBackgroundColor:[UIColor clearColor]];
    cell.textLabel.text = [locations objectAtIndex:indexPath.row];
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    
    return cell;
}

#pragma mark - Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Set the lat/long values to whatever was selected and then reload the post age with the necessary post that correspond to the city that was just selected
    _selection = [locations objectAtIndex:indexPath.row];
    [DEAnimationManager fadeOutRemoveView:self FromView:[self superview]];
    [[DELocationManager sharedManager] setCity:_selection];
    DEViewEventsViewController *viewController = (DEViewEventsViewController *) [[DEScreenManager getMainNavigationController] topViewController];
    [viewController hideMainMenu];
    
}

@end
