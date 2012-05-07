//
//  Calling+Create.m
//  MySinglesWard
//
//  Created by Porter Hoskins on 5/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Calling+Create.h"
#import "User+Create.h"

@implementation Calling (Create)

#define CALLING @"Calling"

+(Calling *) callingWithJSON:(NSDictionary *)data inManagedObjectContext:(NSManagedObjectContext *)context
{
    Calling *cData = nil;
    
    //Get ID out of data
    NSNumber *memberID = [data objectForKey:@"MemberID"];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:CALLING];
    request.predicate = [NSPredicate predicateWithFormat:@"memberID = %@", memberID];
    
    NSError *error = nil;
    NSArray *member = [context executeFetchRequest:request error:&error];
    
    if(!member || ([member count] > 1))
    {
        //That should not happen
    }
    else if(![member count])
    {
        cData = [NSEntityDescription insertNewObjectForEntityForName:CALLING inManagedObjectContext:context];
        
        cData.memberID = [data objectForKey:@"MemberID"];
        cData.callingID = [data objectForKey:@"CallingID"];
        
        if([[data objectForKey:@"Title"] isKindOfClass:[NSNull class]])
            cData.title = @"Not Available";
        else
            cData.title = [data objectForKey:@"Title"];
        
        cData.member = [User userWithID:cData.memberID inManagedObjectContext:context];
    }
    else {
        cData = [member lastObject];
    }
    
    return cData;
}

@end
