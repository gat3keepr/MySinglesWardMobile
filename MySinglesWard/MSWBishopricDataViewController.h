//
//  MSWBishopricDataViewController.h
//  MySinglesWard
//
//  Created by Porter Hoskins on 5/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSWProfileTableViewController.h"

@interface MSWBishopricDataViewController : UITableViewController

@property (assign, nonatomic) id<MSWDatabaseDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UILabel *callingLabel;
@property (weak, nonatomic) IBOutlet UITextField *wifeNameField;
@property (weak, nonatomic) IBOutlet UITextField *wifePhoneField;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *addressField;
@property (weak, nonatomic) User *currentUser;

@end
