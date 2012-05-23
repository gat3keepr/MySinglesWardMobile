//
//  MSWSchoolViewController.m
//  MySinglesWard
//
//  Created by Porter Hoskins on 5/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MSWSchoolViewController.h"
#import "MemberSurvey.h"
#import "JSONRequest.h"

@interface MSWSchoolViewController ()

@property (weak, nonatomic) IBOutlet UITextField *schoolField;
@property (weak, nonatomic) IBOutlet UITextField *majorField;
@property (weak, nonatomic) IBOutlet UISwitch *enrolledSchoolSwitch;
@property (weak, nonatomic) IBOutlet UITableViewCell *schoolCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *majorCell;

@end

@implementation MSWSchoolViewController
@synthesize schoolField = _schoolField;
@synthesize majorField = _majorField;
@synthesize enrolledSchoolSwitch = _enrolledSchoolSwitch;
@synthesize schoolCell = _schoolCell;
@synthesize majorCell = _majorCell;
@synthesize currentUser = _currentUser;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)enrolledSchoolSwitched:(UISwitch *)sender {
    
    self.currentUser.survey.enrolledSchool = [NSNumber numberWithBool:sender.on];
    
    if(sender.on)
    {
        self.schoolCell.alpha = 0.0;
        self.majorCell.alpha = 0.0;
        self.schoolCell.hidden = NO;
        self.majorCell.hidden = NO;
        
        [UIView animateWithDuration:.2
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{ 
                             self.schoolCell.alpha = 1.0;
                             self.majorCell.alpha = 1.0;
                         }
                         completion:nil];
    }
    else {
        [UIView animateWithDuration:.2
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{ 
                             self.schoolCell.alpha = 0.0;
                             self.majorCell.alpha = 0.0;
                         }
                         completion:nil];
    }
}

-(void)viewWillAppear:(BOOL)animated   
{
    self.schoolField.text = self.currentUser.survey.school;
    self.majorField.text = self.currentUser.survey.major;
    self.enrolledSchoolSwitch.on = [self.currentUser.survey.enrolledSchool boolValue];
    
    if(![self.currentUser.survey.enrolledSchool boolValue])
    {
        self.schoolCell.hidden = YES;
        self.majorCell.hidden = YES;
    }
    
    [super viewWillAppear:animated];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if(self.majorField == textField)
    {
        self.currentUser.survey.major = textField.text;
    }
    if(self.schoolField == textField)
    {
        self.currentUser.survey.school = textField.text;
    }
    return NO;
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
    [self setEnrolledSchoolSwitch:nil];
    [self setSchoolField:nil];
    [self setMajorField:nil];
    [self setSchoolCell:nil];
    [self setMajorCell:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
