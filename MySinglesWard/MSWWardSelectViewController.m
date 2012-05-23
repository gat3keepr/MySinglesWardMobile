//
//  MSWWardSelectViewController.m
//  MySinglesWard
//
//  Created by Porter Hoskins on 5/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MSWWardSelectViewController.h"
#import "JSONRequest.h"
#import "MBProgressHUD.h"

@interface MSWWardSelectViewController ()

@end

@implementation MSWWardSelectViewController
@synthesize unitDelegate = _unitDelegate;
@synthesize delegate = _delegate;
@synthesize wards = _wards;
@synthesize wardIDs = _wardIDs;
@synthesize wardsPicker = _wardsPicker;

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.wards count];
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self.wards objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    [self.unitDelegate setWardString:[self.wards objectAtIndex:row]];
    [self.unitDelegate setWardID:[self.wardIDs objectAtIndex:row]];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //load Ward List
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        //Create the URL for the web request to get all the customers
        NSString *url = [[NSString alloc] initWithFormat:@"%@api/ward/getwards", MSWRequestURL];
        NSLog(@"WARDS GET URL request: %@", url);
        
        NSError *error = nil;
        NSDictionary *wardsResult = [JSONRequest makeWebRequestWithURL:url withJSONData:[NSJSONSerialization dataWithJSONObject:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[self.unitDelegate location],[self.unitDelegate stake], nil] forKeys:[NSArray arrayWithObjects:@"location", @"stake", nil]] options:NSJSONWritingPrettyPrinted error:&error]];
        NSLog(@"WARDS GET JSON: %@", wardsResult);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSMutableArray *data = [[NSMutableArray alloc] initWithObjects:@"Select a Ward", nil];
            NSMutableArray *ids = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithDouble:0.0], nil];
            
            [data addObjectsFromArray:[wardsResult objectForKey:@"wards"]];
            [ids addObjectsFromArray:[wardsResult objectForKey:@"ids"]];
            
            self.wards = data; 
            self.wardIDs = ids;
            [self.wardsPicker reloadAllComponents];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });            
    });
    
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section 
{
    NSString *sectionTitle = [self tableView:tableView titleForFooterInSection:section];
    if (sectionTitle == nil) {
        return nil;
    }
    
    // Create label with section title
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(20, -20, 300, 30);
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    label.shadowColor = [UIColor lightTextColor];
    label.shadowOffset = CGSizeMake(0.0, 1.0);
    label.font = [UIFont systemFontOfSize:16];
    label.text = sectionTitle;
    label.textAlignment = UITextAlignmentCenter;
    
    // Create header view and add label as a subview
    
    // you could also just return the label (instead of making a new view and adding the label as subview. With the view you have more flexibility to make a background color or different paddings
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
    
    [view addSubview:label];
    
    return view;
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
    
    //Set background image of table view
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:BACKGROUND_IMAGE]];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [self setWardsPicker:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
