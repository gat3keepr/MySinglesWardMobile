//
//  MSWTimeInWardViewController.m
//  MySinglesWard
//
//  Created by Porter Hoskins on 5/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MSWTimeInWardViewController.h"
#import "MemberSurvey.h"
#import "JSONRequest.h"

@interface MSWTimeInWardViewController ()

@property (weak, nonatomic) UITableViewCell *selectedRow;
@property (weak, nonatomic) IBOutlet UITableViewCell *oneSemesterCel;
@property (weak, nonatomic) IBOutlet UITableViewCell *twoSemesterCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *moreTwoSemesterCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *lessSixMonthCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *sixMonthCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *twelveMonthCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *indefinitelyCell;

@end

@implementation MSWTimeInWardViewController
@synthesize currentUser = _currentUser;
@synthesize selectedRow = _selectedRow;
@synthesize oneSemesterCel = _oneSemesterCel;
@synthesize twoSemesterCell = _twoSemesterCell;
@synthesize moreTwoSemesterCell = _moreTwoSemesterCell;
@synthesize lessSixMonthCell = _lessSixMonthCell;
@synthesize sixMonthCell = _sixMonthCell;
@synthesize twelveMonthCell = _twelveMonthCell;
@synthesize indefinitelyCell = _indefinitelyCell;

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
    
    if([self.currentUser.survey.timeInWard isEqualToString:@"One Semester"])
    {
        self.selectedRow = self.oneSemesterCel;
    }
    else if([self.currentUser.survey.timeInWard isEqualToString:@"Two Semesters"])
    {
        self.selectedRow = self.twoSemesterCell;
    }
    else if([self.currentUser.survey.timeInWard isEqualToString:@"More Than Two Semesters"])
    {
        self.selectedRow = self.moreTwoSemesterCell;
    }
    else if([self.currentUser.survey.timeInWard isEqualToString:@"Less than 6 months"])
    {
        self.selectedRow = self.lessSixMonthCell;
    }
    else if([self.currentUser.survey.timeInWard isEqualToString:@"6+ months"])
    {
        self.selectedRow = self.sixMonthCell;
    }
    else if([self.currentUser.survey.timeInWard isEqualToString:@"12+ Months"])
    {
        self.selectedRow = self.twelveMonthCell;
    }
    else if([self.currentUser.survey.timeInWard isEqualToString:@"Indefinitely"])
    {
        self.selectedRow = self.indefinitelyCell;
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
    [self setOneSemesterCel:nil];
    [self setTwoSemesterCell:nil];
    [self setMoreTwoSemesterCell:nil];
    [self setLessSixMonthCell:nil];
    [self setSixMonthCell:nil];
    [self setTwelveMonthCell:nil];
    [self setIndefinitelyCell:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
    self.currentUser.survey.timeInWard = self.selectedRow.textLabel.text;
    
}


@end
