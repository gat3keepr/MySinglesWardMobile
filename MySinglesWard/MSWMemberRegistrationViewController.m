//
//  MSWMemberRegistrationViewController.m
//  MySinglesWard
//
//  Created by Porter Hoskins on 4/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MSWMemberRegistrationViewController.h"
#import "JSONRequest.h"
#import "MBProgressHUD.h"

@interface MSWMemberRegistrationViewController () <UITextFieldDelegate>
@end

@implementation MSWMemberRegistrationViewController
@synthesize agreeToTermsSwitch;
@synthesize firstNameField;
@synthesize lastNameField;
@synthesize emailField;
@synthesize emailConfirmField;
@synthesize passwordField;

- (IBAction)submitRegistration:(id)sender 
{
    //Didnt agree to terms
    if(!agreeToTermsSwitch.on)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Agree To Terms" message:@"Please agree to MySinglesWard.com's terms." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    //Form not complete
    if([firstNameField.text isEqualToString:@""] || [lastNameField.text isEqualToString:@""] || [emailField.text isEqualToString:@""] || [emailConfirmField.text isEqualToString:@""] || [passwordField.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Incomplete Registration" message:@"Please fill out the entire registration form." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    //Email invalid
    if(![self NSStringIsValidEmail:emailField.text])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email Not Valid" message:@"Please enter a valid email address." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    //Emails dont match
    if(![emailField.text isEqualToString:emailConfirmField.text])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Emails Don't Match" message:@"Please make sure your confirmation email matches your email." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    //Password not long enough
    if([passwordField.text length] < 6)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Password Length" message:@"Please make sure your password is at least 6 characters long." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    //Send registration request
    NSDictionary *registerModel = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:self.firstNameField.text,self.lastNameField.text, self.emailField.text, self.passwordField.text, nil] forKeys:[NSArray arrayWithObjects:@"FirstName", @"LastName", @"Email", @"Password", nil]];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        //Create the URL for the web request to get all the customers
        NSString *url = [[NSString alloc] initWithFormat:@"%@api/authentication/register", MSWRequestURL];
        NSLog(@"REGISTER URL request: %@", url);
        
        NSError *error = nil;
        
        NSDictionary *registerResult = [JSONRequest makeWebRequestWithURL:url withJSONData:[NSJSONSerialization dataWithJSONObject:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:registerModel, nil] forKeys:[NSArray arrayWithObjects:@"model", nil]] options:NSJSONWritingPrettyPrinted error:&error]];
        NSLog(@"REGISTER JSON: %@", registerResult);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if([registerResult objectForKey:@"memberID"] != [NSNumber numberWithInt:0])
            {
                //Set the user that is logged in
                [pref setObject:[registerResult objectForKey:@"memberID"] forKey:MEMBERID];
                [self.delegate loginNewUserWithEmail:self.emailField.text withPassword:self.passwordField.text];
            }
            else if(!registerResult) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Try Again Later" message:@"Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
            else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email Already In Use" message:@"Please use a different email address." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
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

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [self setAgreeToTermsSwitch:nil];
    [self setFirstNameField:nil];
    [self setLastNameField:nil];
    [self setEmailField:nil];
    [self setEmailConfirmField:nil];
    [self setPasswordField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField 
{
    if ([textField.text isEqualToString:@""]) {
        return NO;
    }
    
    [textField resignFirstResponder];
    return YES;
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
