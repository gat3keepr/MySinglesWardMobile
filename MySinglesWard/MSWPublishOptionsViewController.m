//
//  MSWPublishOptionsViewController.m
//  MySinglesWard
//
//  Created by Porter Hoskins on 5/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MSWPublishOptionsViewController.h"
#import "MemberSurvey.h"

@interface MSWPublishOptionsViewController ()

@end

@implementation MSWPublishOptionsViewController

@synthesize currentUser = _currentUser;
@synthesize emailSwitch = _emailSwitch;
@synthesize cellPhoneSwitch = _cellPhoneSwitch;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)emailChanged:(id)sender {
    self.currentUser.survey.publishEmail = [NSNumber numberWithBool:self.emailSwitch.on];
}

- (IBAction)cellPhoneChanged:(id)sender {
    self.currentUser.survey.publishCell = [NSNumber numberWithBool:self.cellPhoneSwitch.on];
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
    self.emailSwitch.on = [self.currentUser.survey.publishEmail boolValue];
    self.cellPhoneSwitch.on = [self.currentUser.survey.publishCell boolValue];
}

- (void)viewDidUnload
{
    [self setEmailSwitch:nil];
    [self setCellPhoneSwitch:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
