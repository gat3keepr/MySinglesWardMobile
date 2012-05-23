//
//  MSWNOMissionViewController.m
//  MySinglesWard
//
//  Created by Porter Hoskins on 5/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MSWNOMissionViewController.h"
#import "MemberSurvey.h"
#import "JSONRequest.h"

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
    
    //Set background image of table view
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:BACKGROUND_IMAGE]];

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
