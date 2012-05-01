//
//  MSWWardViewController.h
//  MySinglesWard
//
//  Created by Porter Hoskins on 5/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import "Ward+Create.h"
#import "MSWProfileTableViewController.h"

@interface MSWWardViewController : CoreDataTableViewController

@property (nonatomic, strong) Ward *currentWard;
@property (nonatomic, assign) id<MSWDatabaseDelegate> databaseDelegate;

@end
