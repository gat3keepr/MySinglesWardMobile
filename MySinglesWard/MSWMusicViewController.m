//
//  MSWMusicViewController.m
//  MySinglesWard
//
//  Created by Porter Hoskins on 5/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MSWMusicViewController.h"
#import "MemberSurvey.h"

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
