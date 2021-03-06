//
//  MSWTempleExpSelectViewController.m
//  MySinglesWard
//
//  Created by Porter Hoskins on 5/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MSWTempleExpSelectViewController.h"
#import "User.h"
#import "MemberSurvey.h"
#import "JSONRequest.h"

@interface MSWTempleExpSelectViewController ()

@end

@implementation MSWTempleExpSelectViewController
@synthesize datePicker;
@synthesize currentUser = _currentUser;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)changeDate:(id)sender{
	//Use NSDateFormatter to write out the date in a friendly format
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	df.dateFormat = @"MM/dd/yyyy";
	self.currentUser.survey.templeExpDate = [NSString stringWithFormat:@"%@",
                                        [df stringFromDate:self.datePicker.date]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.datePicker addTarget:self
                        action:@selector(changeDate:)
              forControlEvents:UIControlEventValueChanged];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
	df.dateFormat = @"MM/dd/yyyy";
    
    if(self.currentUser.survey.templeExpDate)
        [self.datePicker setDate:[df dateFromString:self.currentUser.survey.templeExpDate]];
    
    //Set background image of table view
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:BACKGROUND_IMAGE]];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section 
{
    NSString *sectionTitle = [self tableView:tableView titleForFooterInSection:section];
    if (sectionTitle == nil) {
        return nil;
    }
    
    // Create label with section title
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(20, -40, 265, 45);
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    label.shadowColor = [UIColor lightTextColor];
    label.shadowOffset = CGSizeMake(0.0, 1.0);
    label.font = [UIFont systemFontOfSize:15];
    label.text = sectionTitle;
    label.lineBreakMode = UILineBreakModeWordWrap;
    label.numberOfLines = 2;
    label.textAlignment = UITextAlignmentCenter;
    
    // Create header view and add label as a subview
    
    // you could also just return the label (instead of making a new view and adding the label as subview. With the view you have more flexibility to make a background color or different paddings
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 60)];
    
    [view addSubview:label];
    
    return view;
}

- (void)viewDidUnload
{
    [self setDatePicker:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
