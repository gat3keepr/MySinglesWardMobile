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

@interface MSWProfileTableViewController ()

@property (weak, nonatomic) IBOutlet UITableViewCell *TitleCell;
-(void) useDatabase;

@end

@implementation MSWProfileTableViewController
@synthesize TitleCell;
@synthesize mswDatabase = _mswDatabase;

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
    }
    else if (self.mswDatabase.documentState == UIDocumentStateClosed) {
        //Open the file
    }
    else if(self.mswDatabase.documentState == UIDocumentStateNormal)
    {
        
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.TitleCell.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    
    //Get the information about the member from the server
    //Create the URL for the web request to get all the customers
    NSString *url = [[NSString alloc] initWithFormat:@"%@api/member", MSWRequestURL];
    NSLog(@"MEMBER DATA URL request: %@", url);
    
    dispatch_queue_t memberQueue = dispatch_queue_create("memberQueue", NULL);
    dispatch_async(memberQueue, ^{
        NSDictionary *memberData = [JSONRequest makeWebRequestWithURL:url withJSONData:nil];
        NSLog(@"MEMBER DATA response: %@", memberData);        
    });
    
    dispatch_release(memberQueue);

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [self setTitleCell:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
