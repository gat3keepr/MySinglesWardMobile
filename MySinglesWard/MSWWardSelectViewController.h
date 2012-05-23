//
//  MSWWardSelectViewController.h
//  MySinglesWard
//
//  Created by Porter Hoskins on 5/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSWUnitSelectionViewController.h"
#import "MSWProfileTableViewController.h"

@interface MSWWardSelectViewController : UITableViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) id<MSWChangeWardProtocol> unitDelegate;
@property (strong, nonatomic) id<MSWDatabaseDelegate> delegate;
@property (strong, nonatomic) NSArray *wards;
@property (strong, nonatomic) NSArray *wardIDs;
@property (weak, nonatomic) IBOutlet UIPickerView *wardsPicker;

@end
