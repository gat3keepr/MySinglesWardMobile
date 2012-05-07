//
//  MSWNotificationViewController.m
//  MySinglesWard
//
//  Created by Porter Hoskins on 5/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MSWNotificationViewController.h"
#import "NotificationPreference.h"
#import "User+Create.h"

@interface MSWNotificationViewController ()

@end

@implementation MSWNotificationViewController

@synthesize emailSwitch;
@synthesize stakeSwitch;
@synthesize wardSwitch;
@synthesize eldersQuourmSwitch;
@synthesize reliefSocietySwitch;
@synthesize activitiesSwitch;
@synthesize fheSwitch;
@synthesize currentUser = _currentUser;
@synthesize txtLabel;
@synthesize delegate;

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
    
    self.emailSwitch.on = [self.currentUser.notificationPreference.email boolValue];
    self.stakeSwitch.on = [self.currentUser.notificationPreference.stake boolValue];
    self.wardSwitch.on = [self.currentUser.notificationPreference.ward boolValue];
    self.eldersQuourmSwitch.on = [self.currentUser.notificationPreference.elders boolValue];
    self.reliefSocietySwitch.on = [self.currentUser.notificationPreference.reliefsociety boolValue];
    self.activitiesSwitch.on = [self.currentUser.notificationPreference.activities boolValue];
    self.fheSwitch.on = [self.currentUser.notificationPreference.fhe boolValue];
    
    self.txtLabel.text = [self.currentUser.notificationPreference.txt boolValue] ? @"Yes" : @"No";
}

- (void)viewDidUnload
{
    [self setEmailSwitch:nil];
    [self setStakeSwitch:nil];
    [self setWardSwitch:nil];
    [self setEldersQuourmSwitch:nil];
    [self setReliefSocietySwitch:nil];
    [self setActivitiesSwitch:nil];
    [self setFheSwitch:nil];
    [self setTxtLabel:nil];
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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.destinationViewController respondsToSelector:@selector(setDelegate:)])
    {
        [segue.destinationViewController setDelegate:self.delegate];
    }
}

- (IBAction)cancelNotificationChanges:(id)sender {
    [self.presentingViewController dismissModalViewControllerAnimated:YES];
}
@end
