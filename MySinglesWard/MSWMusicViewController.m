//
//  MSWMusicViewController.m
//  MySinglesWard
//
//  Created by Porter Hoskins on 5/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MSWMusicViewController.h"
#import "MemberSurvey.h"
#import "JSONRequest.h"

@interface MSWMusicViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *musicSkillSegment;
@property (weak, nonatomic) IBOutlet UITextField *musicAbilitiesField;
@property (weak, nonatomic) IBOutlet UITableViewCell *segmentCell;

@end

@implementation MSWMusicViewController
@synthesize musicSkillSegment;
@synthesize musicAbilitiesField;
@synthesize segmentCell;
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
    
    int musicSkill = [self.currentUser.survey.musicSkill intValue];
    
    if(musicSkill)
        self.musicSkillSegment.selectedSegmentIndex = musicSkill - 1;
    
    self.musicAbilitiesField.text = self.currentUser.survey.musicTalent;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    self.currentUser.survey.musicTalent = textField.text;
    
    return NO;
}

- (void)musicSkillSelected:(id)sender{
    self.currentUser.survey.musicSkill = [NSNumber numberWithInt:(self.musicSkillSegment.selectedSegmentIndex + 1)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.musicSkillSegment addTarget:self 
                            action:@selector(musicSkillSelected:)  
                  forControlEvents:UIControlEventValueChanged];
    
    self.segmentCell.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    
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
    [self setMusicSkillSegment:nil];
    [self setMusicAbilitiesField:nil];
    [self setSegmentCell:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
