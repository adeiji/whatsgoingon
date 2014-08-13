//
//  DEViewCategoriesView.h
//  whatsgoinon
//
//  Created by adeiji on 8/13/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DESector.h"
#import "DERotaryProtocol.h"

@interface DESelectCategoryView : UIView <DERotaryProtocol>
{
    UIView *container;
}

@property CGAffineTransform startTransform;
@property (strong, nonatomic) NSMutableArray *sectors;
@property int currentSector;
@property (weak) id <DERotaryProtocol> delegate;

#pragma mark - Outlets

@property (weak, nonatomic) IBOutlet UILabel *lblCategory;

#pragma mark - Category Functions
- (IBAction)displayCategoryWheel:(id)sender;

#pragma mark - Instance Methods

- (void) renderView;
- (float) calculateDistanceFromCenter:(CGPoint)point;
- (void) buildSectorsEven;
- (void) buildSectorsOdd;

@end
