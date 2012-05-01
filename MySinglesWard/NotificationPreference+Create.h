//
//  NotificationPreference+Create.h
//  MySinglesWard
//
//  Created by Porter Hoskins on 4/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NotificationPreference.h"

@interface NotificationPreference (Create)

+(NotificationPreference *) notificationPreferenceWithJSON:(NSDictionary *) data inManagedObjectContext:(NSManagedObjectContext *)context;
+(NotificationPreference *) notificationPreferenceWithID:(NSNumber *)memberID inManagedObjectContext:(NSManagedObjectContext *)context;

@end
