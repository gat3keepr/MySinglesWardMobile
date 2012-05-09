//
//  MSWPriesthoodSelectViewController.m
//  MySinglesWard
//
//  Created by Porter Hoskins on 5/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MSWPriesthoodSelectViewController.h"
#import "MemberSurvey.h"
@interface MSWPriesthoodSelectViewController ()

@property (weak, nonatomic) UITableViewCell *selectedRow;
@property (weak, nonatomic) IBOutlet UITableViewCell *deconCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *teacherCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *priestCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *elderCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *highPriestCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *notOrdainedCell;

@end

@implementation MSWPriesthoodSelectViewController
@synthesize selectedRow = _selectedRow;
@synthesize deconCell = _deconCell;
@synthesize teacherCell = _teacherCell;
@synthesize priestCell = _priestCell;
@synthesize elderCell = _elderCell;
@synthesize highPriestCell = _highPriestCell;
@synthesize notOrdainedCell = _notOrdainedCell;
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
    
    if([self.currentUser.survey.priesthood isEqualToString:@"Deacon"])
    {
        self.selectedRow = self.deconCell;
    }
    else if([self.currentUser.survey.priesthood isEqualToString:@"Teacher"])
    {
        self.selectedRow = self.teacherCell;
    }
    else if([self.currentUser.survey.priesthood isEqualToString:@"Priest"])
    {
        self.selectedRow = self.priestCell;
    }
    else if([self.currentUser.survey.priesthood isEqualToString:@"Elder"])
    {
        self.selectedRow = self.elderCell;
    }
    else if([self.currentUser.survey.priesthood isEqualToString:@"High Priest"])
    {
        self.selectedRow = self.highPriestCell;
    }
    else if([self.currentUser.survey.priesthood isEqualToString:@"Not Ordained"])
    {
        self.selectedRow = self.notOrdainedCell;
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
    [self setDeconCell:nil];
    [self setTeacherCell:nil];
    [self setPriestCell:nil];
    [self setElderCell:nil];
    [self setHighPriestCell:nil];
    [self setNotOrdainedCell:nil];
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
    self.currentUser.survey.priesthood = self.selectedRow.textLabel.text;
    
}

@end
