//
//  MSWBishopricListViewController.m
//  MySinglesWard
//
//  Created by Porter Hoskins on 5/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MSWBishopricListViewController.h"
#import "Ward.h"
#import "User+Create.h"
#import "MBProgressHUD.h"
#import "Photo.h"
#import "MSWMemberViewController.h"

@interface MSWBishopricListViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *refreshButton;
-(void)setupFetchedResultsController;
-(void)getBishopricList;
@end

@implementation MSWBishopricListViewController
@synthesize refreshButton = _refreshButton;

@synthesize currentWard = _currentWard;
@synthesize databaseDelegate = _databaseDelegate;

-(void)setCurrentWard:(Ward *)currentWard
{
    if(_currentWard != currentWard)
    {
        _currentWard = currentWard;
    }
}

-(void)setupFetchedResultsController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    request.predicate = [NSPredicate predicateWithFormat:@"(ward = %@) AND (isBishopric = 1)", self.currentWard];
    request.sortDescriptors = [NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"bishopricData.sortID" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)], nil];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:[self.databaseDelegate getMSWDatabase].managedObjectContext sectionNameKeyPath:@"calling.title" cacheName:nil];
}

- (IBAction)refreshWardList:(id)sender {
    [self getBishopricList];
}

-(void)getBishopricList
{
    //Create the URL for the web request to get all the customers
    self.title = @"Loading...";
    
    UIBarButtonItem *orgButton = self.navigationItem.rightBarButtonItem;
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [spinner startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    
    //Set Loading Modal
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        [self.databaseDelegate loadBishopricListWithSender:self.tableView];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.navigationItem.rightBarButtonItem = orgButton;
            self.title = @"Bishopric";
            [self.tableView reloadData];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.navigationItem.title = @"Bishopric";
    self.tabBarController.navigationItem.rightBarButtonItem = self.refreshButton;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self setupFetchedResultsController];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Bishopric Member";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    User *user = [self.fetchedResultsController objectAtIndexPath:indexPath];
    UILabel *memberName = (UILabel *)[cell viewWithTag:1];
    memberName.text = [NSString stringWithFormat:@"%@", user.prefname, user.prefname];
    
    UIImageView *photo = (UIImageView *)[cell viewWithTag:2];
    [photo setImage:[UIImage imageWithData:user.photo.photoData]];
    
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *path = [self.tableView indexPathForCell:sender];
    User *user = [self.fetchedResultsController objectAtIndexPath:path];
    
    if([segue.destinationViewController respondsToSelector:@selector(setUser:)])
    {
        [segue.destinationViewController setUser:user];
    }
}

- (void)viewDidUnload {
    [self setRefreshButton:nil];
    [super viewDidUnload];
}
@end
