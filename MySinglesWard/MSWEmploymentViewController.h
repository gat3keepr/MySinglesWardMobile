//
//  MSWEmploymentViewController.h
//  MySinglesWard
//
//  Created by Porter Hoskins on 5/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface MSWEmploymentViewController : UITableViewController <UITextFieldDelegate>

@property(weak, nonatomic) User *currentUser;

@end
