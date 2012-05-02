//
//  MSWMemberViewController.m
//  MySinglesWard
//
//  Created by Porter Hoskins on 5/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MSWMemberViewController.h"
#import "Photo.h"
#import "User.h"
#import <QuartzCore/QuartzCore.h>
#import <MessageUI/MessageUI.h>

@interface MSWMemberViewController ()
@property (weak, nonatomic) IBOutlet UITableViewCell *buttonCell;

@end

@implementation MSWMemberViewController
@synthesize buttonCell;
@synthesize memberPhoto;
@synthesize memberName;
@synthesize memberPhone;
@synthesize memberEmail;
@synthesize memberResidence;
@synthesize titleCell;
@synthesize user = _user;

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
    
    self.titleCell.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    self.buttonCell.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [self setMemberPhoto:nil];
    [self setMemberName:nil];
    [self setMemberPhone:nil];
    [self setMemberEmail:nil];
    [self setMemberResidence:nil];
    [self setTitleCell:nil];
    [self setButtonCell:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.memberPhoto setImage:[UIImage imageWithData:self.user.photo.photoData]];
    self.memberPhoto.layer.cornerRadius = 5.0;
    self.memberPhoto.layer.masksToBounds = YES;
    
    self.memberPhoto.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.memberPhoto.layer.borderWidth = 1.0;
    
    if([self.user.isBishopric boolValue])
        self.memberName.text = [NSString stringWithFormat:@"%@", self.user.prefname];
    
    self.memberName.text = [NSString stringWithFormat:@"%@ %@", self.user.prefname, self.user.lastname];
    self.memberPhone.text = self.user.cellphone;
    self.memberEmail.text = self.user.email;
    self.memberResidence.text = self.user.residence;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Handle Phone Call
    if(indexPath.section == 1 && indexPath.row == 0)
    {
        
        NSString *phoneNumber = [@"tel://" stringByAppendingString:self.memberPhone.text];
        NSString *cleanedString = [[phoneNumber componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+()"] invertedSet]] componentsJoinedByString:@""];
        NSString *escapedPhoneNumber = [cleanedString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *telURL = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", escapedPhoneNumber]];
        [[UIApplication sharedApplication] openURL:telURL];
    }
    
    //Handle Email
    if(indexPath.section == 1 && indexPath.row == 1)
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        
        mailer.mailComposeDelegate = self;
        
        [mailer setSubject:@""];
        
        NSArray *toRecipients = [NSArray arrayWithObjects:self.memberEmail.text, nil];
        [mailer setToRecipients:toRecipients];
        [mailer setMessageBody:@"" isHTML:NO];
        
        [self presentModalViewController:mailer animated:YES];
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            break;
        default:
            NSLog(@"Mail not sent.");
            break;
    }
    
    // Remove the mail view
    [self dismissModalViewControllerAnimated:YES];
}
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


@end
