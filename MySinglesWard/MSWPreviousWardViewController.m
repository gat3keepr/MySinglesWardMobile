//
//  MSWPreviousWardViewController.m
//  MySinglesWard
//
//  Created by Porter Hoskins on 5/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MSWPreviousWardViewController.h"
#import "MemberSurvey.h"

@interface MSWPreviousWardViewController ()
@end

@implementation MSWPreviousWardViewController
@synthesize currentUser = _currentUser;
@synthesize inputView = _inputView;
@synthesize saveButton = _saveButton;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)saveButtonPressed:(id)sender 
{
    [self.inputView resignFirstResponder];
    self.currentUser.survey.prevBishops = self.inputView.text;
    
    self.navigationItem.rightBarButtonItem = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    self.inputView.text = self.currentUser.survey.prevBishops;
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = nil;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [self setInputView:nil];
    [self setSaveButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.navigationItem.rightBarButtonItem = self.saveButton;
}

@end
