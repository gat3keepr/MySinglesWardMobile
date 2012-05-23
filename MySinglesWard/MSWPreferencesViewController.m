//
//  MSWPreferencesViewController.m
//  MySinglesWard
//
//  Created by Porter Hoskins on 5/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MSWPreferencesViewController.h"
#import "JSONRequest.h"
#import "MSWNotificationViewController.h"

@interface MSWPreferencesViewController ()

@end

@implementation MSWPreferencesViewController
@synthesize delegate = _delegate;

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
    
    //Set background image of table view
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:BACKGROUND_IMAGE]];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UINavigationController *nav = segue.destinationViewController;
    MSWNotificationViewController *controller = (MSWNotificationViewController *)nav.topViewController;
    if([controller respondsToSelector:@selector(setDelegate:)])
    {
        [controller setDelegate:self.delegate];
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //PREFERENCES
    if(indexPath.section == 0 && indexPath.row == 0)
    {
        
    }
    
    //LOG OUT
    if(indexPath.section == 1 && indexPath.row == 0)
    {
        NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
        
        [pref setObject:@"NO" forKey:LOGGED_IN];
        [pref setObject:@"NO" forKey:DATA_LOADED];
        [pref setObject:nil forKey:MEMBERID];
        [pref setObject:nil forKey:REGISTRATION];
        [pref setObject:nil forKey:REGISTRATION_STEP];
        [pref setObject:nil forKey:ISBISHOPRIC];
        [pref synchronize];
        [self.navigationController.presentingViewController dismissModalViewControllerAnimated:YES];
    }
}

@end
