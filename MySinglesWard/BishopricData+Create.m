//
//  BishopricData+Create.m
//  MySinglesWard
//
//  Created by Porter Hoskins on 5/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BishopricData+Create.h"
#import "User+Create.h"
#import "Calling.h"

@implementation BishopricData (Create)

#define BISHOPRIC_DATA @"BishopricData"

+(BishopricData *) dataWithJSON:(NSDictionary *)data inManagedObjectContext:(NSManagedObjectContext *)context
{
    BishopricData *bData = nil;
    
    //Get ID out of data
    NSNumber *memberID = [data objectForKey:@"MemberID"];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:BISHOPRIC_DATA];
    request.predicate = [NSPredicate predicateWithFormat:@"memberID = %@", memberID];
    
    NSError *error = nil;
    NSArray *member = [context executeFetchRequest:request error:&error];
    
    if(!member || ([member count] > 1))
    {
        //That should not happen
    }
    else if(![member count])
    {
        bData = [NSEntityDescription insertNewObjectForEntityForName:BISHOPRIC_DATA inManagedObjectContext:context];
        
        bData.memberID = [data objectForKey:@"MemberID"];
        bData.wifeName = [data objectForKey:@"WifeName"];
        bData.wifePhone = [data objectForKey:@"WifePhone"];
        bData.sortID = [data objectForKey:@"SortID"];
        
        bData.member = [User userWithID:bData.memberID inManagedObjectContext:context];
        
        if([[data objectForKey:@"BishopricCalling"] isKindOfClass:[NSNull class]])
            bData.member.calling.title = @"Not Available";
        else
            bData.member.calling.title = [data objectForKey:@"BishopricCalling"];
    }
    else {
        bData = [member lastObject];
    }
    
    return bData;
}


@end
