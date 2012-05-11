//
//  MSWReligionClassViewController.m
//  MySinglesWard
//
//  Created by Porter Hoskins on 5/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MSWReligionClassViewController.h"
#import "MemberSurvey.h"

@interface MSWReligionClassViewController ()

@property(weak, nonatomic) UITableViewCell *selectedRow;
@property (weak, nonatomic) IBOutlet UITableViewCell *religionCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *instituteCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *noneCell;

@end

@implementation MSWReligionClassViewController
@synthesize currentUser = _currentUser;
@synthesize selectedRow = _selectedRow;
@synthesize religionCell;
@synthesize instituteCell;
@synthesize noneCell;

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
    
    if([self.currentUser.survey.religionClass isEqualToString:@"Religion Class"])
    {
        self.selectedRow = self.religionCell;
    }
    else if([self.currentUser.survey.religionClass isEqualToString:@"Institute"])
    {
        self.selectedRow = self.instituteCell;
    }
    else if([self.currentUser.survey.religionClass isEqualToString:@"None"])
    {
        self.selectedRow = self.noneCell;
    }
    
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
    [self setReligionCell:nil];
    [self setInstituteCell:nil];
    [self setNoneCell:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
    self.currentUser.survey.religionClass = self.selectedRow.textLabel.text;
    
}
@end
