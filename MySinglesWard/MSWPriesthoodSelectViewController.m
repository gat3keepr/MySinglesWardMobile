//
//  MSWPriesthoodSelectViewController.m
//  MySinglesWard
//
//  Created by Porter Hoskins on 5/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MSWPriesthoodSelectViewController.h"
#import "MemberSurvey.h"
#import "JSONRequest.h"

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
    
    //Set background image of table view
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:BACKGROUND_IMAGE]];

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
