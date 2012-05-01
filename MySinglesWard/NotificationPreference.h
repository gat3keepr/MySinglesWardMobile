//
//  NotificationPreference.h
//  MySinglesWard
//
//  Created by Porter Hoskins on 4/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface NotificationPreference : NSManagedObject

@property (nonatomic, retain) NSNumber * memberID;
@property (nonatomic, retain) NSNumber * activities;
@property (nonatomic, retain) NSString * carrier;
@property (nonatomic, retain) NSNumber * elders;
@property (nonatomic, retain) NSNumber * email;
@property (nonatomic, retain) NSNumber * fhe;
@property (nonatomic, retain) NSNumber * reliefsociety;
@property (nonatomic, retain) NSNumber * stake;
@property (nonatomic, retain) NSNumber * txt;
@property (nonatomic, retain) NSNumber * ward;
@property (nonatomic, retain) User *member;

@end
