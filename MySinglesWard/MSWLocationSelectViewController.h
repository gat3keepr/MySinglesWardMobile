//
//  MSWLocationSelectViewController.h
//  MySinglesWard
//
//  Created by Porter Hoskins on 5/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSWProfileTableViewController.h"
#import "MSWUnitSelectionViewController.h"

@interface MSWLocationSelectViewController : UITableViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) id<MSWChangeWardProtocol> unitDelegate;
@property (strong, nonatomic) id<MSWDatabaseDelegate> delegate;
@property (strong, nonatomic) NSArray *locations;
@property (weak, nonatomic) IBOutlet UIPickerView *locationPicker;

@end
