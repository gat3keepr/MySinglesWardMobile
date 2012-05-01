//
//  Photo+Create.m
//  MySinglesWard
//
//  Created by Porter Hoskins on 4/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Photo+Create.h"
#import "User+Create.h"

@implementation Photo (Create)
#define PHOTO @"Photo"

+(Photo *) photoWithJSON:(NSDictionary *) data inManagedObjectContext:(NSManagedObjectContext *)context
{
    Photo *photo = nil;
    
    //Get memberID from data
    NSNumber *memberID = [data objectForKey:@"MemberID"];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:PHOTO];
    request.predicate = [NSPredicate predicateWithFormat:@"memberID = %@", memberID];
    
    NSError *error = nil;
    NSArray *photos = [context executeFetchRequest:request error:&error];
    
    if(!photos || [photos count] > 1)
    {
        
    }
    else if (![photos count]) {
        photo = [NSEntityDescription insertNewObjectForEntityForName:PHOTO inManagedObjectContext:context];
        
        photo.filename = [data objectForKey:@"FileName"];
        photo.memberID = [data objectForKey:@"MemberID"];
        photo.member = [User userWithID:memberID inManagedObjectContext:context];
    }
    else 
    {
        photo = [photos lastObject];
    }
    
    return photo;
}

@end
