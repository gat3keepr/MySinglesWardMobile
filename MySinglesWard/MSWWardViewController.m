//
//  MSWWardViewController.m
//  MySinglesWard
//
//  Created by Porter Hoskins on 5/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MSWWardViewController.h"
#import "User+Create.h"
#import "MemberSurvey.h"
#import "Photo.h"
#import "JSONRequest.h"
#import "MSWMemberViewController.h"
#import "MBProgressHUD.h"

@interface MSWWardViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *refreshButton;
-(void)setupFetchedResultsController;
-(void)getWardList;
@end

@implementation MSWWardViewController
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
    request.predicate = [NSPredicate predicateWithFormat:@"(ward = %@) AND (isBishopric = 0)", self.currentWard];
    request.sortDescriptors = [NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"lastname" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)], [NSSortDescriptor sortDescriptorWithKey:@"prefname" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)], nil];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:[self.databaseDelegate getMSWDatabase].managedObjectContext sectionNameKeyPath:@"userLastNameInitial" cacheName:nil];
}

- (IBAction)refreshWardList:(id)sender {
    [self getWardList];
}

-(void)getWardList
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
        
        [self.databaseDelegate loadWardListWithSender:self.tableView];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.navigationItem.rightBarButtonItem = orgButton;
            self.title = @"Ward List";
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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setupFetchedResultsController];
}

- (void)viewDidUnload
{
    [self setRefreshButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(void)viewWillAppear:(BOOL)animated    
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    self.tabBarController.navigationItem.title = @"Ward List";
    self.tabBarController.navigationItem.rightBarButtonItem = self.refreshButton;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Ward Member";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    User *user = [self.fetchedResultsController objectAtIndexPath:indexPath];
    UILabel *memberName = (UILabel *)[cell viewWithTag:1];
    memberName.text = [NSString stringWithFormat:@"%@, %@", user.lastname, user.prefname];
    
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

@end
