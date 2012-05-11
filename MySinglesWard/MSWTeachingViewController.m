//
//  MSWTeachingViewController.m
//  MySinglesWard
//
//  Created by Porter Hoskins on 5/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MSWTeachingViewController.h"
#import "MemberSurvey.h"

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
