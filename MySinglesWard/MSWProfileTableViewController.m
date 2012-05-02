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


@interface MSWProfileTableViewController ()

@property (weak, nonatomic) IBOutlet UITableViewCell *TitleCell;
-(void) useDatabase;
-(void)setMemberProfile;
@end

@implementation MSWProfileTableViewController
@synthesize TitleCell;
@synthesize mswDatabase = _mswDatabase;
@synthesize memberName = _memberName;
@synthesize memberPhoto = _memberPhoto;
@synthesize wardName = _wardName;

-(void)setMswDatabase:(UIManagedDocument *)mswDatabase
{
    if(_mswDatabase != mswDatabase)
    {
        _mswDatabase = mswDatabase;
        [self useDatabase];        
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

-(void)useDatabase
{
    if(![[NSFileManager defaultManager] fileExistsAtPath:[self.mswDatabase.fileURL path]])
    {
        //Create the file
        [self.mswDatabase saveToURL:self.mswDatabase.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success){
            
            
        }];
    }
    else if (self.mswDatabase.documentState == UIDocumentStateClosed) {
        //Open the file
        [self.mswDatabase openWithCompletionHandler:^(BOOL success){
            
        }];
    }
    else if(self.mswDatabase.documentState == UIDocumentStateNormal)
    {
        
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.TitleCell.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //Open the database
    if(!self.mswDatabase)
    {
        NSURL *databaseURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        databaseURL = [databaseURL URLByAppendingPathComponent:@"MSW Database"];
        self.mswDatabase = [[UIManagedDocument alloc] initWithFileURL:databaseURL];
    }
    
    //Check to see if the member is in the database, if not, go and get it from the server
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    
    if([pref objectForKey:MEMBERID] && [User userWithID:[pref objectForKey:MEMBERID] inManagedObjectContext:self.mswDatabase.managedObjectContext])
    {
        [self setMemberProfile];
    }
    else 
    {
        //Create the URL for the web request to get all the customers
        NSString *url = [[NSString alloc] initWithFormat:@"%@api/member", MSWRequestURL];
        NSLog(@"MEMBER DATA URL request: %@", url);
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            
            //load Member
            NSDictionary *memberData = [JSONRequest makeWebRequestWithURL:url withJSONData:nil];
            NSLog(@"MEMBER DATA response: %@", memberData);
            
            //Save ward into database
            [Ward wardWithJSON:[memberData objectForKey:@"ward"] inManagedObjectContext:self.mswDatabase.managedObjectContext];
            
            //Save user to coredata and userdefaults
            [self.mswDatabase.managedObjectContext performBlock:^{
                User *user = [User userWithAllMemberData:memberData inManagedObjectContext:self.mswDatabase.managedObjectContext];
                
                [pref setObject:user.memberID forKey:@"memberID"];
                [pref synchronize];
            }];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setMemberProfile];
            });

            [self loadWardList];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
        });
        
        [self.mswDatabase saveToURL:self.mswDatabase.fileURL
                   forSaveOperation:UIDocumentSaveForOverwriting
                  completionHandler:^(BOOL success) {
                      if (!success) NSLog(@"failed to save document %@", self.mswDatabase.localizedName);
                  }];
    }

}

-(void)setMemberProfile
{
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    User *user = [User userWithID:[pref objectForKey:@"memberID"] inManagedObjectContext:self.mswDatabase.managedObjectContext];
    
    self.memberName.text = [NSString stringWithFormat:@"%@ %@", user.prefname, user.lastname];
    
    self.wardName.text = [NSString stringWithFormat:@"%@ %@ Ward", user.ward.location, user.ward.ward];
    
    if(user.photo.photoData)
    {        
        self.memberPhoto.layer.cornerRadius = 5.0;
        self.memberPhoto.layer.masksToBounds = YES;
        
        self.memberPhoto.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.memberPhoto.layer.borderWidth = 1.0;
        [self.memberPhoto setImage:[UIImage imageWithData:user.photo.photoData]];
    }
    else 
    {
        dispatch_queue_t photoQueue = dispatch_queue_create("photoQueue", NULL);
        dispatch_async(photoQueue, ^{       
            NSData *photoData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", MSWPhotoURL,user.photo.filename]]];
        
            [self.mswDatabase.managedObjectContext performBlock:^{
                user.photo.photoData = photoData;  
            }];
            
            //Set Photo
            dispatch_async(dispatch_get_main_queue(), ^{                
                self.memberPhoto.layer.cornerRadius = 5.0;
                self.memberPhoto.layer.masksToBounds = YES;
                
                self.memberPhoto.layer.borderColor = [UIColor lightGrayColor].CGColor;
                self.memberPhoto.layer.borderWidth = 1.0;
                [self.memberPhoto setImage:[UIImage imageWithData:photoData]];
            });
            
        });
        dispatch_release(photoQueue);          
    }      
}

-(void)loadWardList
{
    //Create the URL for the web request to get all the customers
    NSString *url = [[NSString alloc] initWithFormat:@"%@api/ward/list", MSWRequestURL];
    NSLog(@"WARD LIST DATA URL request: %@", url);
    
    
    //load Ward List
    NSDictionary *wardListData = [JSONRequest makeWebRequestWithURL:url withJSONData:nil];
    NSLog(@"WARD LIST DATA response: %@", wardListData);
        
    [self.mswDatabase.managedObjectContext performBlock:^{
        
        for(NSNumber *memberID in [wardListData objectForKey:@"members"])
        {
                if(![User userWithID:memberID inManagedObjectContext:self.mswDatabase.managedObjectContext])
                {
                    dispatch_queue_t requestQueue = dispatch_queue_create("requestQueue", NULL);
                    dispatch_async(requestQueue, ^{ 
                        //Create the URL for the web request to get all the customers
                        NSString *memberURL = [[NSString alloc] initWithFormat:@"%@api/member/get/%@", MSWRequestURL,memberID];
                        NSLog(@"MEMBER DATA URL request: %@", memberURL);
                        
                        NSDictionary *memberData = [JSONRequest makeWebRequestWithURL:memberURL withJSONData:nil];
                        NSLog(@"MEMBER DATA response: %@", memberData);
                        
                        //Save User
                        [self.mswDatabase.managedObjectContext performBlock:^{
                            [User userWithAllMemberData:memberData inManagedObjectContext:self.mswDatabase.managedObjectContext];
                        }];
                    });
                    dispatch_release(requestQueue); 
                }
           
            
            
            
        }
     }];
    /*[self.mswDatabase.managedObjectContext performBlock:^{
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
        
        NSError *error = nil;
        NSArray *members = [self.mswDatabase.managedObjectContext executeFetchRequest:request error:&error];
        
        for(User *user in members)
        {
            if(![[wardListData objectForKey:@"members"] containsObject:user.memberID])
            {
                [self.mswDatabase.managedObjectContext performBlock:^{
                    [self.mswDatabase.managedObjectContext deleteObject:user];
                }];
            }                
        }
    }];*/
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
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    User *user = [User userWithID:[pref objectForKey:@"memberID"] inManagedObjectContext:self.mswDatabase.managedObjectContext];
    
    if([segue.destinationViewController respondsToSelector:@selector(setDatabaseDelegate:)])
    {
        [segue.destinationViewController setDatabaseDelegate:self];
    }
    
    if([segue.destinationViewController respondsToSelector:@selector(setCurrentWard:)])
    {
        [segue.destinationViewController setCurrentWard:user.ward];
    }
}
#pragma mark - Table view data source

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
