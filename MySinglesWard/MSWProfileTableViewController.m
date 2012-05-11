//
//  MSWProfileTableViewController.m
//  MySinglesWard
//
//  Created by Porter Hoskins on 4/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MSWProfileTableViewController.h"
#import "JSONRequest.h"
#import "MSWRequest.h"
#import "Ward.h"
#import "User+Create.h"
#import "MemberSurvey.h"
#import "Photo.h"
#import <QuartzCore/QuartzCore.h>
#import "MSWWardViewController.h"
#import "MBProgressHUD.h"
#import "MSWPreferencesViewController.h"
#import "MSWPersonalInformationViewController.h"


@interface MSWProfileTableViewController ()

@property (weak, nonatomic) IBOutlet UITableViewCell *TitleCell;
-(void)setMemberProfile;
@property (strong, nonatomic) User *currentUser;
@end

@implementation MSWProfileTableViewController
@synthesize TitleCell;
@synthesize mswDatabase = _mswDatabase;
@synthesize memberName = _memberName;
@synthesize memberPhoto = _memberPhoto;
@synthesize wardName = _wardName;
@synthesize currentUser = _currentUser;
@synthesize backgroundContext = _backgroundContext;

-(void)setMswDatabase:(UIManagedDocument *)mswDatabase
{
    if(_mswDatabase != mswDatabase)
    {
        _mswDatabase = mswDatabase;
    }
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

    self.TitleCell.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    
    //Open the database
    if(!self.mswDatabase)
    {
        NSURL *databaseURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        databaseURL = [databaseURL URLByAppendingPathComponent:@"MSW Database"];
        
        dispatch_queue_t CDQueue = dispatch_queue_create("coredataQueue", NULL);
        dispatch_async(CDQueue, ^{    
            self.mswDatabase = [[UIManagedDocument alloc] initWithFileURL:databaseURL];
        });
    }
    
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    self.currentUser = [User userWithID:[pref objectForKey:MEMBERID] inManagedObjectContext:self.mswDatabase.managedObjectContext];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated
{
    //Check to see if the member is in the database, if not, go and get it from the server
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    self.currentUser = [User userWithID:[pref objectForKey:MEMBERID] inManagedObjectContext:self.mswDatabase.managedObjectContext];
    [self setMemberProfile];
    [super viewWillAppear:animated];
}

-(void)setMemberProfile
{
    if(![self.currentUser.isBishopric boolValue])
        self.memberName.text = [NSString stringWithFormat:@"%@ %@", self.currentUser.prefname, self.currentUser.lastname];
    else
        self.memberName.text = [NSString stringWithFormat:@"%@", self.currentUser.prefname];
    
    self.wardName.text = [NSString stringWithFormat:@"%@ %@ Ward", self.currentUser.ward.location, self.currentUser.ward.ward];
    
    
    self.memberPhoto.layer.cornerRadius = 5.0;
    self.memberPhoto.layer.masksToBounds = YES;
    
    self.memberPhoto.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.memberPhoto.layer.borderWidth = 1.0;
    [self.memberPhoto setImage:[UIImage imageWithData:self.currentUser.photo.photoData]];
}

-(void)loadWardListWithSender:(UIView *)sender
{
    self.backgroundContext = [[NSManagedObjectContext alloc] init];
    self.backgroundContext.persistentStoreCoordinator = [self.mswDatabase.managedObjectContext persistentStoreCoordinator];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(contextChanged:)
                                                 name:NSManagedObjectContextDidSaveNotification
                                               object:self.backgroundContext];
    
    //Create the URL for the web request to get all the customers
    NSString *url = [[NSString alloc] initWithFormat:@"%@api/ward/listIDs", MSWRequestURL];
    NSLog(@"WARD LIST DATA URL request: %@", url);
    
    //load Ward List
    NSDictionary *wardListData = [JSONRequest makeWebRequestWithURL:url withJSONData:nil];
    NSLog(@"WARD LIST DATA response: %@", wardListData);
    
    //Check to see if the request could not be made
    if(!wardListData)
    {
        return;
    }
    
    //Create an array to record current ward members
    NSMutableArray *currentWard = [[NSMutableArray alloc] init];
        
    for(NSNumber *memberID in [wardListData objectForKey:@"members"])
    {
        if(![User userWithID:memberID inManagedObjectContext:self.backgroundContext])
        {
            //Create the URL for the web request to get all the customers
            NSString *memberURL = [[NSString alloc] initWithFormat:@"%@api/member/get/%@", MSWRequestURL,memberID];
            NSLog(@"MEMBER DATA URL request: %@", memberURL);
            
            NSDictionary *memberData = [JSONRequest makeWebRequestWithURL:memberURL withJSONData:nil];
            NSLog(@"MEMBER DATA response: %@", memberData);
            
            //Save User
                [User userWithAllMemberData:memberData inManagedObjectContext:self.backgroundContext];
        }
        
        [currentWard addObject:memberID];
    }
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    request.predicate = [NSPredicate predicateWithFormat:@"(ward = %@) AND (isBishopric = 0)", self.currentUser.ward];
    
    NSError *error = nil;
    NSArray *members = [self.backgroundContext executeFetchRequest:request error:&error];
    
    for(User *user in members)
    {
        if(![currentWard containsObject:user.memberID])
        {
            [self.backgroundContext deleteObject:user];
        }                
    }
    
    NSError *saveError = nil;
    [self.backgroundContext save:&saveError];
}

-(void)loadBishopricListWithSender:(UIView *)sender
{
    self.backgroundContext = [[NSManagedObjectContext alloc] init];
    self.backgroundContext.persistentStoreCoordinator = [self.mswDatabase.managedObjectContext persistentStoreCoordinator];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                    selector:@selector(contextChanged:)
                        name:NSManagedObjectContextDidSaveNotification
                      object:self.backgroundContext];
    
    //Create the URL for the web request to get all the customers
    NSString *url = [[NSString alloc] initWithFormat:@"%@api/ward/bishopric", MSWRequestURL];
    NSLog(@"BISHOPRIC LIST DATA URL request: %@", url);
    
    //load Ward List
    NSDictionary *wardListData = [JSONRequest makeWebRequestWithURL:url withJSONData:nil];
    NSLog(@"BISHOPRIC LIST DATA response: %@", wardListData);
    
    //Check to see if the request could not be made
    if(!wardListData)
    {
        return;
    }
    
    //Create an array to record current bishopric users
    NSMutableArray *currentBishopric = [[NSMutableArray alloc] init];
    
    for(NSDictionary *bishopricmember in wardListData)
    {
        NSLog(@"BISHOPRIC DATA response: %@", bishopricmember); 
        [self.mswDatabase.managedObjectContext performBlock:^{
            [User userWithAllMemberData:bishopricmember inManagedObjectContext:self.mswDatabase.managedObjectContext];
        }];
        [currentBishopric addObject:[[bishopricmember objectForKey:@"user"] objectForKey:@"MemberID"]];
    }
    
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    User *user = [User userWithID:[pref objectForKey:@"memberID"] inManagedObjectContext:self.mswDatabase.managedObjectContext];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    request.predicate = [NSPredicate predicateWithFormat:@"(wardID = %@) AND (isBishopric = 1)", user.wardID];
    
    NSError *error = nil;
    NSArray *members = [self.mswDatabase.managedObjectContext executeFetchRequest:request error:&error];
    
    [self.backgroundContext save:&error];
    for(User *bUser in members)
    {
        if(![currentBishopric containsObject:bUser.memberID])
        {
            [self.mswDatabase.managedObjectContext performBlock:^{
                [self.mswDatabase.managedObjectContext deleteObject:bUser];
            }];
        }                
    }
}

-(void)contextChanged:(NSNotification *)notification
{
    [self.mswDatabase.managedObjectContext mergeChangesFromContextDidSaveNotification:notification]; 
}

- (void)viewDidUnload
{
    [self setTitleCell:nil];
    [self setMemberName:nil];
    [self setMemberPhoto:nil];
    [self setWardName:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(UIManagedDocument *)getMSWDatabase
{
    return self.mswDatabase;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.destinationViewController respondsToSelector:@selector(setDatabaseDelegate:)])
    {
        [segue.destinationViewController setDatabaseDelegate:self];
    }
    
    if([segue.destinationViewController respondsToSelector:@selector(setCurrentWard:)])
    {
        [segue.destinationViewController setCurrentWard:self.currentUser.ward];
    }
    else
    {
        if([segue.destinationViewController respondsToSelector:@selector(setDelegate:)])
        {
            [segue.destinationViewController setDelegate:self];
        }
    }
    
    //Set delegate on a controller behind a navigation controller
    if([segue.destinationViewController isKindOfClass:[UINavigationController class]])
    {
        UINavigationController *nav = segue.destinationViewController;
    
        MSWPersonalInformationViewController *controller = (MSWPersonalInformationViewController *)nav.topViewController;
        
        if([controller respondsToSelector:@selector(setDelegate:)])
        {
            [controller setDelegate:self];
        }
    }
}

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
