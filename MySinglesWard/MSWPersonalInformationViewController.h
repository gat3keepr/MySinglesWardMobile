//
//  MSWPersonalInformationViewController.h
//  MySinglesWard
//
//  Created by Porter Hoskins on 5/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSWProfileTableViewController.h"

@interface MSWPersonalInformationViewController : UITableViewController

@property (assign, nonatomic) id<MSWDatabaseDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *prefNameField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *genderSelector;
@property (weak, nonatomic) IBOutlet UITextField *cellPhoneField;
@property (weak, nonatomic) IBOutlet UITextField *homePhoneField;
@property (weak, nonatomic) IBOutlet UITextField *emergencyContactField;
@property (weak, nonatomic) IBOutlet UITextField *emergencyPhoneField;
@property (weak, nonatomic) IBOutlet UITextField *homeWardField;
@property (weak, nonatomic) IBOutlet UITextField *homeBishopField;
@property (weak, nonatomic) IBOutlet UILabel *priesthoodLabel;
@property (weak, nonatomic) IBOutlet UITableViewCell *priesthoodCell;
@property (weak, nonatomic) IBOutlet UILabel *birthdayLabel;
@property (weak, nonatomic) IBOutlet UITextField *residenceLabel;
@property (weak, nonatomic) IBOutlet UILabel *publishLabel;
@property (weak, nonatomic) IBOutlet UITextField *homeAddressField;

@end
