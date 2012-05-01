//
//  Photo+Create.h
//  MySinglesWard
//
//  Created by Porter Hoskins on 4/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Photo.h"

@interface Photo (Create)

+(Photo *) photoWithJSON:(NSDictionary *) data inManagedObjectContext:(NSManagedObjectContext *)context;

@end
