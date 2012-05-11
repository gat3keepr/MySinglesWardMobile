//
//  MSWNOMissionViewController.h
//  MySinglesWard
//
//  Created by Porter Hoskins on 5/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface MSWNOMissionViewController : UITableViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableViewCell *yesMissionCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *noMissionCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *maybeMissionCell;
@property (weak, nonatomic) IBOutlet UITextField *missionPlanTimeField;
@property (weak, nonatomic) User *currentUser;
@end
