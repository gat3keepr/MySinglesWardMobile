//
//  User+Create.m
//  MySinglesWard
//
//  Created by Porter Hoskins on 4/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "User+Create.h"
#import "Ward+Create.h"
#import "NotificationPreference+Create.h"
#import "Photo+Create.h"
#import "MemberSurvey+Create.h"

@implementation User (Create)

#define USER @"User"

+(User *) userWithJSON:(NSDictionary *)data inManagedObjectContext:(NSManagedObjectContext *)context
{
    User *user = nil;
    
    //Get ID out of data
    NSNumber *memberID = [data objectForKey:@"MemberID"];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:USER];
    request.predicate = [NSPredicate predicateWithFormat:@"memberID = %@", memberID];
    
    NSError *error = nil;
    NSArray *member = [context executeFetchRequest:request error:&error];
    
    if(!member || ([member count] > 1))
    {
        //That should not happen
    }
    else if(![member count])
    {
        user = [NSEntityDescription insertNewObjectForEntityForName:USER inManagedObjectContext:context];
        
        user.firstname = [data objectForKey:@"FirstName"];
        user.email = [data objectForKey:@"Email"];
        user.lastname = [data objectForKey:@"LastName"];
        user.memberID = [data objectForKey:@"MemberID"];
        user.username = [data objectForKey:@"UserName"];
        user.wardID = [data objectForKey:@"WardStakeID"];
        user.isBishopric = [data objectForKey:@"IsBishopric"];        
        user.prefname = [data objectForKey:@"PrefName"];        
        user.cellphone = [data objectForKey:@"CellPhone"];        
        user.residence = [data objectForKey:@"Residence"];
        
        user.ward = [Ward wardWithID:user.wardID inManagedObjectContext:context];
    }
    else {
        user = [member lastObject];
    }
    
    return user;
}

+(User *) userWithID:(NSNumber *)memberID inManagedObjectContext:(NSManagedObjectContext *)context
{
    User *user = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:USER];
    request.predicate = [NSPredicate predicateWithFormat:@"memberID = %@", memberID];
    
    NSError *error = nil;
    NSArray *member = [context executeFetchRequest:request error:&error];
    
    if(!member || ([member count] > 1))
    {
        //That should not happen
    }
    else {
        user = [member lastObject];
    }

    return user;
}

+(User *) userWithAllMemberData:(NSDictionary *)memberData inManagedObjectContext:(NSManagedObjectContext *)context
{
    User *user = [User userWithJSON:[memberData objectForKey:@"user"] inManagedObjectContext:context];
    
    if([memberData objectForKey:@"memberSurvey"])
    {
        [MemberSurvey surveyWithJSON:[memberData objectForKey:@"memberSurvey"] inManagedObjectContext:context];
    }
    
    if([memberData objectForKey:@"photo"])
    {
        [Photo photoWithJSON:[memberData objectForKey:@"photo"] inManagedObjectContext:context];
    }
    
    if ([memberData objectForKey:@"notificationPreference"]) 
    {
        [NotificationPreference notificationPreferenceWithJSON:[memberData objectForKey:@"notificationPreference"] inManagedObjectContext:context];
    }
    
    return user;
}

@end
