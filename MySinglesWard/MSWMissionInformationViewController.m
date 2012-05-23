//
//  MSWMissionInformationViewController.m
//  MySinglesWard
//
//  Created by Porter Hoskins on 5/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MSWMissionInformationViewController.h"
#import "MemberSurvey.h"
#import "JSONRequest.h"

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
    
    //Set background image of table view
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:BACKGROUND_IMAGE]];
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender 
{
    if([segue.destinationViewController respondsToSelector:@selector(setCurrentUser:)])
    {
        [segue.destinationViewController setCurrentUser:self.currentUser];
    }   
}

@end
