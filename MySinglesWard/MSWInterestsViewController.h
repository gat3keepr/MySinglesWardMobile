//
//  MSWInterestsViewController.h
//  MySinglesWard
//
//  Created by Porter Hoskins on 5/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface MSWInterestsViewController : UITableViewController <UITextViewDelegate>

@property (weak, nonatomic) User *currentUser;
@property (weak, nonatomic) IBOutlet UITextView *inputView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *saveButton;

@end
