//
//  MSWOtherInformationViewController.m
//  MySinglesWard
//
//  Created by Porter Hoskins on 5/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MSWOtherInformationViewController.h"
#import "MemberSurvey+Create.h"
#import "MBProgressHUD.h"

@interface MSWOtherInformationViewController ()

@end

@implementation MSWOtherInformationViewController
@synthesize currentUser = _currentUser;

- (IBAction)finishSurvey:(id)sender {
    
    //Save survey to database
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [self.currentUser.survey saveSurveyToServer];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
    
            [[self presentingViewController] dismissModalViewControllerAnimated:YES];
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
    if([segue.destinationViewController respondsToSelector:@selector(setCurrentUser:)])
    {
        [segue.destinationViewController setCurrentUser:self.currentUser];
    }  
}


@end
