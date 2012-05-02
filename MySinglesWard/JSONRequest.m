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
            NSLog(@"JSON ERROR: %@",[errorReturned localizedDescription]);
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
        return nil;
    }
    
}

@end
