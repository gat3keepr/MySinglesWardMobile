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
#import "MSWRequest.h"
#import "Photo.h"
#import "JSONRequest.h"

@interface MSWWardViewController ()
-(void)setupFetchedResultsController;
-(void)getWardList;
@end

@implementation MSWWardViewController
@synthesize currentWard = _currentWard;
@synthesize databaseDelegate = _databaseDelegate;

-(void)setCurrentWard:(Ward *)currentWard
{
    if(_currentWard != currentWard)
    {
        _currentWard = currentWard;
        [self setupFetchedResultsController];
        [self getWardList];
    }
}

-(void)setupFetchedResultsController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    request.predicate = [NSPredicate predicateWithFormat:@"ward = %@", self.currentWard];
    request.sortDescriptors = [NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"lastname" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)], [NSSortDescriptor sortDescriptorWithKey:@"prefname" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)], nil];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:[self.databaseDelegate getMSWDatabase].managedObjectContext sectionNameKeyPath:nil cacheName:nil];
}

-(void)getWardList
{
    //Create the URL for the web request to get all the customers
    self.title = @"Loading...";
    
    UIBarButtonItem *orgButton = self.navigationItem.rightBarButtonItem;
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [spinner startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    dispatch_queue_t wardListQueue = dispatch_queue_create("wardListQueue", NULL);
    dispatch_async(wardListQueue, ^{
        
        [self.databaseDelegate loadWardList];
        
        dispatch_async(dispatch_get_main_queue(), ^{            
            self.navigationItem.rightBarButtonItem = orgButton;
            self.title = @"Ward List";
        });        
        
    });
    
    dispatch_release(wardListQueue);
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
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
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

@end
