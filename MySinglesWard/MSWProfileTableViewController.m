//
//  MSWProfileTableViewController.m
//  MySinglesWard
//
//  Created by Porter Hoskins on 4/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MSWProfileTableViewController.h"
#import "JSONRequest.h"
#import "Ward.h"
#import "User+Create.h"
#import "MemberSurvey.h"
#import "Photo+Create.h"
#import <QuartzCore/QuartzCore.h>
#import "MSWWardViewController.h"
#import "MBProgressHUD.h"
#import "MSWPreferencesViewController.h"
#import "MSWPersonalInformationViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "MSWLoginTableViewController.h"

@interface MSWProfileTableViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>

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
    
    //Set background image of table view
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:BACKGROUND_IMAGE]];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated
{
    //Check to see if the member is in the database, if not, go and get it from the server
    
    [super viewWillAppear:animated];
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    
    self.currentUser = [User userWithID:[pref objectForKey:MEMBERID] inManagedObjectContext:self.mswDatabase.managedObjectContext];
    [self setMemberProfile];
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    if([[pref objectForKey:REGISTRATION] boolValue])
    {
        if([[pref objectForKey:REGISTRATION_STEP] isEqualToString:DONE])
        {
            [pref setObject:@"NO" forKey:REGISTRATION];
            [self setMemberProfile];
            return;
        }
        
        //Check to see if the ward is set
        if(self.currentUser.wardID != [NSNumber numberWithInt:NO_WARD])
        {
            [pref setObject:SURVEY forKey:REGISTRATION_STEP];
        }
        
        //Segue to correct view
        if([[pref objectForKey:REGISTRATION_STEP] isEqualToString:WARD])
        {
            [self performSegueWithIdentifier:@"Select Ward" sender:self];
        }
        else if([[pref objectForKey:REGISTRATION_STEP] isEqualToString:SURVEY])
        {
            if([self.currentUser.isBishopric boolValue])
            {
                [self performSegueWithIdentifier:@"Bishopric Data" sender:self];
            }
            else 
            {
                [self performSegueWithIdentifier:@"Member Survey" sender:self];
            }
        }
        
    }
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
    
    self.memberPhoto.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.memberPhoto.layer.borderWidth = 1.0;
    [self.memberPhoto setImage:[UIImage imageWithData:self.currentUser.photo.photoData]];
}

- (IBAction)refreshMember:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        //load Member
        NSDictionary *memberData = [JSONRequest requestForMemberData];
        [User userWithAllMemberData:memberData inManagedObjectContext:self.mswDatabase.managedObjectContext];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setMemberProfile];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });
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
        if(YES)//![User userWithID:memberID inManagedObjectContext:self.backgroundContext])
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
    
    NSError *saveError = nil;
    [self.mswDatabase.managedObjectContext save:&saveError];
    if(saveError) NSLog(@"SAVE ERROR - %@", [saveError localizedDescription]);
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
    if([segue.destinationViewController isKindOfClass:[UITabBarController class]])
    {
        UITabBarController *tabBarController = (UITabBarController *)[segue destinationViewController];
        
        for (id vc in tabBarController.viewControllers) {
            if([vc respondsToSelector:@selector(setDatabaseDelegate:)])
            {
                [vc setDatabaseDelegate:self];
            }
            
            if([vc respondsToSelector:@selector(setCurrentWard:)])
            {
                [vc setCurrentWard:self.currentUser.ward];
            }
        }
    }
    
    if([segue.destinationViewController respondsToSelector:@selector(setDelegate:)])
    {
        [segue.destinationViewController setDelegate:self];
    }
    
    //Set delegate on a controller behind a navigation controller
    if([segue.destinationViewController isKindOfClass:[UINavigationController class]])
    {
        UINavigationController *nav = segue.destinationViewController;

        id controller = nav.topViewController;
        
        if([controller respondsToSelector:@selector(setDelegate:)])
        {
            [controller setDelegate:self];
        }
    }
}

#define MAX_IMAGE_WIDTH 200
#define MAX_IMAGE_HEIGHT 200
- (void)addImageWithSource:(UIImagePickerControllerSourceType)source
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        if ([mediaTypes containsObject:(NSString *)kUTTypeImage]) {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.sourceType = source;
            picker.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeImage];
            picker.allowsEditing = YES;
            
            [self presentModalViewController:picker animated:YES];
        }
    }
}

- (void)dismissImagePicker
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (!image) image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (image) {
        //Save image to server
        [MBProgressHUD showHUDAddedTo:picker.view animated:YES];
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            //Create the URL for the web request to get all the customers
            NSString *url = [[NSString alloc] initWithFormat:@"%@api/member/uploadphoto", MSWRequestURL];
            NSLog(@"PHOTO SAVE DATA URL request: %@", url);
            
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
            
            request.HTTPMethod = @"POST";
            
            /*
             add some header info now
             we always need a boundary when we post a file
             also we need to set the content type
             
             You might want to generate a random boundary.. this is just the same
             
             */
            NSString *boundary = [NSString stringWithString:@"---------------------------14737809831466499882746641449"];
            NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
            [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
            
            /*
             now lets create the body of the post
             */
            NSMutableData *body = [NSMutableData data];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"photofile\"; filename=\"ipodfile.jpg\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithString:@"Content-Type: image/jpeg\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[NSData dataWithData:UIImageJPEGRepresentation(image, 1.0)]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            request.HTTPBody = body;
            
            NSError *errorReturned = nil;
            NSURLResponse *response = [[NSURLResponse alloc] init];
            NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&errorReturned]; 
            
            if(errorReturned)
            {
                //Check to see if there was an error
                NSLog(@"PHOTO REQUEST ERROR: %@",[errorReturned localizedDescription]);
            }
            
            NSError *jsonError = nil;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:returnData options:kNilOptions error:&jsonError];
            
            if(jsonError)
            {
                NSLog(@"PHOTO JSON ERROR: %@", [jsonError localizedDescription]);
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if(json)
                    [Photo photoWithJSON:json inManagedObjectContext:self.mswDatabase.managedObjectContext];
                [self setMemberProfile];
                
                [self dismissImagePicker];
            });
        });
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissImagePicker];
}

#pragma mark - Action Sheet view delegate

- (void)actionSheet:(UIActionSheet *)sender clickedButtonAtIndex:(NSInteger)index;
{
    NSInteger bishopricIndex = 1;
    if(index == sender.firstOtherButtonIndex)
    {
        [self addImageWithSource:UIImagePickerControllerSourceTypeCamera];
    }
    else if(index == bishopricIndex) {
        [self addImageWithSource:UIImagePickerControllerSourceTypePhotoLibrary];
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Set segues to go off of touch so we can control if the user is authorized to view the list
    
    //Handle ward list & bishopric
    if(indexPath.section == 1 && indexPath.row == 0)
    {
        NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
        
        if([[pref objectForKey:MEMBER_STATUS] containsObject:UNAUTHORIZED])
        {
            //Check if the authorization has changed
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                [JSONRequest requestForMemberStatus];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    if([[pref objectForKey:MEMBER_STATUS] containsObject:UNAUTHORIZED])
                    {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Waiting For Approval" message:@"Please wait until a member of the bishopric has approved your ward membership." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        
                        [alert show];
                    }
                    else {
                        [self performSegueWithIdentifier:@"Ward Information" sender:self];
                    }
                });
            });
        }
        else {
            [self performSegueWithIdentifier:@"Ward Information" sender:self];
        }
        
    }
    
    //Handle survey
    if(indexPath.section == 2 && indexPath.row == 0)
    {
        if([self.currentUser.isBishopric boolValue])
        {
            [self performSegueWithIdentifier:@"Bishopric Data" sender:self];
        }
        else 
        {
            [self performSegueWithIdentifier:@"Member Survey" sender:self];
        }
        
    }
    
    //Handle photo upload
    if(indexPath.section == 2 && indexPath.row == 1)
    {
        UIActionSheet *registationSheet = [[UIActionSheet alloc] initWithTitle:@"Upload Photo Options" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Photo Library", nil];
        
        [registationSheet showInView:self.view];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
