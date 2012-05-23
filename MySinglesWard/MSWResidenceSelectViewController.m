//
//  MSWResidenceSelectViewController.m
//  MySinglesWard
//
//  Created by Porter Hoskins on 5/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MSWResidenceSelectViewController.h"
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
    
    //Set background image of table view
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:BACKGROUND_IMAGE]];
    
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
