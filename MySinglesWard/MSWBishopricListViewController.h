//
//  MSWBishopricListViewController.h
//  MySinglesWard
//
//  Created by Porter Hoskins on 5/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import "MSWProfileTableViewController.h"
#import "Ward.h"

@interface MSWBishopricListViewController : CoreDataTableViewController

@property (nonatomic, strong) Ward *currentWard;
@property (nonatomic, assign) id<MSWDatabaseDelegate> databaseDelegate;

@end
