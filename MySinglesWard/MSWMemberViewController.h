//
//  MSWMemberViewController.h
//  MySinglesWard
//
//  Created by Porter Hoskins on 5/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import <MessageUI/MessageUI.h>

@interface MSWMemberViewController : UITableViewController <MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *memberPhoto;
@property (weak, nonatomic) IBOutlet UILabel *memberName;
@property (weak, nonatomic) IBOutlet UILabel *memberPhone;
@property (weak, nonatomic) IBOutlet UILabel *memberEmail;
@property (weak, nonatomic) IBOutlet UILabel *memberResidence;
@property (weak, nonatomic) IBOutlet UITableViewCell *titleCell;
@property (weak, nonatomic) IBOutlet UILabel *memberCalling;
@property (nonatomic, strong) User *user;
@end
