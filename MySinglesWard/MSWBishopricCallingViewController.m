//
//  MSWBishopricCallingViewController.m
//  MySinglesWard
//
//  Created by Porter Hoskins on 5/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MSWBishopricCallingViewController.h"
#import "BishopricData+Create.h"
#import "Calling.h"
#import "JSONRequest.h"

@interface MSWBishopricCallingViewController ()
@property (weak, nonatomic) UITableViewCell *selectedRow;
@end

@implementation MSWBishopricCallingViewController
@synthesize bishopCell;
@synthesize firstCounselorCell;
@synthesize secondCounselorCell;
@synthesize wardClerkCell;
@synthesize highCouncilmanCell;
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
    
    if([self.currentUser.calling.title isEqualToString:@"Bishop"])
    {
        self.selectedRow = self.bishopCell;
    }
    else if([self.currentUser.calling.title isEqualToString:@"First Counselor"])
    {
        self.selectedRow = self.firstCounselorCell;
    }
    else if([self.currentUser.calling.title isEqualToString:@"Second Counselor"])
    {
        self.selectedRow = self.secondCounselorCell;
    }
    else if([self.currentUser.calling.title isEqualToString:@"Ward Clerk"])
    {
        self.selectedRow = self.wardClerkCell;
    }
    else if([self.currentUser.calling.title isEqualToString:@"High Councilman"])
    {
        self.selectedRow = self.highCouncilmanCell;
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
    [self setBishopCell:nil];
    [self setFirstCounselorCell:nil];
    [self setSecondCounselorCell:nil];
    [self setWardClerkCell:nil];
    [self setHighCouncilmanCell:nil];
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
    self.currentUser.calling.title = self.selectedRow.textLabel.text;
    self.currentUser.bishopricData.sortID = [NSString stringWithFormat:@"%d",indexPath.row + 1];;
}

@end
