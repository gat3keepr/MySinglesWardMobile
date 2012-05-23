//
//  MSWUnitSelectionViewController.m
//  MySinglesWard
//
//  Created by Porter Hoskins on 5/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MSWUnitSelectionViewController.h"
#import "MSWLocationSelectViewController.h"
#import "MSWProfileTableViewController.h"
#import "MSWLoginTableViewController.h"
#import "JSONRequest.h"
#import "User+Create.h"
#import "MBProgressHUD.h"
#import "Ward+Create.h"

@interface MSWUnitSelectionViewController ()
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *stakeLabel;
@property (weak, nonatomic) IBOutlet UILabel *wardLabel;
@property (weak, nonatomic) IBOutlet UITableViewCell *stakeCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *wardCell;
@property (weak, nonatomic) IBOutlet UITextField *wardPasswordField;
@property (nonatomic) int usersToDownload;
@property (nonatomic) int usersCompleted;
@property (strong, nonatomic) NSManagedObjectContext *backgroundMOC;
@property (strong, nonatomic) NSTimer *timer;
@end

@implementation MSWUnitSelectionViewController
@synthesize locationLabel = _locationLabel;
@synthesize stakeLabel = _stakeLabel;
@synthesize wardLabel = _wardLabel;
@synthesize stakeCell = _stakeCell;
@synthesize wardCell = _wardCell;
@synthesize wardPasswordField = _wardPasswordField;
@synthesize delegate = _delegate;
@synthesize location = _location;
@synthesize stake = _stake;
@synthesize ward = _ward;
@synthesize wardID = _wardID;
@synthesize downloadingCell = _downloadingCell;
@synthesize downloadBar = _downloadBar;
@synthesize downloadLabel = _downloadLabel;
@synthesize wardPasswordCell = _wardPasswordCell;
@synthesize usersToDownload = _usersToDownload;
@synthesize backgroundMOC = _backgroundMOC;
@synthesize usersCompleted = _usersCompleted;
@synthesize timer = _timer;

-(void)setLocationString:(NSString *)location
{
    self.locationLabel.text = self.location = location;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    self.stakeCell.userInteractionEnabled = YES;
    self.wardCell.userInteractionEnabled = NO;
    
    self.stakeLabel.text = self.stake = @"Select Stake";
    self.wardLabel.text = self.ward = @"";
}

-(void)setStakeString:(NSString *)stake   
{
    self.stakeLabel.text = self.stake = stake;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    self.wardCell.userInteractionEnabled = YES;
    self.wardLabel.text = self.ward = @"Select Ward";
    
}

-(void)setWardString:(NSString *)ward
{
    self.wardLabel.text = self.ward = ward;
    self.navigationItem.rightBarButtonItem.enabled = YES;
    [self.tableView reloadData];
}

-(void)setWardID:(NSNumber *)wardID
{
    _wardID = wardID;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.destinationViewController respondsToSelector:@selector(setUnitDelegate:)])
    {
        [segue.destinationViewController setUnitDelegate:self];
    }
    
    if([segue.destinationViewController respondsToSelector:@selector(setDelegate:)])
    {
        [segue.destinationViewController setDelegate:self];
    }
}

- (IBAction)cancelWardChange:(id)sender {
    [self.presentingViewController dismissModalViewControllerAnimated:YES];
}

-(void)updateDownloadBar:(NSTimer *)timer
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if(self.usersToDownload != 0.0) 
            self.downloadBar.progress = (float)self.usersCompleted/self.usersToDownload;
    });
}

- (IBAction)joinWardSelected:(id)sender {
    
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    [pref setObject:@"NO" forKey:DATA_LOADED];
    [pref synchronize];
    
    //Check if the user is a bishopric user
    if([self.wardPasswordField.text isEqualToString:@""] && [[pref objectForKey:ISBISHOPRIC] boolValue])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ward Password Required" message:@"Please enter a ward password." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        self.backgroundMOC = [[NSManagedObjectContext alloc] init];
        [self.backgroundMOC setPersistentStoreCoordinator:[[self.delegate getMSWDatabase].managedObjectContext persistentStoreCoordinator]];
        
        //Create the URL for the web request to get all the customers
        NSString *url = [[NSString alloc] initWithFormat:@"%@api/member/changeward", MSWRequestURL];
        NSLog(@"UNIT CHANGE URL request: %@", url);
        
        NSError *error = nil;
        NSDictionary *newWardData = [JSONRequest makeWebRequestWithURL:url withJSONData:[NSJSONSerialization dataWithJSONObject:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:self.wardID, self.wardPasswordField.text, nil] forKeys:[NSArray arrayWithObjects:@"wardID", @"wardPassword", nil]] options:NSJSONWritingPrettyPrinted error:&error]];
        
        if(!newWardData)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.presentingViewController dismissModalViewControllerAnimated:YES];
                [MBProgressHUD hideHUDForView:self.view animated:NO];
            });
            return;
        }
        
        User *currentUser = [User userWithID:[pref objectForKey:MEMBERID] inManagedObjectContext:self.backgroundMOC];
        Ward *ward = currentUser.ward;
        currentUser.ward = nil;
        [self.backgroundMOC deleteObject:ward];
        
        currentUser.ward = [Ward wardWithJSON:newWardData inManagedObjectContext:self.backgroundMOC];
        
        //Load new ward info
        dispatch_async(dispatch_get_main_queue(), ^{
            self.downloadBar.progress = 0.0;
            [UIView animateWithDuration:.5
                                  delay:0
                                options:UIViewAnimationOptionBeginFromCurrentState
                             animations:^{ 
                                 self.downloadLabel.alpha = 1.0;
                                 self.downloadBar.alpha = 1.0;
                             }
                             completion:nil];
            
            self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateDownloadBar:) userInfo:nil repeats:YES];
        });
        //load Member
        NSDictionary *memberData = [JSONRequest requestForMemberData];
        
        //Save user to coredata and userdefaults
        [User userWithAllMemberData:memberData inManagedObjectContext:self.backgroundMOC];
        
        //load Ward List
        NSDictionary *wardListData = [JSONRequest requestForWardListData];
        
        //load bishopric
        NSDictionary *bishopricData = [JSONRequest requestForBishopricData];
        
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
        NSError *saveError = nil;
        [self.backgroundMOC save:&saveError];
        if(saveError) NSLog(@"SAVE ERROR ON BACKGROUND CONTEXT: %@", [saveError localizedDescription]);
        
        //Set the member status
        [JSONRequest requestForMemberStatus];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [UIView animateWithDuration:.2
                                  delay:0
                                options:UIViewAnimationOptionBeginFromCurrentState
                             animations:^{ 
                                 self.downloadLabel.alpha = 0.0;
                                 self.downloadBar.alpha = 0.0;
                             }
                             completion:nil];
            [pref setObject:@"YES" forKey:DATA_LOADED];
            
            //reset the progress bar
            [self.timer invalidate];
            self.usersCompleted = 0;
            self.usersToDownload = 0;
            
            //Handle registration response
            if([[pref objectForKey:REGISTRATION] boolValue])
            {
                [pref setObject:SURVEY forKey:REGISTRATION_STEP];
            }
            
            [pref synchronize];
            
            [self.presentingViewController dismissModalViewControllerAnimated:YES];
            [MBProgressHUD hideHUDForView:self.view animated:NO];
        });
    });
}

-(void)contextChanged:(NSNotification *)notification
{
    [[self.delegate getMSWDatabase].managedObjectContext mergeChangesFromContextDidSaveNotification:notification];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated 
{
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}

-(void)viewWillAppear:(BOOL)animated    
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                    selector:@selector(contextChanged:)
                        name:NSManagedObjectContextDidSaveNotification
                      object:self.backgroundMOC];
    
    //Handle registration response
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    if([[pref objectForKey:REGISTRATION] boolValue])
    {
        self.navigationItem.leftBarButtonItem = nil;
    }
    
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                           name:NSManagedObjectContextDidSaveNotification
                         object:self.backgroundMOC];
    
    [super viewWillDisappear:animated];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField 
{
    [textField resignFirstResponder];
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.downloadingCell.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    
    //Set background image of table view
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:BACKGROUND_IMAGE]];
    
    //Change state off app
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    if([[pref objectForKey:ISBISHOPRIC] boolValue])
    {
        self.wardPasswordCell.hidden = NO;
    }

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [self setLocationLabel:nil];
    [self setStakeLabel:nil];
    [self setWardLabel:nil];
    [self setStakeCell:nil];
    [self setWardCell:nil];
    [self setDownloadingCell:nil];
    [self setDownloadBar:nil];
    [self setDownloadLabel:nil];
    [self setWardPasswordCell:nil];
    [self setWardPasswordField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
