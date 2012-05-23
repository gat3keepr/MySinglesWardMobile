//
//  MSWPersonalInformationViewController.m
//  MySinglesWard
//
//  Created by Porter Hoskins on 5/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MSWPersonalInformationViewController.h"
#import "User+Create.h"
#import "MemberSurvey+Create.h"
#import "JSONRequest.h"
#import "MBProgressHUD.h"
#import "MSWLoginTableViewController.h"

@interface MSWPersonalInformationViewController () <UITextFieldDelegate>

@property (strong, nonatomic) User *currentUser;
-(void)fillSurveyFields;
-(NSString *)getPublishLabel;

@property (nonatomic) BOOL registrationHandled;
@end

@implementation MSWPersonalInformationViewController
@synthesize currentUser = _currentUser;
@synthesize delegate = _delegate;
@synthesize prefNameField = _prefNameField;
@synthesize genderSelector = _genderSelector;
@synthesize residenceLabel = _residenceLabel;
@synthesize publishLabel = _publishLabel;
@synthesize homeAddressField = _homeAddressField;
@synthesize cellPhoneField = _cellPhoneField;
@synthesize birthdayLabel = _birthdayLabel;
@synthesize homePhoneField = _homePhoneField;
@synthesize emergencyContactField = _emergencyContactField;
@synthesize emergencyPhoneField = _emergencyPhoneField;
@synthesize homeWardField = _homeWardField;
@synthesize homeBishopField = _homeBishopField;
@synthesize priesthoodLabel = _priesthoodLabel;
@synthesize priesthoodCell = _priesthoodCell;
@synthesize registrationHandled = _registrationHandled;

- (IBAction)cancelSurvey:(id)sender {
    [[self presentingViewController] dismissModalViewControllerAnimated:YES];
}

- (IBAction)continueSurvey:(id)sender {
    //Check all the values to make sure they have been filled out
    if([self.prefNameField.text isEqualToString:@""] || [self.residenceLabel.text isEqualToString:@""] || [self.homePhoneField.text isEqualToString:@""] || [self.cellPhoneField.text isEqualToString:@""] || [self.birthdayLabel.text isEqualToString:@"MM/DD/YYYY"] || [self.homeAddressField.text isEqualToString:@""] || [self.emergencyContactField.text isEqualToString:@""] || [self.emergencyPhoneField.text isEqualToString:@""] || [self.homeWardField.text isEqualToString:@""] || [self.homeBishopField.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uncomplete Survey" message:@"Please fill out all the fields on this page." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    else {
        NSLog(@"SURVEY STATUS: %@", self.currentUser.survey.status);
        if(self.currentUser.survey.status < [NSNumber numberWithInt:1]) 
            self.currentUser.survey.status = [NSNumber numberWithInt:1];
    }
    
    //Save all the values in the form to the context
    self.currentUser.prefname = self.prefNameField.text;
    self.currentUser.cellphone = self.cellPhoneField.text;
    self.currentUser.survey.homeAddress = self.homeAddressField.text;
    self.currentUser.survey.homePhone = self.homePhoneField.text;
    self.currentUser.survey.emergContact = self.emergencyContactField.text;
    self.currentUser.survey.emergPhone = self.emergencyPhoneField.text;
    self.currentUser.survey.homeWardStake = self.homeWardField.text;
    self.currentUser.survey.homeBishop = self.homeBishopField.text;
    self.currentUser.survey.gender = [NSNumber numberWithInt:self.genderSelector.selectedSegmentIndex];
    
    //Save survey to database
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [self.currentUser.survey saveSurveyToServer];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self performSegueWithIdentifier:@"Church Information" sender:self];
        });
    });
    
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if(textField == self.prefNameField)
    {
        self.currentUser.prefname = textField.text;
    }
    else if(textField == self.cellPhoneField)
    {
        self.currentUser.cellphone = textField.text;
    }
    else if(textField == self.homeAddressField)
    {
        self.currentUser.survey.homeAddress = textField.text;
    }
    else if(textField == self.homePhoneField)
    {
        self.currentUser.survey.homePhone = textField.text;
    }
    else if(textField == self.emergencyContactField)
    {
        self.currentUser.survey.emergContact = textField.text;
    }
    else if(textField == self.emergencyPhoneField)
    {
        self.currentUser.survey.emergPhone = textField.text;
    }
    else if(textField == self.homeWardField)
    {
        self.currentUser.survey.homeWardStake = textField.text;
    }
    else if(textField == self.homeBishopField)
    {
        self.currentUser.survey.homeBishop = textField.text;
    }
    
    return YES;
}

-(void)loadSurvey
{
    //Set Loading Modal
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        //Get survey information from server
        //Create the URL for the web request to get the survey
        NSString *url = [[NSString alloc] initWithFormat:@"%@api/member/getsurvey/%@", MSWRequestURL,self.currentUser.memberID];
        NSLog(@"SURVEY DATA URL request: %@", url);
        
        //load Ward List
        NSDictionary *surveyData = [JSONRequest makeWebRequestWithURL:url withJSONData:nil];
        NSLog(@"SURVEY DATA response: %@", surveyData);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(surveyData)
                [MemberSurvey surveyWithJSON:surveyData inManagedObjectContext:[self.delegate getMSWDatabase].managedObjectContext];
    
            [self fillSurveyFields];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            self.navigationItem.rightBarButtonItem.enabled = YES;
        });
    });
}

-(void)fillSurveyFields
{
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    
    //Handle registration
    if([[pref objectForKey:REGISTRATION] boolValue] && !self.registrationHandled)
    {
        //Initialize Survey
        self.currentUser.survey = [NSEntityDescription insertNewObjectForEntityForName:MEMBER_SURVEY inManagedObjectContext:self.currentUser.managedObjectContext];
        self.currentUser.survey.member = self.currentUser;
        self.currentUser.survey.memberID = self.currentUser.memberID;
        self.currentUser.survey.status = [NSNumber numberWithInt:1];
         
        self.currentUser.prefname = @"";
        self.currentUser.residence = @"";
        self.currentUser.cellphone = @"";
        self.currentUser.survey.birthday = @"MM/DD/YYYY";
        self.currentUser.survey.publishCell = [NSNumber numberWithInt:1];
        self.currentUser.survey.publishEmail = [NSNumber numberWithInt:1];
        self.currentUser.survey.homeAddress = @""; 
        self.currentUser.survey.homePhone = @"";
        self.currentUser.survey.emergContact = @"";
        self.currentUser.survey.emergPhone = @"";
        self.currentUser.survey.homeWardStake = @"";
        self.currentUser.survey.homeBishop = @"";
        
        self.priesthoodCell.hidden = YES;
        self.priesthoodLabel.text = self.currentUser.survey.priesthood = @"N/A";
        
        self.registrationHandled = YES;
    }
        
    int MALE = 1;
    int FEMALE = 0;
    
    self.prefNameField.text = self.currentUser.prefname;
    self.genderSelector.selectedSegmentIndex = [self.currentUser.survey.gender intValue];
    self.residenceLabel.text = self.currentUser.residence;
    self.cellPhoneField.text = self.currentUser.cellphone;
    self.birthdayLabel.text = self.currentUser.survey.birthday;
    self.homePhoneField.text = self.currentUser.survey.homePhone;
    self.emergencyContactField.text = self.currentUser.survey.emergContact;
    self.emergencyPhoneField.text = self.currentUser.survey.emergPhone;
    self.homeWardField.text = self.currentUser.survey.homeWardStake;
    self.homeBishopField.text = self.currentUser.survey.homeBishop;
    self.publishLabel.text = [self getPublishLabel];
    self.homeAddressField.text = self.currentUser.survey.homeAddress;
    
    if([self.currentUser.survey.gender intValue] == MALE)
    {
        self.priesthoodCell.hidden = NO;
        self.priesthoodLabel.text = self.currentUser.survey.priesthood;
    }
    else if([self.currentUser.survey.gender intValue] == FEMALE)
    {
        self.priesthoodCell.hidden = YES;
        self.priesthoodLabel.text = self.currentUser.survey.priesthood = @"N/A";
    }
    
    
    [self.tableView reloadData];
}

-(NSString *)getPublishLabel
{
    if([self.currentUser.survey.publishCell boolValue] && [self.currentUser.survey.publishEmail boolValue])
    {
        return @"Show Email & Cell Phone";
    }
    else if([self.currentUser.survey.publishEmail boolValue])
    {
        return @"Show Email Only";
    }
    else if([self.currentUser.survey.publishCell boolValue])
    {
        return @"Show Cell Phone Only";
    }
    else 
    {
        return @"Show None";
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.destinationViewController respondsToSelector:@selector(setCurrentUser:)])
    {
        [segue.destinationViewController setCurrentUser:self.currentUser];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (void)genderSelected:(id)sender{
    if(self.genderSelector.selectedSegmentIndex == 0)
    {
        self.priesthoodCell.hidden = YES;
        self.priesthoodLabel.text = self.currentUser.survey.priesthood = @"N/A";
    }
    else {
        self.priesthoodCell.hidden = NO;
        self.priesthoodLabel.text = self.currentUser.survey.priesthood = @"Not Ordained";
    }
    
    self.currentUser.survey.gender = [NSNumber numberWithInt:self.genderSelector.selectedSegmentIndex];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    self.currentUser = [User userWithID:[pref objectForKey:MEMBERID] inManagedObjectContext:[self.delegate getMSWDatabase].managedObjectContext];

    [self loadSurvey];
    
    [self.genderSelector addTarget:self 
                         action:@selector(genderSelected:)  
               forControlEvents:UIControlEventValueChanged];
    
    //Set background image of table view
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:BACKGROUND_IMAGE]];
   
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self fillSurveyFields];
    
    //Handle registration response
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    if([[pref objectForKey:REGISTRATION] boolValue])
    {
        self.navigationItem.leftBarButtonItem = nil;
    }
}

- (void)viewDidUnload
{
    [self setPrefNameField:nil];
    [self setGenderSelector:nil];
    [self setResidenceLabel:nil];
    [self setCellPhoneField:nil];
    [self setBirthdayLabel:nil];
    [self setHomePhoneField:nil];
    [self setEmergencyContactField:nil];
    [self setEmergencyPhoneField:nil];
    [self setHomeWardField:nil];
    [self setHomeBishopField:nil];
    [self setPriesthoodLabel:nil];
    [self setPriesthoodCell:nil];
    [self setBirthdayLabel:nil];
    [self setResidenceLabel:nil];
    [self setPublishLabel:nil];
    [self setHomeAddressField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Birthday
    if(indexPath.row == 5)
    {
       
    }
}

@end
