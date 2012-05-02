//
//  Calling+Create.h
//  MySinglesWard
//
//  Created by Porter Hoskins on 5/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Calling.h"

@interface Calling (Create)

+(Calling *) callingWithJSON:(NSDictionary *)data inManagedObjectContext:(NSManagedObjectContext *)context;


@end
