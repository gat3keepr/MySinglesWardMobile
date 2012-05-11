//
//  MSWChurchInformationViewController.m
//  MySinglesWard
//
//  Created by Porter Hoskins on 5/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MSWChurchInformationViewController.h"
#import "MemberSurvey.h"

@interface MSWChurchInformationViewController ()

@end

@implementation MSWChurchInformationViewController
@synthesize currentUser = _currentUser;
@synthesize patriarchalBlessingSwitch;
@synthesize endowedSwitch;
@synthesize templeRecommendSwitch;
@synthesize templeWorkerSwitch;
@synthesize templeExpDateLabel;

-(void)fillSurveyInformation
{
    self.patriarchalBlessingSwitch.on = [self.currentUser.survey.patriarchalBlessing isEqualToString:@"Yes"];
    self.endowedSwitch.on = [self.currentUser.survey.endowed isEqualToString:@"Yes"];
    self.templeRecommendSwitch.on = [self.currentUser.survey.templeRecommend isEqualToString:@"Yes"];
    self.templeExpDateLabel.text = self.currentUser.survey.templeExpDate;
    self.templeWorkerSwitch.on = [self.currentUser.survey.templeWorker isEqualToString:@"Yes"];
}

- (IBAction)continueSurvey:(id)sender {
    [self performSegueWithIdentifier:@"Other Information" sender:self];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fillSurveyInformation];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self fillSurveyInformation];
}
- (IBAction)patriarchalBlessingSwitched:(UISwitch *)sender {
    self.currentUser.survey.patriarchalBlessing = sender.on ? @"Yes" : @"No";
}
- (IBAction)endowedSwitched:(UISwitch *)sender {
    self.currentUser.survey.endowed = sender.on ? @"Yes" : @"No";
}
- (IBAction)templeRecommendSwitched:(UISwitch *)sender {
    self.currentUser.survey.templeRecommend = sender.on ? @"Yes" : @"No";
}
- (IBAction)templeWorkerSwitched:(UISwitch *)sender {
    self.currentUser.survey.templeWorker = sender.on ? @"Yes" : @"No";
}

- (void)viewDidUnload
{
    [self setPatriarchalBlessingSwitch:nil];
    [self setEndowedSwitch:nil];
    [self setTempleRecommendSwitch:nil];
    [self setTempleWorkerSwitch:nil];
    [self setTempleExpDateLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender 
{
    if([segue.destinationViewController respondsToSelector:@selector(setCurrentUser:)])
    {
        [segue.destinationViewController setCurrentUser:self.currentUser];
    }   
}

@end
