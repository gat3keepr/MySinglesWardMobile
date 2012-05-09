//
//  MSWLoginTableViewController.m
//  MySinglesWard
//
//  Created by Porter Hoskins on 4/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MSWLoginTableViewController.h"
#import "MSWRequest.h"
#import "JSONRequest.h"
#import "MSWProfileTableViewController.h"
#import "Ward+Create.h"
#import "MBProgressHUD.h"
#import "User+Create.h"

@interface MSWLoginTableViewController ()
@property (weak, nonatomic) IBOutlet UILabel *downloadLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *downloadProgress;
@property (weak, nonatomic) IBOutlet UITableViewCell *logoCell1;
@property (weak, nonatomic) IBOutlet UITableViewCell *logoCell2;
@property (weak, nonatomic) IBOutlet UITableViewCell *logoCell3;
@property (weak, nonatomic) IBOutlet UITableViewCell *logoCell4;
@property (weak, nonatomic) IBOutlet UITableViewCell *logoCell5;
@property (weak, nonatomic) IBOutlet UITableViewCell *logoCell6;
@property (strong, nonatomic) NSTimer *timer;
@property (nonatomic) int usersCompleted;
@property (nonatomic) int usersToDownload;
@property (strong, nonatomic) NSManagedObjectContext *backgroundMOC;
@property (weak, nonatomic) NSNotificationCenter *center;

-(void)contextChanged:(NSNotification *)notification;

@end

@implementation MSWLoginTableViewController
@synthesize mswDatabase = _mswDatabase;
@synthesize downloadLabel;
@synthesize downloadProgress;
@synthesize logoCell1;
@synthesize logoCell2;
@synthesize logoCell3;
@synthesize logoCell4;
@synthesize logoCell5;
@synthesize logoCell6;
@synthesize tableView;
@synthesize emailAddressField;
@synthesize passwordField;
@synthesize timer = _timer;
@synthesize usersCompleted = _usersCompleted;
@synthesize usersToDownload = _usersToDownload;
@synthesize backgroundMOC = _backgroundMOC;
@synthesize currentUser = _currentUser;
@synthesize center = _center;
@synthesize cookies = _cookies;

#define NEEDS_NOTHING @"NEEDS_NOTHING"
#define NEEDS_PHOTO @"NEEDS_PHOTO"
#define NEEDS_SURVEY @"NEEDS_SURVEY"
#define UNAUTHORIZED @"UNAUTHORIZED"
#define DATA_LOADED @"DATA_LOADED"

-(NSNotificationCenter *)center
{
    if(!_center)
    {
        _center = [NSNotificationCenter defaultCenter];
    }
    
    return _center;
}

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

- (IBAction)tapOut:(id)sender {
    [self.emailAddressField resignFirstResponder];
    [self.passwordField resignFirstResponder];
}

- (IBAction)login:(UIButton *)sender {
    
    //Create Login JSON object
    NSDictionary *login = [[NSDictionary alloc] initWithObjectsAndKeys:self.emailAddressField.text, @"email", self.passwordField.text,@"password", nil];    
    
    NSError *error = nil;

    NSLog(@"Login JSON object: %@", login);
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:login options:NSJSONWritingPrettyPrinted error:&error];
    NSString* requestDataLengthString = [[NSString alloc] initWithFormat:@"%d", [jsonData length]];
    
    //Create the URL for the web request to get all the customers
    NSString *url = [[NSString alloc] initWithFormat:@"%@api/authentication/login", MSWRequestURL];
    NSLog(@"LOG IN URL request: %@", url);
    
    dispatch_queue_t loginQueue = dispatch_queue_create("loginQueue", NULL);
    dispatch_async(loginQueue, ^{
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[[NSURL alloc] initWithString:url]];
        
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:jsonData];
        [request setHTTPShouldHandleCookies:YES];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:requestDataLengthString forHTTPHeaderField:@"Content-Length"];
        
        NSError *errorReturned = nil;
        
        NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] init];
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&errorReturned];   
        
        //Save the cookies from the request
        self.cookies = [NSHTTPCookie cookiesWithResponseHeaderFields:[response allHeaderFields] forURL:[NSURL URLWithString:@"http://temp"]];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookies:self.cookies forURL:[NSURL URLWithString:@"http://www.mysinglesward.com"] mainDocumentURL:nil];
        
        NSURL *cookiesURL = [[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject];
        cookiesURL = [cookiesURL URLByAppendingPathComponent:@"MSW Cookies"];
    
        [self.cookies writeToFile:cookiesURL.path atomically:YES];
        
        //Read the contents of the response
        if(error)
        {
            NSLog(@"LOG IN ERROR: %@", errorReturned);
        }
        else 
        {            
            NSError *jsonError = nil;
            @try {
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
                
                NSLog(@"%@", json);
                
                NSArray *loggedInStatus = [json objectForKey:@"authentication"];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if([loggedInStatus containsObject:NEEDS_NOTHING])
                    {
                        [self loadWardInformation];
                    }
                    else if([loggedInStatus containsObject:NEEDS_PHOTO])
                    {
                        
                    }
                    else if([loggedInStatus containsObject:NEEDS_SURVEY])
                    {
                        
                    }
                    else
                    {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid login" message:@"The username/password was incorrect." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [alert show];                
                    }
                });
            }
            @catch (NSException *exception) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Internet Connection" message:@"Please connect to the internet." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show]; 
            }
        }
        
    });
    dispatch_release(loginQueue);   
}

-(void)updateDownloadBar:(NSTimer *)timer
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if(self.usersToDownload != 0.0) 
            self.downloadProgress.progress = (float)self.usersCompleted/self.usersToDownload;
    });
}

-(void)loadWardInformation
{
    
    //Check to see if the member is in the database, if not, go and get it from the server
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    
    if([[pref objectForKey:DATA_LOADED] boolValue] && [[pref objectForKey:LOGGED_IN] boolValue])
    {
        self.currentUser = [User userWithID:[pref objectForKey:MEMBERID] inManagedObjectContext:self.mswDatabase.managedObjectContext];
        [self performSegueWithIdentifier:@"LoggedIn" sender:self];
        return;
    }
    else 
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];

        //Start the data loading of the ward list
        NSString *url = [[NSString alloc] initWithFormat:@"%@api/member", MSWRequestURL];
        NSLog(@"MEMBER DATA URL request: %@", url);
        
        self.downloadProgress.progress = 0.0;
        [UIView animateWithDuration:.5
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{ 
                             self.downloadLabel.alpha = 1.0;
                             self.downloadProgress.alpha = 1.0;
                         }
                         completion:nil];
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateDownloadBar:) userInfo:nil repeats:YES];
        
        dispatch_queue_t requestQueue = dispatch_queue_create("requestQueue", NULL);
        dispatch_async(requestQueue, ^{
            self.backgroundMOC = [[NSManagedObjectContext alloc] init];
            [self.backgroundMOC setPersistentStoreCoordinator:[self.mswDatabase.managedObjectContext persistentStoreCoordinator]];
            
            //load Member
            NSDictionary *memberData = [JSONRequest makeWebRequestWithURL:url withJSONData:nil];
            NSLog(@"MEMBER DATA response: %@", memberData);
            
            //Save user to coredata and userdefaults
            [Ward wardWithJSON:[memberData objectForKey:@"ward"] inManagedObjectContext:self.backgroundMOC];
            self.currentUser = [User userWithAllMemberData:memberData inManagedObjectContext:self.backgroundMOC];
            
            //Set the user that is logged in
            [pref setObject:self.currentUser.memberID forKey:@"memberID"];
            
            //Create the URL for the web request to get all the ward members
            NSString *url = [[NSString alloc] initWithFormat:@"%@api/ward/list", MSWRequestURL];
            NSLog(@"WARD LIST DATA URL request: %@", url);
            
            //load Ward List
            NSDictionary *wardListData = [JSONRequest makeWebRequestWithURL:url withJSONData:nil];
            NSLog(@"WARD LIST DATA response: %@", wardListData);
            
            //load bishopric
            NSString *bishopricurl = [[NSString alloc] initWithFormat:@"%@api/ward/bishopric", MSWRequestURL];
            NSLog(@"BISHOPRIC LIST DATA URL request: %@", bishopricurl);
            
            //load Ward List
            NSDictionary *bishopricData = [JSONRequest makeWebRequestWithURL:bishopricurl withJSONData:nil];
            NSLog(@"BISHOPRIC LIST DATA response: %@", bishopricData);
            
            self.usersToDownload = [[wardListData objectForKey:@"members"] count] + [bishopricData count];
            self.usersCompleted = 0;
            
            NSArray* members = [[wardListData objectForKey:@"members"] copy];
            
            //Save members
            for(NSDictionary *member in members)
            {
                //Save User
                [User userWithAllMemberData:[member copy] inManagedObjectContext:self.backgroundMOC];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.usersCompleted = self.usersCompleted + 1;
                });
                
            }
            
            //save bishopric
            for(NSDictionary *bishopricmember in bishopricData)
            {
                NSLog(@"BISHOPRIC DATA response: %@", bishopricmember); 
                
                [User userWithAllMemberData:bishopricmember inManagedObjectContext:self.backgroundMOC];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.usersCompleted = self.usersCompleted + 1;
                });
            }
            
            //Save background context
            NSError *error = nil;
            [self.backgroundMOC save:&error];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [UIView animateWithDuration:.2
                                      delay:0
                                    options:UIViewAnimationOptionBeginFromCurrentState
                                 animations:^{ 
                                     self.downloadLabel.alpha = 0.0;
                                     self.downloadProgress.alpha = 0.0;
                                 }
                                 completion:nil];
                [pref setObject:@"YES" forKey:DATA_LOADED];
                [pref setObject:@"YES" forKey:LOGGED_IN];
                [pref synchronize];
                
                //reset the progress bar
                [self.timer invalidate];
                self.usersCompleted = 0;
                self.usersToDownload = 0;
                
                [self performSegueWithIdentifier:@"LoggedIn" sender:self];
            });
        });
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[UIControl class]]) {
        // we touched a button, slider, or other UIControl
        return NO; // ignore the touch
    }
    return YES; // handle the touch
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UINavigationController *nav = segue.destinationViewController;
    MSWProfileTableViewController *controller = (MSWProfileTableViewController *)nav.topViewController;
    
    if([controller respondsToSelector:@selector(setMswDatabase:)])
    {
        [controller setMswDatabase:self.mswDatabase];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.logoCell1.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    self.logoCell2.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    self.logoCell3.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    self.logoCell4.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    self.logoCell5.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    self.logoCell6.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iphone-background.png"]];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [self setEmailAddressField:nil];
    [self setPasswordField:nil];
    [self setLogoCell1:nil];
    [self setLogoCell2:nil];
    [self setLogoCell3:nil];
    [self setLogoCell4:nil];
    [self setLogoCell5:nil];
    [self setLogoCell6:nil];
    [self setTableView:nil];
    [self setDownloadProgress:nil];
    [self setDownloadLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)contextChanged:(NSNotification *)notification
{
    [self.mswDatabase.managedObjectContext mergeChangesFromContextDidSaveNotification:notification]; 
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
    
    //Open the cookies file
    if(!self.cookies)
    {
        NSURL *cookiesURL = [[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject];
        cookiesURL = [cookiesURL URLByAppendingPathComponent:@"MSW Cookies"];
        
        self.cookies = [[NSArray alloc] initWithContentsOfFile:cookiesURL.path];
    }
    
    //Listen For changes to be made to the context after upload
    [self.center addObserver:self
                    selector:@selector(contextChanged:)
                        name:NSManagedObjectContextDidSaveNotification
                      object:self.backgroundMOC];

}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.center removeObserver:self
                           name:NSManagedObjectContextDidSaveNotification
                         object:self.backgroundMOC];
    
    [super viewWillDisappear:animated];
}

-(void)viewDidAppear:(BOOL)animated
{
    
    //If the user is logged in then segue to the profile view and load the cookies
    if([[[NSUserDefaults standardUserDefaults] objectForKey:LOGGED_IN] boolValue])
    {
        NSURL *cookiesURL = [[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject];
        cookiesURL = [cookiesURL URLByAppendingPathComponent:@"MSW Cookies"];
        
        self.cookies = [[NSArray alloc] initWithContentsOfFile:cookiesURL.path];
        
        [self performSegueWithIdentifier:@"LoggedIn" sender:self];
    }
    
    [super viewDidAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField 
{
    if ([textField.text isEqualToString:@""]) {
        return NO;
    }
    
    if(textField == emailAddressField)
        [passwordField becomeFirstResponder];
    else
        [textField resignFirstResponder];
    return YES;
}

- (IBAction)Register:(id)sender {
    UIActionSheet *registationSheet = [[UIActionSheet alloc] initWithTitle:@"Registration Options" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Member Registration", @"Bishopric Registration", nil];
    
    [registationSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)sender clickedButtonAtIndex:(NSInteger)index;
{
    NSInteger bishopricIndex = 1;
    if(index == sender.firstOtherButtonIndex)
    {
        [self performSegueWithIdentifier:@"Member Registration" sender:self];
    }
    else if(index == bishopricIndex) {
        [self performSegueWithIdentifier:@"Bishopric Registration" sender:self];
    }
}

@end
