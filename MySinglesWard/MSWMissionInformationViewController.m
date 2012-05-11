//
//  MSWMissionInformationViewController.m
//  MySinglesWard
//
//  Created by Porter Hoskins on 5/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MSWMissionInformationViewController.h"
#import "MemberSurvey.h"

@interface MSWMissionInformationViewController ()

@end

@implementation MSWMissionInformationViewController
@synthesize servedMission;
@synthesize currentUser = _currentUser;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)fillSurveyFields
{
    self.servedMission.on = [self.currentUser.survey.mission boolValue];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self fillSurveyFields];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self fillSurveyFields];
}

- (IBAction)switchedMissionServed:(UISwitch *)sender 
{
    self.currentUser.survey.mission = [NSNumber numberWithBool:sender.on];
}

- (void)viewDidUnload
{
    [self setServedMission:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1 && indexPath.row == 0)
    {
        if(self.servedMission.on)
        {
            [self performSegueWithIdentifier:@"YES MISSION" sender:self];
        }
        else {
            [self performSegueWithIdentifier:@"NO MISSION" sender:self];
        }
    }
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
