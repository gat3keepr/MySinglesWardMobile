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
#import "Calling.h"
#import "JSONRequest.h"
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
@synthesize memberCalling;
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
    
    //Set background image of table view
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:BACKGROUND_IMAGE]];

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
    [self setMemberCalling:nil];
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
    
    self.memberPhoto.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.memberPhoto.layer.borderWidth = 1.0;
    
    if([self.user.isBishopric boolValue])
        self.memberName.text = [NSString stringWithFormat:@"%@", self.user.prefname];
    else
        self.memberName.text = [NSString stringWithFormat:@"%@ %@", self.user.prefname, self.user.lastname];
    self.memberPhone.text = self.user.cellphone;
    self.memberEmail.text = self.user.email;
    self.memberResidence.text = self.user.residence;
    self.memberCalling.text = self.user.calling.title;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Handle Phone Call
    if(indexPath.section == 1 && indexPath.row == 0)
    {
        
        NSString *phoneNumber = [@"tel://" stringByAppendingString:self.memberPhone.text];
        NSString *cleanedString = [[phoneNumber componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+()"] invertedSet]] componentsJoinedByString:@""];
        NSString *escapedPhoneNumber = [cleanedString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *telURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", escapedPhoneNumber]];
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
    if (sectionTitle == nil) {
        return nil;
    }
    
    // Create label with section title
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(20, 6, 300, 30);
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    label.shadowColor = [UIColor lightTextColor];
    label.shadowOffset = CGSizeMake(0.0, 1.0);
    label.font = [UIFont boldSystemFontOfSize:16];
    label.text = sectionTitle;
    
    // Create header view and add label as a subview
    
    // you could also just return the label (instead of making a new view and adding the label as subview. With the view you have more flexibility to make a background color or different paddings
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 40)];
    
    [view addSubview:label];
    
    return view;
}

@end
