//
//  MSWResidenceSelectViewController.h
//  MySinglesWard
//
//  Created by Porter Hoskins on 5/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface MSWResidenceSelectViewController : UITableViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) User *currentUser;
@property (weak, nonatomic) IBOutlet UIPickerView *residencePicker;
@property (weak, nonatomic) IBOutlet UITextField *residenceLabel;
@property (weak, nonatomic) IBOutlet UITableViewCell *spacerview;

@end
