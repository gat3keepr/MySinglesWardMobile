//
//  MSWTXTViewController.h
//  MySinglesWard
//
//  Created by Porter Hoskins on 5/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "User.h"
#import "MSWProfileTableViewController.h"
#import "MSWNotificationViewController.h"
#import <UIKit/UIKit.h>

@interface MSWTXTViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UISwitch *txtSwitch;
@property (strong, nonatomic) User *currentUser;
@property (strong, nonatomic) id<MSWDatabaseDelegate> delegate;

@end
