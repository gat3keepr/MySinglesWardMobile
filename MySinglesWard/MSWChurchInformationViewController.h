//
//  MSWChurchInformationViewController.h
//  MySinglesWard
//
//  Created by Porter Hoskins on 5/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSWProfileTableViewController.h"
#import "User.h"

@interface MSWChurchInformationViewController : UITableViewController

@property (strong, nonatomic) User *currentUser;
@property (weak, nonatomic) IBOutlet UISwitch *patriarchalBlessingSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *endowedSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *templeRecommendSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *templeWorkerSwitch;
@property (weak, nonatomic) IBOutlet UILabel *templeExpDateLabel;

@end
