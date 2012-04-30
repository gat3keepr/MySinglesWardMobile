//
//  MSWUser+Create.h
//  MySinglesWard
//
//  Created by Porter Hoskins on 4/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MSWUser.h"

@interface MSWUser (Create)

+(MSWUser *) createWithJSON:(NSDictionary *)data;

@end
