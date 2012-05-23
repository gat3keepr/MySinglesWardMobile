//
//  MSWBishopricCallingViewController.h
//  MySinglesWard
//
//  Created by Porter Hoskins on 5/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User+Create.h"

@interface MSWBishopricCallingViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UITableViewCell *bishopCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *firstCounselorCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *secondCounselorCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *wardClerkCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *highCouncilmanCell;
@property (weak, nonatomic) User *currentUser;

@end
