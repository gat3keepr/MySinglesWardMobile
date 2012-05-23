//
//  MSWTXTViewController.m
//  MySinglesWard
//
//  Created by Porter Hoskins on 5/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MSWTXTViewController.h"
#import "NotificationPreference.h"
#import "User+Create.h"
#import "JSONRequest.h"

@interface MSWTXTViewController ()

@property (weak, nonatomic) UITableViewCell *selectedRow;

@end

@implementation MSWTXTViewController
@synthesize txtSwitch;
@synthesize currentUser = _currentUser;
@synthesize delegate = _delegate;
@synthesize selectedRow = _selectedRow;

#define AT_T @"@txt.att.net"
#define VERIZON @"@vtext.com"
#define TMOBILE @"@tmomail.net"
#define SPRINT @"@messaging.sprintpcs.com"


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Set background image of table view
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:BACKGROUND_IMAGE]];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated    
{
    [super viewWillAppear:animated];
    
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    self.currentUser = [User userWithID:[pref objectForKey:MEMBERID] inManagedObjectContext:[self.delegate getMSWDatabase].managedObjectContext];
    
    self.txtSwitch.on = [self.currentUser.notificationPreference.txt boolValue];
    
    if([self.currentUser.notificationPreference.carrier isEqualToString:AT_T])
    {
        self.selectedRow = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    }
    else if([self.currentUser.notificationPreference.carrier isEqualToString:VERIZON])
    {
        self.selectedRow = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
    }
    else if([self.currentUser.notificationPreference.carrier isEqualToString:SPRINT])
    {
       self.selectedRow = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]];
    }
    else if([self.currentUser.notificationPreference.carrier isEqualToString:TMOBILE])
    {
        self.selectedRow = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:1]];
    }
    
    self.selectedRow.accessoryType = UITableViewCellAccessoryCheckmark;
}

- (void)viewDidUnload
{
    [self setTxtSwitch:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Switch carrier to AT&T
    if(indexPath.row == 0 && indexPath.section == 1)
    {
        self.selectedRow.accessoryType = UITableViewCellAccessoryNone;
        self.selectedRow = [self.tableView cellForRowAtIndexPath:indexPath];
        
        self.currentUser.notificationPreference.carrier = AT_T;
    }
    
    //Switch carrier to VERIZON
    if(indexPath.row == 1 && indexPath.section == 1)
    {
        self.selectedRow.accessoryType = UITableViewCellAccessoryNone;
        self.selectedRow = [self.tableView cellForRowAtIndexPath:indexPath];
        
        self.currentUser.notificationPreference.carrier = VERIZON;
    }
    
    //Switch carrier to SPRINT
    if(indexPath.row == 2 && indexPath.section == 1)
    {
        self.selectedRow.accessoryType = UITableViewCellAccessoryNone;
        self.selectedRow = [self.tableView cellForRowAtIndexPath:indexPath];
        
        self.currentUser.notificationPreference.carrier = SPRINT;
    }
    
    //Switch carrier to TMOBILE
    if(indexPath.row == 3 && indexPath.section == 1)
    {
        self.selectedRow.accessoryType = UITableViewCellAccessoryNone;
        self.selectedRow = [self.tableView cellForRowAtIndexPath:indexPath];
        
        self.currentUser.notificationPreference.carrier = TMOBILE;
    }
    
    self.selectedRow.accessoryType = UITableViewCellAccessoryCheckmark;
}

- (IBAction)TXTchanged:(UISwitch *)sender {
    self.currentUser.notificationPreference.txt = [NSNumber numberWithBool:sender.on];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
    if (sectionTitle == nil) {
        return nil;
    }
    
    // Create label with section title
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(20, 6, 300, 30);
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    label.shadowColor = [UIColor lightTextColor];
    label.shadowOffset = CGSizeMake(0.0, 1.0);
    label.font = [UIFont boldSystemFontOfSize:16];
    label.text = sectionTitle;
    
    // Create header view and add label as a subview
    
    // you could also just return the label (instead of making a new view and adding the label as subview. With the view you have more flexibility to make a background color or different paddings
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 40)];
    
    [view addSubview:label];
    
    return view;
}

@end
