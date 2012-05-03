//
//  MSWLoginTableViewController.m
//  MySinglesWard
//
//  Created by Porter Hoskins on 4/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MSWLoginTableViewController.h"
#import "MSWRequest.h"
#import "JSONRequest.h"
#import "MSWProfileTableViewController.h"

@interface MSWLoginTableViewController ()
@property (weak, nonatomic) IBOutlet UILabel *downloadLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *downloadProgress;
@property (weak, nonatomic) IBOutlet UITableViewCell *logoCell1;
@property (weak, nonatomic) IBOutlet UITableViewCell *logoCell2;
@property (weak, nonatomic) IBOutlet UITableViewCell *logoCell3;
@property (weak, nonatomic) IBOutlet UITableViewCell *logoCell4;
@property (weak, nonatomic) IBOutlet UITableViewCell *logoCell5;
@property (weak, nonatomic) IBOutlet UITableViewCell *logoCell6;
@end

@implementation MSWLoginTableViewController
@synthesize downloadLabel;
@synthesize downloadProgress;
@synthesize logoCell1;
@synthesize logoCell2;
@synthesize logoCell3;
@synthesize logoCell4;
@synthesize logoCell5;
@synthesize logoCell6;
@synthesize tableView;
@synthesize emailAddressField;
@synthesize passwordField;

#define NEEDS_NOTHING @"NEEDS_NOTHING"
#define NEEDS_PHOTO @"NEEDS_PHOTO"
#define NEEDS_SURVEY @"NEEDS_SURVEY"

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)tapOut:(id)sender {
    [self.emailAddressField resignFirstResponder];
    [self.passwordField resignFirstResponder];
}

- (IBAction)login:(UIButton *)sender {
    
    //Create Login JSON object
    NSDictionary *login = [[NSDictionary alloc] initWithObjectsAndKeys:self.emailAddressField.text, @"email", self.passwordField.text,@"password", nil];    
    
    NSError *error = nil;

    NSLog(@"Login JSON object: %@", login);
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:login options:NSJSONWritingPrettyPrinted error:&error];
    NSString* requestDataLengthString = [[NSString alloc] initWithFormat:@"%d", [jsonData length]];
    
    //Create the URL for the web request to get all the customers
    NSString *url = [[NSString alloc] initWithFormat:@"%@api/authentication/login", MSWRequestURL];
    NSLog(@"LOG IN URL request: %@", url);
    
    dispatch_queue_t loginQueue = dispatch_queue_create("loginQueue", NULL);
    dispatch_async(loginQueue, ^{
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[[NSURL alloc] initWithString:url]];
        
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:jsonData];
        [request setHTTPShouldHandleCookies:YES];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:requestDataLengthString forHTTPHeaderField:@"Content-Length"];
        
        NSError *errorReturned = nil;
        
        NSURLResponse *response = [[NSURLResponse alloc] init];
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&errorReturned];         
        
        if(error)
        {
            NSLog(@"LOG IN ERROR: %@", errorReturned);
        }
        else 
        {            
            NSError *jsonError = nil;
            @try {
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
                
                NSLog(@"%@", json);
                
                NSArray *loggedInStatus = [json objectForKey:@"authentication"];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if([loggedInStatus containsObject:NEEDS_NOTHING])
                    {
                        [self performSegueWithIdentifier:@"LoggedIn" sender:self];
                    }
                    else if([loggedInStatus containsObject:NEEDS_PHOTO])
                    {
                        
                    }
                    else if([loggedInStatus containsObject:NEEDS_SURVEY])
                    {
                        
                    }
                    else
                    {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid login" message:@"The username/password was incorrect." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [alert show];                
                    }
                });
            }
            @catch (NSException *exception) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Internet Connection" message:@"Please connect to the internet." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show]; 
            }
        }
        
    });
    dispatch_release(loginQueue);   
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[UIControl class]]) {
        // we touched a button, slider, or other UIControl
        return NO; // ignore the touch
    }
    return YES; // handle the touch
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.destinationViewController respondsToSelector:@selector(loadWardList:)])
    {
        
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.logoCell1.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    self.logoCell2.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    self.logoCell3.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    self.logoCell4.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    self.logoCell5.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    self.logoCell6.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iphone-background.png"]];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [self setEmailAddressField:nil];
    [self setPasswordField:nil];
    [self setLogoCell1:nil];
    [self setLogoCell2:nil];
    [self setLogoCell3:nil];
    [self setLogoCell4:nil];
    [self setLogoCell5:nil];
    [self setLogoCell6:nil];
    [self setTableView:nil];
    [self setDownloadProgress:nil];
    [self setDownloadLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
