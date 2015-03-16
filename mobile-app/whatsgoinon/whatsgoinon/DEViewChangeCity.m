//
//  DEViewChangeCity.m
//  whatsgoinon
//
//  Created by adeiji on 8/18/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import "DEViewChangeCity.h"

@implementation DEViewChangeCity

static NSString *GOOGLE_AUTOCOMPLETE_API_PLACES = @"establishment";

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
    locations = [NSMutableArray new];
}

- (void) searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [DEAnimationManager fadeOutRemoveView:self FromView:[self superview]];
}

- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    locations = [NSMutableArray new];
    
    [DELocationManager getAutocompleteValuesFromString:searchText DataResultType:type CompletionBlock:^(NSArray *values) {
        [locations addObjectsFromArray:values];
    }];
    
    if ([type isEqualToString:PLACES_API_DATA_RESULT_TYPE_GEOCODE])
    {
        [DELocationManager getAutocompleteValuesFromString:searchText DataResultType:GOOGLE_AUTOCOMPLETE_API_PLACES CompletionBlock:^(NSArray *values) {
            [locations addObjectsFromArray:values];
            [self.tableView reloadData];
        }];
    }
    
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
    
    if ([type isEqualToString:PLACES_API_DATA_RESULT_TYPE_CITIES])
    {
        [[DELocationManager sharedManager] setCity:_selection];
    }
    else {
        [[DELocationManager sharedManager] setEventLocation:_selection];
    }
}

@end
