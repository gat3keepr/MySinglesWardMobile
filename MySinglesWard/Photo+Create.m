//
//  Photo+Create.m
//  MySinglesWard
//
//  Created by Porter Hoskins on 4/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Photo+Create.h"
#import "User+Create.h"
#import "JSONRequest.h"

@implementation Photo (Create)
#define PHOTO @"Photo"

+(Photo *) photoWithJSON:(NSDictionary *) data inManagedObjectContext:(NSManagedObjectContext *)context
{
    //NSNumber *NONE = [NSNumber numberWithInt:0];
    //NSNumber *UPLOADED = [NSNumber numberWithInt:1];
    NSNumber *CROPPED = [NSNumber numberWithInt:2];
//    NSNumber *MODERATED = [NSNumber numberWithInt:3];
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
    }
    else 
    {
        photo = [photos lastObject];
    }
    
    NSNumber *newStatus = [data objectForKey:@"Status"];
    BOOL needsReload = (photo.status != newStatus) || ![[data objectForKey:@"FileName"] isEqualToString:photo.filename];
    
    NSData *photoData = photo.photoData;
    photo.status = [data objectForKey:@"Status"];
    if(needsReload)
    {
        if(photo.status == CROPPED)
            photoData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", MSWPhotoURL, @"profile-approval.jpg"]]];
        else
            photoData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", MSWPhotoURL, [data objectForKey:@"FileName"]]]];
    }
    photo.filename = [data objectForKey:@"FileName"];
    photo.memberID = [data objectForKey:@"MemberID"];
    photo.member = [User userWithID:memberID inManagedObjectContext:context];
    
    if(![[data objectForKey:@"NewPhotoFileName"] isKindOfClass:[NSNull class]])
        photo.newPhotoFileName = [data objectForKey:@"NewPhotoFileName"];
    photo.photoData = photoData; 
    
    return photo;
}



@end
