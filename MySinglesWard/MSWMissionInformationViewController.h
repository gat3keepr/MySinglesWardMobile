//
//  MSWMissionInformationViewController.h
//  MySinglesWard
//
//  Created by Porter Hoskins on 5/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface MSWMissionInformationViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UISwitch *servedMission;
@property (weak, nonatomic) User *currentUser;


@end
