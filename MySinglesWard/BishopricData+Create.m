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
#import "JSONRequest.h"

@implementation BishopricData (Create)

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
    }
    else {
        bData = [member lastObject];
    }
    
    bData.memberID = [data objectForKey:@"MemberID"];
    bData.wifeName = [data objectForKey:@"WifeName"];
    bData.wifePhone = [data objectForKey:@"WifePhone"];
    bData.sortID = [data objectForKey:@"SortID"];
    
    bData.member = [User userWithID:bData.memberID inManagedObjectContext:context];
    
    if([[data objectForKey:@"BishopricCalling"] isKindOfClass:[NSNull class]])
        bData.member.calling.title = @"Not Available";
    else
        bData.member.calling.title = [data objectForKey:@"BishopricCalling"];
    
    return bData;
}

-(NSDictionary *) toDictionary
{
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    
    [data setObject:self.memberID forKey:@"MemberID"];
    [data setObject:self.wifeName forKey:@"WifeName"];
    [data setObject:self.wifePhone forKey:@"WifePhone"];
    [data setObject:self.sortID forKey:@"SortID"];
    [data setObject:self.member.calling.title forKey:@"BishopricCalling"];
    [data setObject:self.member.cellphone forKey:@"BishopricPhone"];
    [data setObject:self.member.residence forKey:@"BishopricAddress"];
    [data setObject:self.member.prefname forKey:@"BishopricName"];
    
    return [data copy];
}

-(void) saveDataToServer
{
    //Create the URL for the web request to save the survey
    NSString *url = [[NSString alloc] initWithFormat:@"%@api/member/savebishopricdata", MSWRequestURL];
    NSLog(@"SAVE BISHOPRIC DATA URL request: %@", url);
    
    //get a dictionary of all the field
    NSError *error = nil;
    NSLog(@"SAVE BISHOPRIC DATA: %@", [self toDictionary]);
    
    [JSONRequest makeWebRequestWithURL:url withJSONData:[NSJSONSerialization dataWithJSONObject:[NSDictionary dictionaryWithObject:[self toDictionary]  forKey:@"data"] options:NSJSONWritingPrettyPrinted error:&error]];
}

@end
