//
//  MSWProfileTableViewController.h
//  MySinglesWard
//
//  Created by Porter Hoskins on 4/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MSWDatabaseDelegate <NSObject>

-(UIManagedDocument *)getMSWDatabase;
-(void)loadWardList;

@end

@interface MSWProfileTableViewController : UITableViewController <MSWDatabaseDelegate>

@property(nonatomic, strong) UIManagedDocument *mswDatabase;
@property (weak, nonatomic) IBOutlet UILabel *memberName;
@property (weak, nonatomic) IBOutlet UIImageView *memberPhoto;
@property (weak, nonatomic) IBOutlet UILabel *wardName;

@end
