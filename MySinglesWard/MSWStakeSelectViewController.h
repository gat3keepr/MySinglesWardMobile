//
//  MSWStakeSelectViewController.h
//  MySinglesWard
//
//  Created by Porter Hoskins on 5/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSWUnitSelectionViewController.h"
#import "MSWProfileTableViewController.h"
#import "Ward.h"

@interface MSWStakeSelectViewController : UITableViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) id<MSWChangeWardProtocol> unitDelegate;
@property (strong, nonatomic) Ward *ward;
@property (strong, nonatomic) NSArray *stakes;
@property (weak, nonatomic) IBOutlet UIPickerView *stakesPicker;

@end
