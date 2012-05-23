//
//  MSWBishopricDataViewController.m
//  MySinglesWard
//
//  Created by Porter Hoskins on 5/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MSWBishopricDataViewController.h"
#import "MBProgressHUD.h"
#import "User+Create.h"
#import "BishopricData+Create.h"
#import "JSONRequest.h"
#import "Calling.h"

@interface MSWBishopricDataViewController () <UITextFieldDelegate>

@property (nonatomic) BOOL registrationHandled;

@end

@implementation MSWBishopricDataViewController
@synthesize nameField;
@synthesize callingLabel;
@synthesize wifeNameField;
@synthesize wifePhoneField;
@synthesize phoneField;
@synthesize addressField;
@synthesize delegate = _delegate;
@synthesize currentUser = _currentUser;
@synthesize registrationHandled = _registrationHandled;

- (IBAction)cancelSurvey:(id)sender {
    [[self presentingViewController] dismissModalViewControllerAnimated:YES];
}

- (IBAction)saveBishopricData:(id)sender {
    //Check all the values to make sure they have been filled out
    if([self.nameField.text isEqualToString:@""] || [self.callingLabel.text isEqualToString:@"None"] || [self.phoneField.text isEqualToString:@""] || [self.addressField.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uncomplete Information" message:@"Please fill out all the fields on this page." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    //Save all the values in the form to the context
    self.currentUser.prefname = self.nameField.text;
    self.currentUser.cellphone = self.phoneField.text;
    self.currentUser.bishopricData.wifeName = self.wifeNameField.text;
    self.currentUser.bishopricData.wifePhone = self.wifePhoneField.text;
    
    //Save survey to database
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [self.currentUser.bishopricData saveDataToServer];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            //Handle Registration
            NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
            if([[pref objectForKey:REGISTRATION] boolValue])
            {
                [pref setObject:DONE forKey:REGISTRATION_STEP];
                [pref synchronize];
            }
            
            [[self presentingViewController] dismissModalViewControllerAnimated:YES];
        });
    });
    
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if(textField == self.nameField)
    {
        self.currentUser.prefname = textField.text;
    }
    else if(textField == self.phoneField)
    {
        self.currentUser.cellphone = textField.text;
    }
    else if(textField == self.addressField)
    {
        self.currentUser.residence = textField.text;
    }
    else if(textField == self.wifeNameField)
    {
        self.currentUser.bishopricData.wifeName = textField.text;
    }
    else if(textField == self.wifePhoneField)
    {
        self.currentUser.bishopricData.wifePhone = textField.text;
    }
    
    return YES;
}

-(void)loadData
{
    //Set Loading Modal
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        //Get survey information from server
        //Create the URL for the web request to get the survey
        NSString *url = [[NSString alloc] initWithFormat:@"%@api/member/getbishopricdata/%@", MSWRequestURL,self.currentUser.memberID];
        NSLog(@"BISHOPRIC DATA URL request: %@", url);
        
        //load bishopic data
        NSDictionary *bishopricData = [JSONRequest makeWebRequestWithURL:url withJSONData:nil];
        NSLog(@"BISHOPRIC DATA response: %@", bishopricData);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(bishopricData)
                [BishopricData dataWithJSON:bishopricData inManagedObjectContext:[self.delegate getMSWDatabase].managedObjectContext];
            
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
        self.currentUser.bishopricData = [NSEntityDescription insertNewObjectForEntityForName:BISHOPRIC_DATA inManagedObjectContext:self.currentUser.managedObjectContext];
        self.currentUser.bishopricData.member = self.currentUser;
        self.currentUser.bishopricData.memberID = self.currentUser.memberID;
        
        self.currentUser.prefname = @"";
        self.currentUser.residence = @"";
        self.currentUser.cellphone = @"";
        
        self.registrationHandled = YES;
    }
    
    self.nameField.text = self.currentUser.prefname;
    self.callingLabel.text = self.currentUser.calling.title;
    if (![self.currentUser.bishopricData.wifeName isEqualToString:@" "]) {
        self.wifeNameField.text = self.currentUser.bishopricData.wifeName;
    }
    if (![self.currentUser.bishopricData.wifePhone isEqualToString:@" "]) {
        self.wifePhoneField.text = self.currentUser.bishopricData.wifePhone;
    }
    self.phoneField.text = self.currentUser.cellphone;
    self.addressField.text = self.currentUser.residence;
    
    [self.tableView reloadData];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.destinationViewController respondsToSelector:@selector(setCurrentUser:)])
    {
        [segue.destinationViewController setCurrentUser:self.currentUser];
    }
}

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
    [self fillSurveyFields];
    
    //Handle registration response
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    if([[pref objectForKey:REGISTRATION] boolValue])
    {
        self.navigationItem.leftBarButtonItem = nil;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    self.currentUser = [User userWithID:[pref objectForKey:MEMBERID] inManagedObjectContext:[self.delegate getMSWDatabase].managedObjectContext];
    
    [self loadData];
    
    //Set background image of table view
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:BACKGROUND_IMAGE]];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [self setNameField:nil];
    [self setCallingLabel:nil];
    [self setWifeNameField:nil];
    [self setWifePhoneField:nil];
    [self setPhoneField:nil];
    [self setAddressField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
