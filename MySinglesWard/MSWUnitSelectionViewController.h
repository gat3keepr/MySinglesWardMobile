//
//  MSWUnitSelectionViewController.h
//  MySinglesWard
//
//  Created by Porter Hoskins on 5/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSWProfileTableViewController.h"

@protocol MSWChangeWardProtocol <NSObject>

-(void)setLocationString:(NSString *)location;
-(void)setStakeString:(NSString *)stake;
-(void)setWardString:(NSString *)ward;
-(void)setWardID:(NSNumber *)wardID;
-(NSString *)location;
-(NSString *)stake;

@end

@interface MSWUnitSelectionViewController : UITableViewController <MSWChangeWardProtocol, UITextFieldDelegate>

@property (strong, nonatomic) id<MSWDatabaseDelegate> delegate;
@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) NSString *stake;
@property (strong, nonatomic) NSString *ward;
@property (strong, nonatomic) NSNumber *wardID;
@property (weak, nonatomic) IBOutlet UITableViewCell *downloadingCell;
@property (weak, nonatomic) IBOutlet UIProgressView *downloadBar;
@property (weak, nonatomic) IBOutlet UILabel *downloadLabel;
@property (weak, nonatomic) IBOutlet UITableViewCell *wardPasswordCell;

-(void)updateDownloadBar:(NSTimer *)timer;

@end
