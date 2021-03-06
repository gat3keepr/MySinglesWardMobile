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
#import "MSWTXTViewController.h"
#import "JSONRequest.h"

@interface MSWNotificationViewController ()

@property (nonatomic) BOOL isTXT;
@property (strong, nonatomic) NSString *carrier;

-(void)loadNotificationPreferences;

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
@synthesize isTXT = _isTXT;
@synthesize carrier = _carrier;

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
    
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    self.currentUser = [User userWithID:[pref objectForKey:MEMBERID] inManagedObjectContext:[self.delegate getMSWDatabase].managedObjectContext];
    
    self.isTXT = [self.currentUser.notificationPreference.txt boolValue];
    self.carrier = self.currentUser.notificationPreference.carrier;
    
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
    [self loadNotificationPreferences];
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.destinationViewController respondsToSelector:@selector(setDelegate:)])
    {
        [segue.destinationViewController setDelegate:self.delegate];
    }
}

- (IBAction)cancelNotificationChanges:(id)sender {
    self.currentUser.notificationPreference.txt = [NSNumber numberWithBool:self.isTXT];
    self.currentUser.notificationPreference.carrier = self.carrier;
    
    [self.presentingViewController dismissModalViewControllerAnimated:YES];
}

-(void)loadNotificationPreferences
{  
    self.emailSwitch.on = [self.currentUser.notificationPreference.email boolValue];
    self.stakeSwitch.on = [self.currentUser.notificationPreference.stake boolValue];
    self.wardSwitch.on = [self.currentUser.notificationPreference.ward boolValue];
    self.eldersQuourmSwitch.on = [self.currentUser.notificationPreference.elders boolValue];
    self.reliefSocietySwitch.on = [self.currentUser.notificationPreference.reliefsociety boolValue];
    self.activitiesSwitch.on = [self.currentUser.notificationPreference.activities boolValue];
    self.fheSwitch.on = [self.currentUser.notificationPreference.fhe boolValue];
    
    self.txtLabel.text = [self.currentUser.notificationPreference.txt boolValue] ? @"Yes" : @"No";
}

- (IBAction)saveNotificationPreferences:(id)sender {

    //Create Request to be sent to server
    //Create the URL for the web request to get all the customers
    NSString *url = [[NSString alloc] initWithFormat:@"%@api/member/savenotificationpreferences", MSWRequestURL];
    NSLog(@"NOTIFICATION SAVE URL request: %@", url);
    
    NSMutableDictionary *preferences = [[NSMutableDictionary alloc] init];
    [preferences setObject:self.currentUser.memberID forKey:@"MemberID"];
    [preferences setObject:[NSNumber numberWithBool:self.emailSwitch.on] forKey:@"email"];
    [preferences setObject:self.currentUser.notificationPreference.txt forKey:@"txt"];
    [preferences setObject:self.currentUser.notificationPreference.carrier forKey:@"carrier"];
    [preferences setObject:[NSNumber numberWithBool:self.stakeSwitch.on] forKey:@"stake"];
    [preferences setObject:[NSNumber numberWithBool:self.wardSwitch.on] forKey:@"ward"];
    [preferences setObject:[NSNumber numberWithBool:self.eldersQuourmSwitch.on] forKey:@"elders"];
    [preferences setObject:[NSNumber numberWithBool:self.reliefSocietySwitch.on] forKey:@"reliefsociety"];
    [preferences setObject:[NSNumber numberWithBool:self.activitiesSwitch.on] forKey:@"activities"];
    [preferences setObject:[NSNumber numberWithBool:self.fheSwitch.on] forKey:@"fhe"];

    //load Ward List
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        NSError *error = nil;
        NSLog(@"NOTIFICATION SAVE JSON: %@", [NSDictionary dictionaryWithObject:preferences forKey:@"pref"]);
        NSDictionary *success = [JSONRequest makeWebRequestWithURL:url withJSONData:[NSJSONSerialization dataWithJSONObject:[NSDictionary dictionaryWithObject:preferences forKey:@"pref"] options:NSJSONWritingPrettyPrinted error:&error]];
        
        if(error || !success)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Could Not Save" message:@"Please make sure you are connected to the internet and try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            });   
        }
        else 
        {   
            [self.currentUser.managedObjectContext performBlock:^{
                self.currentUser.notificationPreference.email = [NSNumber numberWithBool:emailSwitch.on];
                self.currentUser.notificationPreference.stake = [NSNumber numberWithBool:stakeSwitch.on];
                self.currentUser.notificationPreference.ward = [NSNumber numberWithBool:wardSwitch.on];
                self.currentUser.notificationPreference.elders = [NSNumber numberWithBool:eldersQuourmSwitch.on];
                self.currentUser.notificationPreference.reliefsociety = [NSNumber numberWithBool:reliefSocietySwitch.on];
                self.currentUser.notificationPreference.activities = [NSNumber numberWithBool:activitiesSwitch.on];
                self.currentUser.notificationPreference.fhe = [NSNumber numberWithBool:fheSwitch.on];
            }];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.presentingViewController dismissModalViewControllerAnimated:YES];
            });            
        }
        
    });
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
