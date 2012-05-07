//
//  Calling.h
//  MySinglesWard
//
//  Created by Porter Hoskins on 5/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface Calling : NSManagedObject

@property (nonatomic, retain) NSNumber * callingID;
@property (nonatomic, retain) NSNumber * memberID;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) User *member;

@end
