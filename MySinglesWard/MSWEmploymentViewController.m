//
//  MSWEmploymentViewController.m
//  MySinglesWard
//
//  Created by Porter Hoskins on 5/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MSWEmploymentViewController.h"
#import "MemberSurvey.h"
#import "JSONRequest.h"

@interface MSWEmploymentViewController ()

@property(weak, nonatomic) UITableViewCell *selectedRow;
@property (weak, nonatomic) IBOutlet UITableViewCell *fulltimeCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *partTimeCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *lookingCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *justSchoolCell;
@property (weak, nonatomic) IBOutlet UITextField *currentEmployerField;
@property (weak, nonatomic) IBOutlet UITableViewCell *currentEmployerCell;

@end

@implementation MSWEmploymentViewController
@synthesize selectedRow = _selectedRow;
@synthesize fulltimeCell = _fulltimeCell;
@synthesize partTimeCell = _partTimeCell;
@synthesize lookingCell = _lookingCell;
@synthesize justSchoolCell = _justSchoolCell;
@synthesize currentEmployerField = _currentEmployerField;
@synthesize currentEmployerCell = _currentEmployerCell;
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
    
    self.currentEmployerField.text = self.currentUser.survey.occupation;
    
    if([self.currentUser.survey.employed isEqualToString:@"Full-Time"])
    {
        self.selectedRow = self.fulltimeCell;
        self.currentEmployerCell.hidden = NO;
    }
    else if([self.currentUser.survey.employed isEqualToString:@"Part-Time"])
    {
        self.selectedRow = self.partTimeCell;
        self.currentEmployerCell.hidden = NO;
    }
    else if([self.currentUser.survey.employed isEqualToString:@"Looking"])
    {
        self.selectedRow = self.lookingCell;
        self.currentEmployerField.text = @"";
    }
    else if([self.currentUser.survey.employed isEqualToString:@"Just School"])
    {
        self.selectedRow = self.justSchoolCell;
        self.currentEmployerField.text = @"";
    }
    
    self.selectedRow.accessoryType = UITableViewCellAccessoryCheckmark;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];

    self.currentUser.survey.occupation = textField.text;

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

- (void)viewDidUnload
{
    [self setFulltimeCell:nil];
    [self setPartTimeCell:nil];
    [self setLookingCell:nil];
    [self setJustSchoolCell:nil];
    [self setCurrentEmployerField:nil];
    [self setCurrentEmployerCell:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        self.selectedRow.accessoryType = UITableViewCellAccessoryNone;
        
        self.selectedRow = [self.tableView cellForRowAtIndexPath:indexPath];
        self.selectedRow.accessoryType = UITableViewCellAccessoryCheckmark;
        self.currentUser.survey.employed = self.selectedRow.textLabel.text;
    }
    
    if(indexPath.section == 0 && (indexPath.row == 0 || indexPath.row == 1))
    {
        self.currentEmployerCell.hidden = NO;
        [UIView animateWithDuration:.2
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{ 
                             self.currentEmployerCell.alpha = 1.0;
                         }
                         completion:nil];
    }
    else {
        [UIView animateWithDuration:.2
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{ 
                             self.currentEmployerCell.alpha = 0.0;
                         }
                         completion:nil];
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
@end
