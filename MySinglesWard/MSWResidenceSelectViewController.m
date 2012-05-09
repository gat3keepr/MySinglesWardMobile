//
//  MSWResidenceSelectViewController.m
//  MySinglesWard
//
//  Created by Porter Hoskins on 5/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MSWResidenceSelectViewController.h"
#import "MSWRequest.h"
#import "JSONRequest.h"
#import "MBProgressHUD.h"

@interface MSWResidenceSelectViewController ()

@property (strong, nonatomic) NSMutableArray *model;

@end

@implementation MSWResidenceSelectViewController
@synthesize model = _model;
@synthesize currentUser = _currentUser;
@synthesize residencePicker = _residencePicker;
@synthesize residenceLabel = _residenceLabel;
@synthesize spacerview = _spacerview;

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    
    return [self.model count];
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self.model objectAtIndex:row];
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
    
    self.residenceLabel.text = self.currentUser.residence;
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    self.residenceLabel.text = [self.model objectAtIndex:row];
    self.currentUser.residence = [self.model objectAtIndex:row];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    self.currentUser.residence = textField.text;
    return NO;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.model = [[NSMutableArray alloc] init];
    
    self.spacerview.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    
    NSString *url = [[NSString alloc] initWithFormat:@"%@api/ward/residences", MSWRequestURL];
    NSLog(@"RESIDENCES URL request: %@", url);
    
    [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
    dispatch_queue_t residenceQueue = dispatch_queue_create("residenceQueue", NULL);
    dispatch_async(residenceQueue, ^{
        //load Member
        NSDictionary *residenceData = [JSONRequest makeWebRequestWithURL:url withJSONData:nil];
        NSLog(@"RESIDENCE DATA response: %@", residenceData);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(residenceData)
            {
                for(NSString *residence in [residenceData objectForKey:@"residences"])
                {
                    [self.model addObject:residence];
                }
                
                [self.residencePicker reloadAllComponents];
                if([self.model indexOfObject:self.currentUser.residence])
                {
                    [self.residencePicker selectRow:[self.model indexOfObject:self.currentUser.residence] inComponent:0 animated:NO];
                }
            }
            
            
            [MBProgressHUD hideHUDForView:self.tableView animated:YES];
        });
        
    });
    
    dispatch_release(residenceQueue);

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [self setResidencePicker:nil];
    [self setResidenceLabel:nil];
    [self setSpacerview:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
