//
//  BishopricData+Create.h
//  MySinglesWard
//
//  Created by Porter Hoskins on 5/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BishopricData.h"

@interface BishopricData (Create)

#define MEMBERID @"memberID"

+(BishopricData *) dataWithJSON:(NSDictionary *)data inManagedObjectContext:(NSManagedObjectContext *)context;

@end
