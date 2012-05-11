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
    
    [self.datePicker setDate:[df dateFromString:self.currentUser.survey.templeExpDate]];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
