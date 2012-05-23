//
//  MSWTeachingViewController.m
//  MySinglesWard
//
//  Created by Porter Hoskins on 5/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MSWTeachingViewController.h"
#import "MemberSurvey.h"
#import "JSONRequest.h"

@interface MSWTeachingViewController ()

@property (weak, nonatomic) IBOutlet UITableViewCell *desireCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *skillCell;
@property (weak, nonatomic) IBOutlet UISegmentedControl *skillSegment;
@property (weak, nonatomic) IBOutlet UISegmentedControl *desireSegment;

@end

@implementation MSWTeachingViewController
@synthesize desireCell;
@synthesize skillCell;
@synthesize skillSegment;
@synthesize desireSegment;
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
    int skill = [self.currentUser.survey.teachSkill intValue];
    int desire = [self.currentUser.survey.teachDesire intValue];
    
    if(skill)
        self.skillSegment.selectedSegmentIndex = skill - 1;
    if(desire)
        self.desireSegment.selectedSegmentIndex = desire - 1;
    
    [super viewWillAppear:animated];
}

-(void)teachingSkillSelected:(UISegmentedControl *)sender
{
    self.currentUser.survey.teachSkill = [NSNumber numberWithInt:(sender.selectedSegmentIndex + 1)];
}

-(void)teachingDesireSelected:(UISegmentedControl *)sender
{
    self.currentUser.survey.teachDesire = [NSNumber numberWithInt:(sender.selectedSegmentIndex + 1)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.skillSegment addTarget:self 
                               action:@selector(teachingSkillSelected:)  
                     forControlEvents:UIControlEventValueChanged];
    
    [self.desireSegment addTarget:self 
                          action:@selector(teachingDesireSelected:)  
                forControlEvents:UIControlEventValueChanged];
    
    self.skillCell.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    self.desireCell.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    
    //Set background image of table view
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:BACKGROUND_IMAGE]];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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

- (void)viewDidUnload
{
    [self setDesireCell:nil];
    [self setSkillCell:nil];
    [self setSkillSegment:nil];
    [self setDesireSegment:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
