//
//  MSWRegistrationViewController.h
//  MySinglesWard
//
//  Created by Porter Hoskins on 4/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSWLoginTableViewController.h"

@interface MSWRegistrationViewController : UITableViewController

@property (weak, nonatomic) id<MSWLoginDelegate> delegate;

-(BOOL) NSStringIsValidEmail:(NSString *)checkString;

@end
