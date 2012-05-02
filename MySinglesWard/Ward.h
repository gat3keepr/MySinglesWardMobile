//
//  Ward.h
//  MySinglesWard
//
//  Created by Porter Hoskins on 5/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface Ward : NSManagedObject

@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSString * stake;
@property (nonatomic, retain) NSNumber * stakeID;
@property (nonatomic, retain) NSString * ward;
@property (nonatomic, retain) NSNumber * wardID;
@property (nonatomic, retain) NSSet *members;
@end

@interface Ward (CoreDataGeneratedAccessors)

- (void)addMembersObject:(User *)value;
- (void)removeMembersObject:(User *)value;
- (void)addMembers:(NSSet *)values;
- (void)removeMembers:(NSSet *)values;

@end
