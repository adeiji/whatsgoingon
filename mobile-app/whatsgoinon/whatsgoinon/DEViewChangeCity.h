//
//  DEViewChangeCity.h
//  whatsgoinon
//
//  Created by adeiji on 8/18/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DELocationManager.h"

@interface DEViewChangeCity : UIView <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>
{
    NSArray *locations;
    NSString *type;
}
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSString *selection;

- (void) initLocationsArray;
- (void) setUpViewWithType : (NSString *) myType;

@end
