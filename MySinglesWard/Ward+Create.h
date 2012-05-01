//
//  Ward+Create.h
//  MySinglesWard
//
//  Created by Porter Hoskins on 4/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Ward.h"

@interface Ward (Create)

+(Ward *) wardWithJSON:(NSDictionary *) data inManagedObjectContext:(NSManagedObjectContext *)context;
+(Ward *) wardWithID:(NSNumber *)wardID inManagedObjectContext:(NSManagedObjectContext *)context;

@end
