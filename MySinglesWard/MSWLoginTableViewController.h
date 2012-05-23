//
//  MSWLoginTableViewController.h
//  MySinglesWard
//
//  Created by Porter Hoskins on 4/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@protocol MSWLoginDelegate <NSObject>

-(void)loginNewUserWithEmail:(NSString *)email withPassword:(NSString *)password;

@end

@interface MSWLoginTableViewController : UITableViewController <UITextFieldDelegate, UIActionSheetDelegate, MSWLoginDelegate>

@property(nonatomic, strong) UIManagedDocument *mswDatabase;
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *emailAddressField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) User *currentUser;
@property (strong, nonatomic) NSArray *cookies;

-(void)updateDownloadBar:(NSTimer *)timer;
- (void)actionSheet:(UIActionSheet *)sender clickedButtonAtIndex:(NSInteger)index;

@end
