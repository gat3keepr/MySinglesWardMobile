//
//  MSWPublishOptionsViewController.h
//  MySinglesWard
//
//  Created by Porter Hoskins on 5/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface MSWPublishOptionsViewController : UITableViewController

@property(weak, nonatomic) User *currentUser;
@property (weak, nonatomic) IBOutlet UISwitch *emailSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *cellPhoneSwitch;

@end
