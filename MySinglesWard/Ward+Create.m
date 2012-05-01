//
//  Ward+Create.m
//  MySinglesWard
//
//  Created by Porter Hoskins on 4/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Ward+Create.h"

@implementation Ward (Create)

#define WARD @"Ward"

+(Ward *) wardWithJSON:(NSDictionary *) data inManagedObjectContext:(NSManagedObjectContext *)context
{
    Ward *ward = nil;
    
    //Get memberID from data
    NSNumber *wardID = [data objectForKey:@"WardStakeID"];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:WARD];
    request.predicate = [NSPredicate predicateWithFormat:@"wardID = %@", wardID];
    
    NSError *error = nil;
    NSArray *wards = [context executeFetchRequest:request error:&error];
    
    if(!wards || [wards count] > 1)
    {
        
    }
    else if (![wards count]) {
        ward = [NSEntityDescription insertNewObjectForEntityForName:WARD inManagedObjectContext:context];
        
        ward.wardID = [data objectForKey:@"WardStakeID"];
        ward.location = [data objectForKey:@"Location"];
        ward.stake = [data objectForKey:@"Stake"];
        ward.stakeID = [data objectForKey:@"StakeID"];
        ward.ward = [data objectForKey:@"ward"];
    }
    else 
    {
        ward = [wards lastObject];
    }
    
    return ward;
}

+(Ward *) wardWithID:(NSNumber *)wardID inManagedObjectContext:(NSManagedObjectContext *)context
{
    Ward *ward = nil;
    
    //Get memberID from data
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:WARD];
    request.predicate = [NSPredicate predicateWithFormat:@"wardID = %@", wardID];
    
    NSError *error = nil;
    NSArray *wards = [context executeFetchRequest:request error:&error];
    
    if(!wards || [wards count] > 1)
    {
        
    }
    else 
    {
        ward = [wards lastObject];
    }
    
    return ward;
}

@end
