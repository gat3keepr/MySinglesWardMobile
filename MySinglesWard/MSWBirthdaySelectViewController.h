//
//  MSWBirthdaySelectViewController.h
//  MySinglesWard
//
//  Created by Porter Hoskins on 5/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface MSWBirthdaySelectViewController : UITableViewController <UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) User *currentUser;

@end
