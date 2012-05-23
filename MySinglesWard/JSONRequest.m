//
//  JSONRequest.m
//  MyStuff
//
//  Created by Porter Hoskins on 3/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JSONRequest.h"

@implementation JSONRequest

+(NSDictionary*)makeWebRequestWithURL:(NSString *)url withJSONData:(NSData *)jsonData
{    
    @try {
        NSString* requestDataLengthString = [[NSString alloc] initWithFormat:@"%d", [jsonData length]];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[[NSURL alloc] initWithString:url]];
        
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:jsonData];
        [request setHTTPShouldHandleCookies:YES];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:requestDataLengthString forHTTPHeaderField:@"Content-Length"];
        
        NSError *errorReturned = nil;
        NSURLResponse *response = [[NSURLResponse alloc] init];
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&errorReturned];    
        
        if(errorReturned)
        {
            //Check to see if there was an error
            NSLog(@"REQUEST ERROR: %@",[errorReturned localizedDescription]);
            return nil;
        }
        
        NSError *jsonError = nil;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
        
        if(jsonError)
        {
            NSLog(@"JSON ERROR: %@", [jsonError localizedDescription]);
            return nil;
        }
        
        return json;
    }
    @catch (NSException *exception) {
        NSLog(@"REQUEST ERROR: %@", [exception description]);
    }
    
}

+(NSDictionary *)requestForBishopricData
{
    NSString *bishopricurl = [[NSString alloc] initWithFormat:@"%@api/ward/bishopric", MSWRequestURL];
    NSLog(@"BISHOPRIC LIST DATA URL request: %@", bishopricurl);

    NSDictionary *bishopricData = [JSONRequest makeWebRequestWithURL:bishopricurl withJSONData:nil];
    NSLog(@"BISHOPRIC LIST DATA response: %@", bishopricData);
    
    return bishopricData;
}

+(NSDictionary *)requestForWardListData
{
    //Create the URL for the web request to get all the ward members
    NSString *url = [[NSString alloc] initWithFormat:@"%@api/ward/list", MSWRequestURL];
    NSLog(@"WARD LIST DATA URL request: %@", url);
    
    NSDictionary *wardListData = [JSONRequest makeWebRequestWithURL:url withJSONData:nil];
    NSLog(@"WARD LIST DATA response: %@", wardListData);
    
    return wardListData;
}

+(NSDictionary *)requestForMemberData
{
    //Start the data loading of the ward list
    NSString *url = [[NSString alloc] initWithFormat:@"%@api/member", MSWRequestURL];
    NSLog(@"MEMBER DATA URL request: %@", url);
    
    NSDictionary *memberData = [JSONRequest makeWebRequestWithURL:url withJSONData:nil];
    NSLog(@"MEMBER DATA response: %@", memberData);
    
    return memberData;
}

+(void)requestForMemberStatus
{
    //Start the data loading of the ward list
    NSString *url = [[NSString alloc] initWithFormat:@"%@api/member/checkstatus", MSWRequestURL];
    NSLog(@"MEMBER DATA URL request: %@", url);
    
    NSDictionary *memberStatus = [JSONRequest makeWebRequestWithURL:url withJSONData:nil];
    NSLog(@"MEMBER DATA response: %@", memberStatus);
    
    [[NSUserDefaults standardUserDefaults] setObject:[memberStatus objectForKey:@"status"] forKey:MEMBER_STATUS];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
