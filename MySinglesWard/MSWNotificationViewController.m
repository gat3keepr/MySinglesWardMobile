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
#import "MSWRequest.h"
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
    self.currentUser.notificationPreference.email = [NSNumber numberWithBool:emailSwitch.on];
    self.currentUser.notificationPreference.stake = [NSNumber numberWithBool:stakeSwitch.on];
    self.currentUser.notificationPreference.ward = [NSNumber numberWithBool:wardSwitch.on];
    self.currentUser.notificationPreference.elders = [NSNumber numberWithBool:eldersQuourmSwitch.on];
    self.currentUser.notificationPreference.reliefsociety = [NSNumber numberWithBool:reliefSocietySwitch.on];
    self.currentUser.notificationPreference.activities = [NSNumber numberWithBool:activitiesSwitch.on];
    self.currentUser.notificationPreference.fhe = [NSNumber numberWithBool:fheSwitch.on];
    
    //Create Request to be sent to server
    //Create the URL for the web request to get all the customers
    NSString *url = [[NSString alloc] initWithFormat:@"%@api/member/savenotificationpreferences", MSWRequestURL];
    NSLog(@"NOTIFICATION SAVE URL request: %@", url);
    
    NSMutableDictionary *preferences = [[NSMutableDictionary alloc] init];
    [preferences setObject:self.currentUser.memberID forKey:@"MemberID"];
    [preferences setObject:self.currentUser.notificationPreference.email forKey:@"email"];
    [preferences setObject:self.currentUser.notificationPreference.txt forKey:@"txt"];
    [preferences setObject:self.currentUser.notificationPreference.carrier forKey:@"carrier"];
    [preferences setObject:self.currentUser.notificationPreference.stake forKey:@"stake"];
    [preferences setObject:self.currentUser.notificationPreference.ward forKey:@"ward"];
    [preferences setObject:self.currentUser.notificationPreference.elders forKey:@"elders"];
    [preferences setObject:self.currentUser.notificationPreference.reliefsociety forKey:@"reliefsociety"];
    [preferences setObject:self.currentUser.notificationPreference.activities forKey:@"activities"];
    [preferences setObject:self.currentUser.notificationPreference.fhe forKey:@"fhe"];

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
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.presentingViewController dismissModalViewControllerAnimated:YES];
            });            
        }
        
    });
}

@end
