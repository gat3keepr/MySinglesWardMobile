//
//  NotificationPreference+Create.m
//  MySinglesWard
//
//  Created by Porter Hoskins on 4/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NotificationPreference+Create.h"
#import "User+Create.h"

@implementation NotificationPreference (Create)

#define NOTIFICATION_PREF @"NotificationPreference"

+(NotificationPreference *) notificationPreferenceWithJSON:(NSDictionary *) data inManagedObjectContext:(NSManagedObjectContext *)context
{
    NotificationPreference *notificationPref = nil;
    
    //Get memberID from data
    NSNumber *memberID = [data objectForKey:@"MemberID"];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NOTIFICATION_PREF];
    request.predicate = [NSPredicate predicateWithFormat:@"memberID = %@", memberID];
    
    NSError *error = nil;
    NSArray *prefs = [context executeFetchRequest:request error:&error];
    
    if(!prefs || [prefs count] > 1)
    {
        
    }
    else if (![prefs count]) {
        notificationPref = [NSEntityDescription insertNewObjectForEntityForName:NOTIFICATION_PREF inManagedObjectContext:context];
        
        notificationPref.memberID = [data objectForKey:@"MemberID"];
        notificationPref.activities = [data objectForKey:@"activities"];
        notificationPref.carrier = [data objectForKey:@"carrier"];
        notificationPref.elders = [data objectForKey:@"elders"];
        notificationPref.email = [data objectForKey:@"email"];
        notificationPref.fhe = [data objectForKey:@"fhe"];
        notificationPref.reliefsociety = [data objectForKey:@"reliefsociety"];
        notificationPref.stake = [data objectForKey:@"stake"];
        notificationPref.txt = [data objectForKey:@"txt"];
        notificationPref.ward = [data objectForKey:@"ward"];
        
        notificationPref.member = [User userWithID:memberID inManagedObjectContext:context];
    }
    else 
    {
        notificationPref = [prefs lastObject];
    }
    
    return notificationPref;
}

+(NotificationPreference *) notificationPreferenceWithID:(NSNumber *)memberID inManagedObjectContext:(NSManagedObjectContext *)context
{
    NotificationPreference *pref = nil;
    
    //Get memberID from data
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NOTIFICATION_PREF];
    request.predicate = [NSPredicate predicateWithFormat:@"memberID = %@", memberID];
    
    NSError *error = nil;
    NSArray *prefs = [context executeFetchRequest:request error:&error];
    
    if(!prefs || [prefs count] > 1)
    {
        
    }
    else 
    {
        pref = [prefs lastObject];
    }
    
    return pref;
}

@end
