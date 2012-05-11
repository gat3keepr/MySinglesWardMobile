//
//  MSWNOMissionViewController.m
//  MySinglesWard
//
//  Created by Porter Hoskins on 5/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MSWNOMissionViewController.h"
#import "MemberSurvey.h"

@interface MSWNOMissionViewController ()
@property(strong, nonatomic) UITableViewCell *selectedRow;
@end

@implementation MSWNOMissionViewController
@synthesize yesMissionCell;
@synthesize noMissionCell;
@synthesize maybeMissionCell;
@synthesize missionPlanTimeField;
@synthesize selectedRow = _selectedRow;
@synthesize currentUser = _currentUser;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if([self.currentUser.survey.planMission isEqualToString:@"Yes"])
    {
        self.selectedRow = self.yesMissionCell;
    }
    else if([self.currentUser.survey.planMission isEqualToString:@"No"])
    {
        self.selectedRow = self.noMissionCell;
    }
    else if([self.currentUser.survey.planMission isEqualToString:@"Maybe"])
    {
        self.selectedRow = self.maybeMissionCell;
    }
    
    self.missionPlanTimeField.text = self.currentUser.survey.planMissionTime;
    self.selectedRow.accessoryType = UITableViewCellAccessoryCheckmark;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [self setYesMissionCell:nil];
    [self setMissionPlanTimeField:nil];
    [self setNoMissionCell:nil];
    [self setMaybeMissionCell:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if(self.missionPlanTimeField == textField)
    {
        self.currentUser.survey.planMissionTime = textField.text;
    }
    return NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedRow.accessoryType = UITableViewCellAccessoryNone;
    
    self.selectedRow = [self.tableView cellForRowAtIndexPath:indexPath];
    self.selectedRow.accessoryType = UITableViewCellAccessoryCheckmark;
    self.currentUser.survey.planMission = self.selectedRow.textLabel.text;
}

@end
