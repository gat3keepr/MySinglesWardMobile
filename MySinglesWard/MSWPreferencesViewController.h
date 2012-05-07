//
//  MSWPreferencesViewController.h
//  MySinglesWard
//
//  Created by Porter Hoskins on 5/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSWProfileTableViewController.h"

@interface MSWPreferencesViewController : UITableViewController

@property (strong, nonatomic) id<MSWDatabaseDelegate> delegate;

@end
