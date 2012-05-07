//
//  MSWNotificationViewController.h
//  MySinglesWard
//
//  Created by Porter Hoskins on 5/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "MSWProfileTableViewController.h"

@interface MSWNotificationViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UISwitch *emailSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *stakeSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *wardSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *eldersQuourmSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *reliefSocietySwitch;
@property (weak, nonatomic) IBOutlet UISwitch *activitiesSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *fheSwitch;
@property (strong, nonatomic) User *currentUser;
@property (weak, nonatomic) IBOutlet UILabel *txtLabel;
@property (strong, nonatomic) id<MSWDatabaseDelegate> delegate;

@end
