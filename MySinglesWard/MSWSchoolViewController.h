//
//  MSWSchoolViewController.h
//  MySinglesWard
//
//  Created by Porter Hoskins on 5/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface MSWSchoolViewController : UITableViewController <UITextFieldDelegate>

@property(strong, nonatomic) User *currentUser;

@end
