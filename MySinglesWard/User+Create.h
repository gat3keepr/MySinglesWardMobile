//
//  User+Create.h
//  MySinglesWard
//
//  Created by Porter Hoskins on 4/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "User.h"
#define MEMBERID @"memberID"

@interface User (Create)

+(User *) userWithJSON:(NSDictionary *)data inManagedObjectContext:(NSManagedObjectContext *)context;
+(User *) userWithID:(NSNumber *)memberID inManagedObjectContext:(NSManagedObjectContext *)context;
+(User *) userWithAllMemberData:(NSDictionary *)memberData inManagedObjectContext:(NSManagedObjectContext *)context;

@property (nonatomic, strong) NSString* userLastNameInitial;
@end
